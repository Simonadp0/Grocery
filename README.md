# SortSync 

## Introduction

Welcome to the SortSync project, an application designed to efficiently manage elements with varying priorities. Developed using SwiftUI, this project allows users to generate, view, and sort elements based on their priorities using different sorting algorithms. Let's explore the structure, features, and insights gained from this project.

## Code Structure

## Struct Definitions

- **ElementItem**: Represents a single element with a unique identifier, name, priority, and category.

## ContentView

## State Variables

The `ContentView` manages the state of the application, including:
- `elements`: List of elements
- `bubbleSortTime`, `quickSortTime`, `selectionSortTime`, `mergeSortTime`: Execution times of sorting algorithms
- `selectedAlgorithm`: The selected sorting algorithm
- `selectedCategory`: The selected category for generating elements
- `showNanoseconds`: Display preference for execution times

### Body

The `ContentView` defines the main user interface of the application, featuring:
- A segmented picker to select the category for element generation
- Buttons to generate random elements, display the list of elements, and sort them
- A picker to select the sorting algorithm
- A toggle to switch between nanoseconds and seconds for execution times
- Text views to display the execution times for each algorithm

### Functions

The `ContentView` includes functions to generate random elements based on the selected category and sort them using different sorting algorithms.

## Sorting Algorithms

Four sorting algorithms are implemented to facilitate sorting of elements based on priority:

### Bubble Sort

A simple sorting algorithm that repeatedly compares adjacent elements and swaps them if they are in the wrong order.

```swift
private func bubbleSort(_ array: inout [ElementItem]) {
    for i in 0..<array.count {
        for j in 0..<(array.count - i - 1) {
            if array[j].priority > array[j+1].priority {
                array.swapAt(j, j+1)
            }
        }
    }
}
```

### Quick Sort

An efficient "divide and conquer" algorithm that recursively divides the array, sorts the subarrays, and combines them.

```swift
private func quickSort(_ array: inout [ElementItem], low: Int, high: Int) {
    if low < high {
        let pi = partition(&array, low: low, high: high)
        quickSort(&array, low: low, high: pi - 1)
        quickSort(&array, low: pi + 1, high: high)
    }
}
```

### Selection Sort

A straightforward algorithm that repeatedly selects the minimum element from the unsorted portion and moves it to the sorted portion.

```swift
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
```

### Merge Sort

A stable and efficient sorting algorithm that divides the array into smaller subarrays, sorts them, and merges them back together.

```swift
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
```
## Key Features

- **User Interaction**: Users can effortlessly generate random elements, view them in a list, and sort them based on priority.
- **Sorting Algorithms**: The project demonstrates the implementation and application of various sorting algorithms to efficiently organize elements.
- **Dynamic UI**: The user interface dynamically updates to reflect changes in element lists and sorting algorithm execution times.

## Insights and Learnings

Through this project, several key insights and learnings were gained:

- **SwiftUI Development**: Enhanced proficiency in SwiftUI for building dynamic and interactive user interfaces.
- **Algorithm Implementation**: Deepened understanding of sorting algorithms and their practical applications in real-world scenarios.
- **Performance Optimization**: Explored techniques for optimizing performance and efficiency when working with large datasets.

## Future Enhancements

Looking ahead, potential enhancements to the SortSync include:

- **User Authentication**: Implementing user authentication for secure access to expense management features.
- **Data Persistence**: Adding data persistence to retain expense information across sessions.
- **UI Refinement**: Further refining the user interface for improved usability and aesthetics.

## Conclusion

The SortSync represents a significant milestone in the journey of developing efficient and user-centric applications. Through its implementation, valuable insights were gained into SwiftUI development, algorithm implementation, and performance optimization techniques. 
