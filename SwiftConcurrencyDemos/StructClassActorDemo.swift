//
//  StructClassActorDemo.swift
//  SwiftConcurrencyDemos
//
//  Created by Lu Haoyu on 2023/06/14.
//

/*
 Links:
 https://blog.onewayfirst.com/ios/post...
 https://stackoverflow.com/questions/2...
 https://medium.com/@vinayakkini/swift...
 https://stackoverflow.com/questions/2...
 https://stackoverflow.com/questions/2...
 https://stackoverflow.com/questions/2...
 https://www.backblaze.com/blog/whats-...
 https://medium.com/doyeona/automatic-...
 
 
 VALUE TYPES:
 - struct, enum, string, int...
 - stored in the stack
 - faster
 - thread safe
 - when you assgin or pass value type a new copy of data is created
 
 REFERENCE TYPES:
 - class, function, actor
 - stored in the heap
 - slower, but synchronized
 - not thread safe
 - when you assgin or pass reference type a new refernce to original instance will be created(pointer)
 
 
 STACK:
 - stored value types
 - variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - each thread has its own stack
 
 HEAP:
 - stored reference types
 - shared across threads!
 
 STRUCT:
 - based on values
 - can be mutated
 - stored in the stack
 
 Class:
 - based on references (instances)
 - can not be mutated
 - stored in the heap
 - can inherit from other classes
 
 Actor
 - same as class but thread safe
 
 
 Struct: Data Models, Views
 Classes: ViewModel (we want change it from inside)
 Actors: dataManager
 */


import SwiftUI

struct StructClassActorDemo: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                runTest()
            }
    }
}

struct StructClassActorDemo_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorDemo()
    }
}

//Mutable struct
struct MyStruct {
    var title: String
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct{
        CustomStruct(title: newTitle)
    }
}

//mutable; safer!
struct MutatingStruct {
    private(set) var title: String //set: only can be changed from inside, but can be referrde from outside
    
    init(title: String){
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String){//mutating says the object has been changed
        title = newTitle
    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String){
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String){
        title = newTitle
    }
}

extension StructClassActorDemo{
    
    private func runTest(){
        print("Test started")
        structTest1()
        print("-------------------------")
        classTest1()
        print("-------------------------")
        actorTest1()
    }
    
    private func structTest1(){
        print("structTest1")
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the VALUES of obejectA to objectB")
        var objectB = objectA // this is var; change a var inside a struct also changes the struct object
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title"
        print("ObjectB title changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
        
    }
    
    private func classTest1(){
        print("classTest1")
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERNCE of objectA to objectB")
        let objectB = objectA // this is let
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second title"
        print("ObjectB title changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
        
    }
    
    private func actorTest1(){
        Task{
            print("actorTest1")
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERNCE of objectA to objectB")
            let objectB = objectA // this is let
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second title")
            print("ObjectB title changed")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
    
    
}

