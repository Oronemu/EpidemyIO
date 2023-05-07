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
	
	var infectedCount: Int = 0 {
		didSet {
			objectWillChange.send()
		}
	}
	
	var healtyCount: Int = 0 {
		didSet {
			objectWillChange.send()
		}
	}
	
	var group: [Person] = [] {
		didSet {
			objectWillChange.send()
		}
	}
		
	func createGroup() {
		if let groupSize {
			self.group = (1...groupSize).map { _ in Person() }
		}
	}
	
	func incrementInfectedCount() {
		self.infectedCount += 1
		self.healtyCount -= 1
	}
	
}
