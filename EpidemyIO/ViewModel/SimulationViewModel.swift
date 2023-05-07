//
//  File.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
	
	var infectionSpreadModel: InfectionSpreadModel = .init()
	
	var groupSize: Int?
	var infectionFactor: Int?
	var T: Int?
	
	@Published var infectedCount: Int = 0
	@Published var healtyCount: Int = 0
	@Published var group: [Person] = []
	
	func startSimulation() {
		self.createGroup()
		self.healtyCount = self.group.count
	}
		
	func createGroup() {
		group.removeAll()
		if let groupSize {
			self.group = (1...groupSize).map { _ in Person() }
		}
	}
	
	func incrementInfectedCount() {
		self.infectedCount += 1
		self.healtyCount -= 1
	}
	
}
