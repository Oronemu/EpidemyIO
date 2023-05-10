//
//  SimulationModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 09.05.2023.
//

import Foundation

class SimulationModel: ObservableObject {
	
	private var infectorIndicies: [Int] = []
	private var group: [Person] = []
	private var timer: DispatchSourceTimer?

	private var infectionInterval: Int
	private var InfectionFactor: Int
	private var columns: Int
	private var groupSize: Int
	
	private var healthyPeople: Int = 0
	private var infectedPeople: Int = 0
	
	private var callback: (Int, Int) -> Void
	
	init(groupSize: Int, infectionInterval: Int, InfectionFactor: Int, columns: Int, callback: @escaping (Int, Int) -> Void) {
		self.groupSize = groupSize
		self.infectionInterval = infectionInterval
		self.InfectionFactor = InfectionFactor
		self.columns = columns
		self.callback = callback
	}
	
	func createGroup(_ completion: @escaping ([Person]) -> Void ){
		DispatchQueue.global(qos: .background).async {
			let group = (0...self.groupSize-1).map { _ in Person() }
			self.healthyPeople = group.count
			DispatchQueue.main.async {
				self.group = group
				completion(group)
			}
		}
	}
	
	func startSimulation() {
		if timer == nil {
			timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
			timer?.schedule(deadline: .now(), repeating: Double(infectionInterval))
			timer?.setEventHandler(handler: simulationLoop)
			timer?.resume()
		}
	}
	
	func stopSimulation() {
		timer?.cancel()
		timer = nil
		self.group.removeAll()
		self.infectorIndicies.removeAll()
	}
	
	func addToInfectors(infectorIndex: Int, _ completion: @escaping (Int, Int) -> Void) {
		self.group[infectorIndex].infect()
		self.infectorIndicies.append(infectorIndex)
		self.incrementInfectedPeopleCount()
		completion(self.infectedPeople, self.healthyPeople)
	}
	 
	private func incrementInfectedPeopleCount() {
		self.infectedPeople += 1
		self.healthyPeople -= 1
	}
	
	private func simulationLoop() {
		let currentInfectorIndicies = self.infectorIndicies
		self.infectorIndicies = []
		
		for infectorIndex in currentInfectorIndicies {
			let neighbours = getHealthyNeighbours(of: infectorIndex).shuffled()
			guard !neighbours.isEmpty else { continue }
			
			var range: Int {
				if neighbours.count > InfectionFactor {
					return InfectionFactor
				} else {
					return neighbours.count
				}
			}
			
			let neighbourInfectors = neighbours[0..<range]
						
			for neighbour in neighbourInfectors {
				neighbour.person.infect()
				self.incrementInfectedPeopleCount()
				self.infectorIndicies.append(neighbour.index)
			}
		}
		DispatchQueue.main.async {
			self.callback(self.infectedPeople, self.healthyPeople)
		}
	}
	
	private func getHealthyNeighbours(of index: Int) -> [(person: Person, index: Int)]{
		let n = 1
		var res: [(Person, Int)] = []
		
		let top = max(0, index / columns - n)
		let bottom = min((group.count - 1) / columns, index / columns + n)
		let left = max(0, index % columns - n)
		let right = min(columns - 1, index % columns + n)
		
		for row in top...bottom {
			for column in left...right {
				let currentIdx = row * columns + column
				if index != currentIdx && currentIdx < group.count {
					let currentPerson = group[currentIdx]
					if !currentPerson.isInfected {
						res.append((currentPerson, currentIdx))
					}
				}
			}
		}
		
		return res
	}
}
