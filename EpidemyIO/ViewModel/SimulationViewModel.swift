//
//  File.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
	
	var infectionModel: InfectionSpreadModel?
		
	var groupSize: Int?
	var infectionFactor: Int?
	var T: Int?
		
	@Published var infectedCount: Int = 0
	@Published var healtyCount: Int = 0
	@Published var group: [Person] = []
	var columnsCount = 10
	var groupIndicies: [Person.ID : Int ] = [:]
	
	
	func startSimulation() {
		self.createGroup()
		self.healtyCount = self.group.count
		
		infectionModel = InfectionSpreadModel(group: group, groupIndicies: groupIndicies, columns: columnsCount, T: T!, infectionFactor: infectionFactor!) { infectedPeople in
			self.infectedCount += infectedPeople
			self.healtyCount -= infectedPeople
		}
		infectionModel?.startSpread()
	}
	
	func stopSimulation() {
		infectionModel?.stopSpread()
		group.removeAll()
		groupIndicies.removeAll()
		infectedCount = 0
		healtyCount = 0
	}
		
	func createGroup() {
		guard let groupSize else { return }
		self.group = (0...groupSize-1).map { _ in Person() }
		self.groupIndicies = Dictionary(uniqueKeysWithValues: zip(self.group.map { person in person.id}, (0...groupSize-1)))
	}
	
	func incrementInfectedCount() {
		self.infectedCount += 1
		self.healtyCount -= 1
	}
	
	func personInfected(person: Person) {
		person.infect()
		infectionModel?.infectedPeople.append(person)
	}
}
