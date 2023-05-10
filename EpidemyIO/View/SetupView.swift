//
//  ContentView.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct SetupView: View {
	
	@EnvironmentObject private var viewModel: SimulationViewModel
	@State private var showAlert = false
	@State private var alertMessage = ""
	
	var body: some View {
		NavigationStack {
			VStack {
				VStack {
					Image(systemName: "microbe")
						.font(.system(size: 150))
						.foregroundColor(Color(.systemGreen))
					Text("EpidemyIO")
						.bold()
						.font(.title)
				}
				.padding(.bottom)
				
				Text("Настройки симуляции")
					.font(.system(size: 25, weight: .semibold))
				
				VStack(alignment: .leading, spacing: 20) {
						Text("Количество людей в группе")
					CustomNumberTextField(placeholder: "Например: 200", value: $viewModel.groupSize)
						Text("Количество зараженных при контакте")
					CustomNumberTextField(placeholder: "Например: 3", value: $viewModel.infectionFactor)
						Text("Период пересчета кол-ва зараженных")
					CustomNumberTextField(placeholder: "Например: 5", value: $viewModel.infectionInterval)
				}
				.padding(.vertical)
				
				NavigationLink(destination: SimulationView()) {
					Text("Запустить моделирование" )
						.padding(20)
						.background(Color(.systemBlue))
						.foregroundColor(.white)
						.clipShape(Capsule())
				}
				.disabled(!areFieldsFilled())
				.buttonStyle(ScaleButtonStyle())
			}
			.padding()
			.toolbar(.hidden)
		}
	}
	
	private func areFieldsFilled() -> Bool {
			guard let groupSize = viewModel.groupSize,
						let infectionInterval = viewModel.infectionInterval,
						let infectionFactor = viewModel.infectionFactor else {
					return false
			}
			
		return groupSize != 0 && infectionInterval != 0 && infectionFactor != 0
	}
}

struct SetupView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
