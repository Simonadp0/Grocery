# Priority Sorter

## Introduction

This report provides a detailed overview of the code developed to manage a list of expenses, allowing users to generate, view, and sort expenses based on priority. The code is written in Swift using the SwiftUI framework for creating user interfaces.

## Code Structure

### 1. Struct Definitions
#### ExpenseItem
ExpenseItem is a struct that represents a single expense.
Each ExpenseItem has a unique identifier generated using UUID, a name, and a priority.

### 2. ContentView
#### State Variables
@State is used to manage state within ContentView.
State variables include:

- expenses: an array of ExpenseItem containing the expenses.
- Variables to store the execution times of various sorting algorithms.
- showNanoseconds: a boolean variable to choose whether to display times in nanoseconds or seconds.

#### Body
ContentView is a SwiftUI structure representing the main user interface of the application.
It includes buttons to generate random expenses, view the list of expenses, and sort expenses.
A switch to change the unit of measurement for execution times.
Displays the execution times of various sorting algorithms.

#### Functions
- generateRandomExpenses(): generates a specified number of random expenses with random names and priorities.
- sortExpenses(): sorts expenses using different sorting algorithms and records execution times.

### 3. Sorting Algorithms

Sorting algorithms are essential in the context of expense management as they allow organizing expenses to display the most important or relevant ones first. In the provided code, four different sorting algorithms are implemented: Bubble Sort, Quick Sort, Selection Sort, and Merge Sort.

### Bubble Sort

Bubble Sort is one of the simplest sorting algorithms. It works by repeatedly comparing adjacent elements and swapping them if they are in the wrong order. This process is repeated until the entire array is sorted. While simple to implement, Bubble Sort has a time complexity of O(n^2), making it ineffective on large arrays. It is considered one of the slowest sorting algorithms but is useful for educational purposes or sorting small data sets.

```swift
// Bubble Sort implementation
private func bubbleSort(_ array: inout [ExpenseItem]) {
    for i in 0..<array.count {
        for j in 0..<(array.count - i - 1) {
            if array[j].priority > array[j+1].priority {
                array.swapAt(j, j+1)
            }
        }
    }

