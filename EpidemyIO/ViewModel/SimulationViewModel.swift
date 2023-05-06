//
//  File.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
	@Published var groupSize: Int? 
	@Published var infectionFactor: Int?
	@Published var T: Int?
	
	@Published var group: [Person] = []
	
	func createGroup() {
		self.group = Array(repeating: Person(), count: self.groupSize ?? 0)
	}
	
	func getInfected() -> Int {
		var infected = 0
		for person in self.group {
			if person.isInfected {
				infected += 1
			}
		}
		return infected
	}
	
}
