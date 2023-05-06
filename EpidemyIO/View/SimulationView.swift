//
//  SimulationView.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct SimulationView: View {
	
	@EnvironmentObject private var viewModel: SimulationViewModel

	let columns = Array(repeating: GridItem(.flexible()), count: 10)
	
	var body: some View {
		ScrollView {
			HStack {
				Text("Здоровых: \(viewModel.group.count - viewModel.getInfected())")
				Spacer()
				Text("Зараженных: \(viewModel.getInfected())")
			}
			.padding(.horizontal)
			LazyVGrid(columns: columns) {
				ForEach(viewModel.group.indices, id: \.self) { index in
					Image(systemName: "figure.stand")
						.foregroundColor(viewModel.group[index].isInfected ? .red : .green)
						.font(.system(size: 40))
						.onTapGesture {
							viewModel.group[index].isInfected = true
						}
				}
			}
		}
		.onAppear {
			viewModel.createGroup()
		}
	}
}

struct SimulationView_Previews: PreviewProvider {
	static var previews: some View {
		SetupView()
//		SimulationView()
	}
}


