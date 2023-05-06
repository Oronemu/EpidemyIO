//
//  ContentView.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct SetupView: View {
	
	@EnvironmentObject private var viewModel: SimulationViewModel
	
	var body: some View {
		NavigationStack {
			VStack {
				Text("Настройки симуляции")
					.font(.system(size: 25, weight: .semibold))
					.padding(.bottom, 25)
				VStack(alignment: .leading) {
					Text("Количество людей в группе")
					TextField("Например: 200", value: $viewModel.groupSize, format: .number)
					Text("Количество зараженных при контакте")
					TextField("Например: 200", value: $viewModel.infectionFactor, format: .number)
					Text("Период пересчета кол-ва зараженных")
					TextField("Например: 5", value: $viewModel.T, format: .number)
				}
				
				NavigationLink(destination: SimulationView()) {
					Text("Запустить моделирование" )
				}
			}
			.padding()
		}
	}
}

struct SetupView_Previews: PreviewProvider {
	static var previews: some View {
		SetupView()
	}
}
