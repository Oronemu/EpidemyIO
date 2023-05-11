//
//  SimulationModel.swift
//  EpidemyIO
//
//  Created by Иван Ровков on 09.05.2023.
//

import Foundation

// MARK: - Параметры необходимые для симуляции заражения
class SimulationModel: ObservableObject {
	
	// MARK: - Параметры необходимые для симуляции заражения
	
	private var infectorIndicies: [Int] = [] // Массив индексов заразителей, т.е. только тех кто может заразить
	private var group: [Person] = [] // Массив со всей группой
	private var timer: DispatchSourceTimer? // Таймер для работы в фоне

	private var infectionInterval: Int // Интервал с которым будет происходить заражение
	private var InfectionFactor: Int // Количество людей, которых может заразить зараженный
	private var columns: Int // Количество колонок из View. Нужно для расчета соседей
	private var groupSize: Int // Размер группы людей
	
	// MARK: - Счетчики здоровых/больных людей
	
	private var healthyPeople: Int = 0 // Счетчик здоровых людей
	private var infectedPeople: Int = 0 // Счетчик больных людей
	private var callback: (Int, Int) -> Void // Callback для передачи значений счетчиков модели ViewModel'е
	
	init(groupSize: Int, infectionInterval: Int, InfectionFactor: Int, columns: Int, callback: @escaping (Int, Int) -> Void) {
		self.groupSize = groupSize
		self.infectionInterval = infectionInterval
		self.InfectionFactor = InfectionFactor
		self.columns = columns
		self.callback = callback
	}
	
	// MARK: - Метод создания группы
	//
	// Выполняем создание группы в отдельном потоке, чтобы приложение
	// не зависало при генерации слишком большой группы.
	func createGroup(_ completion: @escaping ([Person]) -> Void ){
		DispatchQueue.global(qos: .background).async {
			let group = (0...self.groupSize-1).map { _ in Person() }
			self.healthyPeople = group.count
			DispatchQueue.main.async {
				self.group = group
				completion(group) //Как только группа будет готова, то отслыаем ее в главный поток для отображения
			}
		}
	}
	
	// MARK: - Метод запуска симуляции
	//
	// Данный метод запускает нашу симуляцию в background потоке и бесконечно выполняет алгоритм распространения инфекции
	func startSimulation() {
		if timer == nil { // Чтобы по случайности не запустить несколько симуляций проверяем не запускали ли мы ее ранее
			timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background)) // Назначаем timer в background очередь
			timer?.schedule(deadline: .now(), repeating: Double(infectionInterval))
			timer?.setEventHandler(handler: simulationLoop) // Для удобства выносим нашу симуляцию в отдельную функцию
			timer?.resume()
		}
	}
	
	// MARK: - Метод остановки симуляции
	func stopSimulation() {
		timer?.cancel()
		timer = nil // Отменяем запланированную задачу и зануляем таймер
		self.group.removeAll()
		self.infectorIndicies.removeAll() // Очищаем групу со всеми людьми и массив индексов заразителей
	}
	
	// MARK: - Метод заражения человека
	//
	// Получаем индекс выбранного из массива человека и добавляем его в массив заражателей
	func addToInfectors(infectorIndex: Int, _ completion: @escaping (Int, Int) -> Void) {
		self.group[infectorIndex].infect()
		self.infectorIndicies.append(infectorIndex)
		self.incrementInfectedPeopleCount() // Увеличиваем счетчик зараженных и здоровых
		completion(self.infectedPeople, self.healthyPeople) // Возвращаем эти счетчики для ViewModel'и
	}
	
	// MARK: - Метод инкрементирования счетчиков
	private func incrementInfectedPeopleCount() {
		self.infectedPeople += 1
		self.healthyPeople -= 1
	}
	
	// MARK: - Симуляция распространения заражения
	private func simulationLoop() {
		let currentInfectorIndicies = self.infectorIndicies // Копируем текущую волну заражателей в локальный массив
		self.infectorIndicies = [] // Зануляем заражателей, чтобы подготовить массив к следующий волне заражателей
		
		for infectorIndex in currentInfectorIndicies { //Итерируемся по каждому заражателю
			let neighbours = getHealthyNeighbours(of: infectorIndex).shuffled() //Для каждого из них определяем здоровых соседей
			guard !neighbours.isEmpty else { continue } //Если у текущего заражетял нет соседей, идем к следующему
			
			var range: Int {
				if neighbours.count > InfectionFactor {
					return InfectionFactor
				} else {
					return neighbours.count
				}
			}
			
			let neighbourInfectors = neighbours[0..<range] // Берем только нужное количество соседей меньшее чем InfectionFactor
						
			for neighbour in neighbourInfectors { // Итерирусемся по каждому соседу
				neighbour.person.infect() // Заражаем его
				self.incrementInfectedPeopleCount()
				self.infectorIndicies.append(neighbour.index) // Инкрементируем счетчик и добавляем этого сосдеа в следующую волну заражателей
			}
		}
		DispatchQueue.main.async { // Как только просчитаем всех зараженных за волну, обновляем счетчик во ViewModel
			self.callback(self.infectedPeople, self.healthyPeople)
		}
	}
	
	// MARK: - Получение соседей элемента массива
	private func getHealthyNeighbours(of index: Int) -> [(person: Person, index: Int)]{
		let n = 1 // Задаем радиус в котором нужно искать соседей, больший радиус включает и меньшие радиусы
							// Иными словами, если будет n = 2, то мы будем искать среди не 8 соседей, а 24
		var res: [(Person, Int)] = []
		
		// Определяем соедей по всем сторонам
		let top = max(0, index / columns - n)
		let bottom = min((group.count - 1) / columns, index / columns + n)
		let left = max(0, index % columns - n)
		let right = min(columns - 1, index % columns + n)
		
		for row in top...bottom {
			for column in left...right { // Перебираем всех соседей вокруг нашего элемента
				let currentIdx = row * columns + column
				if index != currentIdx && currentIdx < group.count { //Если сосед существует, то
					let currentPerson = group[currentIdx] //получаем индекс соседа из группы людей
					if !currentPerson.isInfected { // Если этот сосед не заражен, то добавляем его в массив
						res.append((currentPerson, currentIdx))
					}
				}
			}
		}
		
		return res // Возвращаем здоровых соседей
	}
}
