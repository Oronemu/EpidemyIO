//
//  PersonModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import Foundation

struct Person: Identifiable {
	let id = UUID()
	var isInfected: Bool = false
}
