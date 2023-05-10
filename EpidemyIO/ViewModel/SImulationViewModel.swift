//
//  NewSImulationViewModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 09.05.2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
	
	var simulationModel: SimulationModel?
	
	@Published var groupSize: Int?
	@Published var infectionInterval: Int?
	@Published var infectionFactor: Int?
	
	var group: [Person] = []
	@Published var healthyPeople = 0
	@Published var infectedPeople = 0
	
	@Published var state: State = .idle
	
	enum State {
		case loading
		case idle
	}
	
	func startSimulation() {
		self.state = .loading
		
		guard let groupSize = groupSize, let infectionInterval = infectionInterval, let infectionFactor = infectionFactor else {
			self.state = .idle
			return
		}
		
		self.simulationModel = SimulationModel(groupSize: groupSize, infectionInterval: infectionInterval, InfectionFactor: infectionFactor, columns: 10) { infectedPeople, healthyPeople in
			self.infectedPeople = infectedPeople
			self.healthyPeople = healthyPeople
		}
		
		self.simulationModel?.createGroup { group in
			self.group = group
			self.healthyPeople = group.count
			self.state = .idle
		}
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
}
