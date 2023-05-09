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
		self.simulationModel = SimulationModel(groupSize: groupSize!, infectionInterval: infectionInterval!, InfectionFactor: infectionFactor!, columns: 10) { infected, health in
			self.infectedPeople = infected
			self.healthyPeople = health
		}
		self.group = (self.simulationModel?.createGroup())!
		simulationModel?.startSimulation()
	}
	
	func stopSimulation() {
		simulationModel?.stopSimulation()
	}
	
	func infect(personIndex: Int) {
		group[personIndex].infect()
		simulationModel?.incrementInfectedPeopleCount()
		simulationModel?.infectorIndicies.append(personIndex)
	}
	
	func updateView(){
		self.objectWillChange.send()
	}
	
}
