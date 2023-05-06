//
//  ContentView.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct ContentView: View {
	
	private var simulationViewModel = SimulationViewModel()
	
	var body: some View {
		SetupView()
		.environmentObject(simulationViewModel)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
