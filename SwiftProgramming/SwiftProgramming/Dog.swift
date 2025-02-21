// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

class Animal {
    var isPet: Bool = false
}

class Dog: Animal
{
    var barkText = "Woof, woof!"
    var name: String = ""
    
    func bark() {
        print(barkText)
    }
    
    func description() -> String
    {
        return "name: \(name), is pet: "
            + (isPet ? "yes" : "no")
            + ", bark: \(barkText)"
    }
}


extension Dog
{
    var numberOfLegs: Int { return 4 }
}

struct Cat: Codable {
    var name: String
    var age: Int
    
    var json: Data {
        let cat = Cat(name: "Tiger", age: 2)
        let data = try! JSONEncoder().encode(cat)
        let cat2 = try! JSONDecoder().decode(Cat.self, from: data)
        
        return data
    }
}
