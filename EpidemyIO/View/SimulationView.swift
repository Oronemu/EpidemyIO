//
//  SimulationView.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 06.05.2023.
//

import SwiftUI

struct SimulationView: View {
	
	@EnvironmentObject private var viewModel: SimulationViewModel
	
	var body: some View {
		ZStack {
			ScrollView {
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 10),
									alignment: .center,
									spacing: 6) {
					ForEach(viewModel.group.indices, id: \.self) { index in
						PersonView(index: index)
					}
				}
				.padding(.bottom, 100)
			}
			
			VStack {
				Spacer()
				BottomBarView()
			}
		}
		.onAppear {
			viewModel.startSimulation()
		}
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {} label: {
					Image(systemName: "ellipsis")
				}
			}
		}
	}
}

struct PersonView: View {
	
	@EnvironmentObject private var viewModel: SimulationViewModel
	
	var index: Int

	var body: some View {
		Button {
			self.viewModel.infect(personIndex: index)
			self.viewModel.updateView()
		} label: {
			Image(systemName: "figure.stand")
				.foregroundColor(viewModel.group[index].isInfected ? .red : .green)
				.font(.system(size: 40))
		}
		.buttonStyle(ScaleButtonStyle())
	}
}

struct BottomBarView: View {
	
	@EnvironmentObject private var viewModel: SimulationViewModel
	@Environment(\.colorScheme) private var colorScheme
	@State private var isViewPushed = false

	var body: some View {
		HStack {
			
			VStack {
				Image(systemName: "figure.stand")
				Text("\(viewModel.healthyPeople)")
					.lineLimit(1)
					.font(.system(size: 10))
			}
			.frame(maxWidth: 20)
			.padding(18)
			.foregroundColor(.green)
			.background(Color(colorScheme == .light ? .white : .systemGray5))
			.clipShape(Circle())
			.shadow(radius: 15)
			
			Spacer()
			
			Button {
				isViewPushed.toggle()
				viewModel.stopSimulation()
			} label: {
				Text("Остановить симуляцию")
					.padding(20)
					.background(Color(.systemBlue))
					.foregroundColor(.white)
					.clipShape(Capsule())
			}
			.buttonStyle(ScaleButtonStyle())
			.navigationDestination(isPresented: $isViewPushed) {
				SetupView()
			}
			
			Spacer()
			
			VStack {
				Image(systemName: "figure.stand")
				Text("\(viewModel.infectedPeople)")
					.lineLimit(1)
					.font(.system(size: 10))
			}
			.frame(maxWidth: 20)
			.padding(18)
			.foregroundColor(.red)
			.background(Color(colorScheme == .light ? .white : .systemGray5))
			.clipShape(Circle())
			.shadow(radius: 15)
		}
		.padding(.horizontal)
	}
}

struct SimulationView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
		SimulationView()
			.environmentObject(SimulationViewModel())
	}
}


