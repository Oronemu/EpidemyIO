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
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: viewModel.columnsCount),
									alignment: .center,
									spacing: 6) {
					ForEach(viewModel.group) { person in
						PersonView(person: person)
					}
				}
			}
			
			VStack {
				Spacer()
				BottomBarView()
			}
		}
		.onAppear {
			viewModel.startSimulation()
			print(viewModel.group.count)
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

	@ObservedObject var person: Person
	@EnvironmentObject private var viewModel: SimulationViewModel

	var body: some View {
		Button {
			self.viewModel.personInfected(person: person)
			self.viewModel.incrementInfectedCount()
		} label: {
			Image(systemName: "figure.stand")
				.foregroundColor(person.isInfected ? .red : .green)
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
				Text("\(viewModel.healtyCount)")
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
				Text("\(viewModel.infectedCount)")
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


