//
//  NewSImulationViewModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 09.05.2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
	
	var simulationModel: SimulationModel?
	
	var groupSize: Int?
	var infectionInterval: Int?
	var infectionFactor: Int?
	
	@Published var group: [Person] = []
	@Published var healthyPeople = 0
	@Published var infectedPeople = 0
	
	func startSimulation() {
		guard let groupSize = groupSize, let infectionInterval = infectionInterval, let infectionFactor = infectionFactor else {
			return
		}
		
		self.simulationModel = SimulationModel(groupSize: groupSize, infectionInterval: infectionInterval, InfectionFactor: infectionFactor, columns: 10) { infectedPeople, healthyPeople in
			self.infectedPeople = infectedPeople
			self.healthyPeople = healthyPeople
		}
		
		self.simulationModel?.createGroup { group in
			self.group = group
			self.healthyPeople = group.count
		}
		
		simulationModel?.startSimulation()
	}
	
	func stopSimulation() {
		simulationModel?.stopSimulation()
	}
	
	func infect(personIndex: Int) {
		self.simulationModel?.addToInfectors(infectorIndex: personIndex) { infectedPeople, healthyPeople in
			self.infectedPeople = infectedPeople
			self.healthyPeople = healthyPeople
		}
	}
	
	func updateView(){
		self.objectWillChange.send()
	}
}
