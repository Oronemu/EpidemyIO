//
//  PersonModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

class Person: ObservableObject, Identifiable {
		
	let id = UUID()
	
	@Published var isInfected: Bool = false 
	
	var isInfectious: Bool = false
	
	func infect() {
		self.isInfected = true
	}
	
}
