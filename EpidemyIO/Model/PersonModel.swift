//
//  PersonModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

class Person: ObservableObject {
	
	@Published var isInfected: Bool = false 
		
	func infect() {
		self.isInfected = true
	}
	
}
