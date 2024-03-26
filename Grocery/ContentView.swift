

import SwiftUI

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let priority: Int
}

struct ContentView: View {
    @State private var expenses = [ExpenseItem]()
    @State private var expenseName = ""
    @State private var expensePriority = ""
    @State private var isPriorityValid = false
    @State private var bubbleSortTime: Double = 0
    @State private var quickSortTime: Double = 0

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Product name", text: $expenseName)
                    TextField("Priority", text: $expensePriority)
                        .keyboardType(.numberPad)
                        .onChange(of: expensePriority) { newValue in
                            isPriorityValid = (1...5).contains(Int(newValue) ?? 0)
                        }
                    Button("Add", action: addExpense)
                        .disabled(!isPriorityValid)
                }
                .padding()

                List {
                    ForEach(expenses) { expense in
                        Text("\(expense.name) - Priority: \(expense.priority)")
                    }
                    .onDelete(perform: deleteItem)
                }
                .listStyle(PlainListStyle())
                .padding()

                Spacer()

                Button("Sort by priority", action: sortExpenses)
                    .padding()

                Text("Bubble Sort Time: \(bubbleSortTime, specifier: "%.4f") microseconds")
                Text("Quick Sort Time: \(quickSortTime, specifier: "%.4f") microseconds")
            }
            .padding()
            .navigationTitle("Product List")
        }
    }

    func addExpense() {
        guard let priority = Int(expensePriority), (1...5).contains(priority) else {
            // Handle invalid priority here
            return
        }
        let newExpense = ExpenseItem(name: expenseName, priority: priority)
        expenses.append(newExpense)
        expenseName = ""
        expensePriority = ""
        isPriorityValid = false
    }

    func deleteItem(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }

    func sortExpenses() {
        let bubbleStartTime = DispatchTime.now()
        var expensesCopy1 = expenses
        bubbleSort(&expensesCopy1)
        let bubbleEndTime = DispatchTime.now()
        bubbleSortTime = Double(bubbleEndTime.uptimeNanoseconds - bubbleStartTime.uptimeNanoseconds) / 1_000

        let quickStartTime = DispatchTime.now()
        var expensesCopy2 = expenses
        quickSort(&expensesCopy2, low: 0, high: expensesCopy2.count - 1)
        let quickEndTime = DispatchTime.now()
        quickSortTime = Double(quickEndTime.uptimeNanoseconds - quickStartTime.uptimeNanoseconds) / 1_000

        expenses = expensesCopy1
    }

    private func bubbleSort(_ array: inout [ExpenseItem]) {
        var sorted = false
        while !sorted {
            sorted = true
            for i in 0..<(array.count - 1) {
                if array[i].priority > array[i+1].priority ||
                   (array[i].priority == array[i+1].priority &&
                    array[i].name > array[i+1].name) {
                    array.swapAt(i, i+1)
                    sorted = false
                }
            }
        }
    }

    private func partition(_ array: inout [ExpenseItem], low: Int, high: Int) -> Int {
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

    private func quickSort(_ array: inout [ExpenseItem], low: Int, high: Int) {
        if low < high {
            let pi = partition(&array, low: low, high: high)
            quickSort(&array, low: low, high: pi - 1)
            quickSort(&array, low: pi + 1, high: high)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
