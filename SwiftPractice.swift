//Amrit Banga
//Swift Practice
import Foundation 

//hello world
print("Hello, World!")

//----------------------------------------------------------------------------------------------------------------------------------

// Function to greet a person and the call for it
func greet(name: String) -> String {
    return "Hello, \(name)!"
}
let greeting = greet(name: "Alice")
print(greeting)  // Output: Hello, Alice!

//----------------------------------------------------------------------------------------------------------------------------------

// For loop to iterate over an array
let names = ["Alice", "Bob", "Charlie"]
for name in names {
    print("Hello, \(name)!")
}
        // Output:
        // Hello, Alice!
        // Hello, Bob!
        // Hello, Charlie!

//----------------------------------------------------------------------------------------------------------------------------------

// While loop to count down from 5 to 1
var count = 5
while count > 0 {
    print("Count is \(count)")
    count -= 1
}
// Output:
// Count is 5
// Count is 4
// Count is 3
// Count is 2
// Count is 1

//----------------------------------------------------------------------------------------------------------------------------------

// If statement to check a condition
let age = 20
if age >= 18 {
    print("You are an adult.")
} else {
    print("You are a minor.")
}
// Output: You are an adult.

//----------------------------------------------------------------------------------------------------------------------------------

// Switch statement to match different cases
let day = "Monday"
switch day {
case "Monday":
    print("Start of the work week.")
case "Friday":
    print("End of the work week.")
case "Saturday", "Sunday":
    print("It's the weekend!")
default:
    print("It's a regular day.")
}
// Output: Start of the work week.

//----------------------------------------------------------------------------------------------------------------------------------

// Array declaration and iteration
var fruits = ["Apple", "Banana", "Cherry"]
fruits.append("Date")

for fruit in fruits {
    print(fruit)
}
// Output:
// Apple
// Banana
// Cherry
// Date

//----------------------------------------------------------------------------------------------------------------------------------

// Dictionary declaration and access
var capitals = ["France": "Paris", "Japan": "Tokyo", "USA": "Washington, D.C."]
capitals["Germany"] = "Berlin"

for (country, capital) in capitals {
    print("\(country): \(capital)")
}
// Output:
// France: Paris
// Japan: Tokyo
// USA: Washington, D.C.
// Germany: Berlin

//----------------------------------------------------------------------------------------------------------------------------------

// Struct declaration and usage
struct Person {
    var firstName: String
    var lastName: String

    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}

let person = Person(firstName: "John", lastName: "Doe")
print(person.fullName())  // Output: John Doe

//----------------------------------------------------------------------------------------------------------------------------------

// Class declaration and usage
class Animal {
    var name: String

    init(name: String) {
        self.name = name
    }

    func makeSound() {
        print("\(name) makes a sound.")
    }
}

class Dog: Animal {
    override func makeSound() {
        print("\(name) barks.")
    }
}

let myDog = Dog(name: "Rex")
myDog.makeSound()  // Output: Rex barks.




