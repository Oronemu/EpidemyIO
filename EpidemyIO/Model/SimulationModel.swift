//
//  SimulationModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 09.05.2023.
//

import Foundation

class SimulationModel: ObservableObject {
	
	var group: [Person] = []
	var infectorIndicies: [Int] = []
	var timer: DispatchSourceTimer?

	var infectionInterval: Int
	var InfectionFactor: Int
	var columns: Int
	var groupSize: Int {
		didSet(newValue) {
			self.healthyPeople = newValue
		}
	}
	
	var healthyPeople: Int = 0
	var infectedPeople: Int = 0
	
	var callback: (Int, Int) -> Void
	
	init(groupSize: Int, infectionInterval: Int, InfectionFactor: Int, columns: Int, callback: @escaping (Int, Int) -> Void) {
		self.groupSize = groupSize
		self.infectionInterval = infectionInterval
		self.InfectionFactor = InfectionFactor
		self.columns = columns
		self.callback = callback
	}
	
	func createGroup() -> [Person] {
		self.group = (0...groupSize-1).map { _ in Person() }
		return self.group
	}
	
	func startSimulation() {
		self.healthyPeople = self.group.count
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
	}
	
	func incrementInfectedPeopleCount() {
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
