//
//  PersonModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

class Person: ObservableObject, Identifiable {
		
	let id = UUID()
	
	var isInfected: Bool = false {
		didSet {
			objectWillChange.send()
		}
	}
	
	var isInfectious: Bool = false
	
	func infect() {
		self.isInfected = true
	}
	
}
