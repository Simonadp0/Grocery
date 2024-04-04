import SwiftUI

struct ElementItem: Identifiable {
    let id = UUID()
    let name: String
    let priority: Int
    let category: Category
}

enum SortingAlgorithm: String, CaseIterable {
    case bubbleSort = "Bubble Sort"
    case quickSort = "Quick Sort"
    case selectionSort = "Selection Sort"
    case mergeSort = "Merge Sort"
}

enum Category: String, CaseIterable {
    case food = "Food"
    case activity = "Activity"
    case place = "Place"
}

struct ContentView: View {
    @State private var elements = [ElementItem]()
    @State private var bubbleSortTime: Double = 0
    @State private var quickSortTime: Double = 0
    @State private var selectionSortTime: Double = 0
    @State private var mergeSortTime: Double = 0
    @State private var selectedAlgorithm = SortingAlgorithm.bubbleSort
    @State private var selectedCategory = Category.food
    @State private var showNanoseconds = true

    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(elements.filter { $0.category == selectedCategory }) { element in
                        Text("\(element.name) - Priority: \(element.priority)")
                    }
                }
                .listStyle(PlainListStyle())
                .padding()

                Button("Generate Elements", action: {
                    generateRandomElements()
                })
                .padding()

                Spacer()

                Picker("Sorting Algorithm", selection: $selectedAlgorithm) {
                    ForEach(SortingAlgorithm.allCases, id: \.self) { algorithm in
                        Text(algorithm.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedAlgorithm) { _ in
                    sortElements()
                }

                Button("Sort by Priority", action: sortElements)
                    .padding()

                Toggle("Show in Nanoseconds", isOn: $showNanoseconds)
                    .padding()
                    .toggleStyle(SwitchToggleStyle())

                switch selectedAlgorithm {
                case .bubbleSort:
                    Text("Bubble Sort Time: \(showNanoseconds ? "\(bubbleSortTime)" : "\(bubbleSortTime / 1_000_000_000)") \(showNanoseconds ? "nanoseconds" : "seconds")")
                case .quickSort:
                    Text("Quick Sort Time: \(showNanoseconds ? "\(quickSortTime)" : "\(quickSortTime / 1_000_000_000)") \(showNanoseconds ? "nanoseconds" : "seconds")")
                case .selectionSort:
                    Text("Selection Sort Time: \(showNanoseconds ? "\(selectionSortTime)" : "\(selectionSortTime / 1_000_000_000)") \(showNanoseconds ? "nanoseconds" : "seconds")")
                case .mergeSort:
                    Text("Merge Sort Time: \(showNanoseconds ? "\(mergeSortTime)" : "\(mergeSortTime / 1_000_000_000)") \(showNanoseconds ? "nanoseconds" : "seconds")")
                }
            }
            .padding()
            .navigationTitle("Elements")
        }
    }

    func generateRandomElements() {
        let numberOfElements = 100
        
        elements = (1...numberOfElements).map { _ in
            let randomCategory = Category.allCases.randomElement() ?? .food
            var randomName: String = ""
            var randomPriority: Int = 0
            
            switch randomCategory {
            case .food:
                randomName = generateRandomFood()
                randomPriority = Int.random(in: 1...20)
            case .activity:
                randomName = generateRandomActivity()
                randomPriority = Int.random(in: 1...20)
            case .place:
                randomName = generateRandomPlace()
                randomPriority = Int.random(in: 1...10)
            }
            
            return ElementItem(name: randomName, priority: randomPriority, category: randomCategory)
        }
    }

    func sortElements() {
        switch selectedAlgorithm {
        case .bubbleSort:
            let startTime = DispatchTime.now()
            var elementsCopy = elements
            bubbleSort(&elementsCopy)
            let endTime = DispatchTime.now()
            bubbleSortTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000
            elements = elementsCopy

        case .quickSort:
            let startTime = DispatchTime.now()
            var elementsCopy = elements
            quickSort(&elementsCopy, low: 0, high: elementsCopy.count - 1)
            let endTime = DispatchTime.now()
            quickSortTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000
            elements = elementsCopy

        case .selectionSort:
            let startTime = DispatchTime.now()
            var elementsCopy = elements
            selectionSort(&elementsCopy)
            let endTime = DispatchTime.now()
            selectionSortTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000
            elements = elementsCopy

        case .mergeSort:
            let startTime = DispatchTime.now()
            var elementsCopy = elements
            mergeSort(&elementsCopy)
            let endTime = DispatchTime.now()
            mergeSortTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000
            elements = elementsCopy
        }
    }

    private func bubbleSort(_ array: inout [ElementItem]) {
        for i in 0..<array.count {
            for j in 0..<(array.count - i - 1) {
                if array[j].priority > array[j+1].priority {
                    array.swapAt(j, j+1)
                }
            }
        }
    }

    private func partition(_ array: inout [ElementItem], low: Int, high: Int) -> Int {
        let pivot = array[high].priority
        var i = low - 1
        for j in low..<high {
            if array[j].priority < pivot {
                i += 1
                array.swapAt(i, j)
            }
        }
        array.swapAt(i + 1, high)
        return i + 1
    }

    private func quickSort(_ array: inout [ElementItem], low: Int, high: Int) {
        if low < high {
            let pi = partition(&array, low: low, high: high)
            quickSort(&array, low: low, high: pi - 1)
            quickSort(&array, low: pi + 1, high: high)
        }
    }

    private func selectionSort(_ array: inout [ElementItem]) {
        for i in 0..<array.count {
            var minIndex = i
            for j in i+1..<array.count {
                if array[j].priority < array[minIndex].priority {
                    minIndex = j
                }
            }
            array.swapAt(i, minIndex)
        }
    }

    private func mergeSort(_ array: inout [ElementItem]) {
        guard array.count > 1 else { return }
        
        let middleIndex = array.count / 2
        var leftArray = Array(array[..<middleIndex])
        var rightArray = Array(array[middleIndex...])
        
        mergeSort(&leftArray)
        mergeSort(&rightArray)
        
        var leftIndex = 0
        var rightIndex = 0
        var index = 0
        
        while leftIndex < leftArray.count && rightIndex < rightArray.count {
            if leftArray[leftIndex].priority < rightArray[rightIndex].priority {
                array[index] = leftArray[leftIndex]
                leftIndex += 1
            } else {
                array[index] = rightArray[rightIndex]
                rightIndex += 1
            }
            index += 1
        }
        
        while leftIndex < leftArray.count {
            array[index] = leftArray[leftIndex]
            leftIndex += 1
            index += 1
        }
        
        while rightIndex < rightArray.count {
            array[index] = rightArray[rightIndex]
            rightIndex += 1
            index += 1
        }
    }
    
    func generateRandomFood() -> String {
        let foods = ["Pizza", "Pasta", "Burger", "Salad", "Steak", "Sushi", "Ice Cream", "Biscuits", "Strawberry", "Bread", "Milk", "Eggs", "Avocado", "Sausages", "Seafood", "Potato", "Nuts"]
        return foods.randomElement() ?? "Unknown Food"
    }

    func generateRandomActivity() -> String {
        let activities = ["Running", "Swimming", "Cycling", "Reading", "Writing", "Painting", "Cooking", "Yoga", "Meditation", "Gardening", "Dancing", "Singing", "Climbing", "Cooking", "Travelling", "Studying"]
        return activities.randomElement() ?? "Unknown Activity"
    }

    func generateRandomPlace() -> String {
        let places = ["Paris", "New York City", "Tokyo", "Rome", "Sydney", "London", "Barcelona", "Rio de Janeiro", "Cairo", "Dubai"]
        return places.randomElement() ?? "Unknown Place"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
