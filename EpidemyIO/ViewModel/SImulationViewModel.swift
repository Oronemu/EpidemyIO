//
//  NewSImulationViewModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 09.05.2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
	
	var simulationModel: SimulationModel?
	
	// MARK: Заполняемые пользователем поля
	// Т.к. ViewModel создается еще до того как будет использована
	// на экране заполнения данных симуляции, то создаем все поля Optional<Int>
	@Published var groupSize: Int?
	@Published var infectionInterval: Int?
	@Published var infectionFactor: Int?
	
	// MARK: Счетчики и обработка состояний для View
	// Аналогично сказанному выше выставляем дефолтное состояние и счетчики
	@Published var healthyPeople = 0
	@Published var infectedPeople = 0
	@Published var state: State = .idle
	
	// MARK: Массив людей для View
	var group: [Person] = []
	
	enum State {
		case loading
		case idle
	}
	
	// MARK: Метод запуска симуляции
	// Далее создаем модель по полученным данным с полей ввода и запускаем ее с помощью .startSimulation()
	//
	// корректное количество зараженных и больных людей, так как вся подобная информация хранится исключительно в моделе
	// С группой аналогичная ситуация. Так как сама группая хранится в моделе и создается в background потоке, то мы
	// возвращаем ее ViewModel, чтобы ViewModel могла передавать View корректную группу для отображения
	func startSimulation() {
		self.state = .loading
		
		// Обрабатываем nil поля, чтобы случайно не пердать их в модель
		guard let groupSize = groupSize, let infectionInterval = infectionInterval, let infectionFactor = infectionFactor else {
			self.state = .idle
			return
		}
		
		// Далее создаем модель по полученным данным с полей ввода
		self.simulationModel = SimulationModel(groupSize: groupSize, infectionInterval: infectionInterval, InfectionFactor: infectionFactor, columns: 10) { infectedPeople, healthyPeople in
			//Получаем от модели актуальное состояние счетчиков c помощью callback'ов
			self.infectedPeople = infectedPeople
			self.healthyPeople = healthyPeople
		}
		
		// Создаем группы и возвращаем callback'ом когда она будет готова
		self.simulationModel?.createGroup { group in
			self.group = group
			self.healthyPeople = group.count
			self.state = .idle
		}
		
		// Запускаем модель, когда она создана и получила все нужные данные
		self.simulationModel?.startSimulation()
	}
	
	// MARK: Метод остановки симуляции
	func stopSimulation() {
		simulationModel?.stopSimulation()
	}
	
	// MARK: Метод заражения человека
	// С помощью этого метода мы заражаем конкретного человека на которого мы нажали в нашем View
	// Он нужен для того, чтобы передать моделе информации о том кого именно нужно заразить в нашей группе
	// Далее модель сама выполнит операцию по заражению, пересчитает количество больных и здоровых людей и вернет нам эти
	// значения для наших счетчиков
	func infect(personIndex: Int) {
		self.simulationModel?.addToInfectors(infectorIndex: personIndex) { infectedPeople, healthyPeople in
			self.infectedPeople = infectedPeople
			self.healthyPeople = healthyPeople
		}
	}
}
