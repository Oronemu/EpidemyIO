//
//  InfectionSpreadModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 07.05.2023.
//

import Foundation

class InfectionSpreadModel {
	
	var group: [Person]
	var infectedPeople: [Person] = []
	var groupIndicies: [Person.ID : Int ]
	var columns: Int
	var T: Int
	var infectionFactor: Int
	var timer: Timer?
	
	var callback: (Int) -> Void
	
	init(group: [Person], groupIndicies: [Person.ID : Int], columns: Int, T: Int, infectionFactor: Int, callback: @escaping (Int) -> Void) {
		self.group = group
		self.groupIndicies = groupIndicies
		self.columns = columns
		self.T = T
		self.infectionFactor = infectionFactor
		self.callback = callback
	}
	
	func startSpread() {		
		if timer == nil {
			timer = Timer.scheduledTimer(withTimeInterval: Double(T), repeats: true) { timer in
				for person in self.infectedPeople {
					if person.isInfectious {
						let index = self.groupIndicies[person.id]
						let neighbours = self.getHealthyNeighbours(of: index!)
						var peopleInfected = 0
						for neighbour in neighbours.shuffled() {
							if peopleInfected < self.infectionFactor {
								neighbour.infect()
								self.infectedPeople.append(neighbour)
								peopleInfected += 1
							}
						}
						self.callback(peopleInfected)
						person.isInfectious = false
					}
				}
			}
		}
	}

	private func getHealthyNeighbours(of index: Int) -> [Person]{
		let n = 1
		var res: [Person] = []
		
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
						res.append(currentPerson)
					}
				}
			}
		}
		
		return res
	}
	
	func stopSpread() {
		timer?.invalidate()
		timer = nil
	}
}

