//
//  ToDo.swift
//  ToDoList
//
//  Created by Georgy Dyagilev on 23/10/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import Foundation

struct ToDo: Codable {
    var title: String
    var isComplite: Bool
    var dueDate: Date
    var notes: String?
    
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var fileURL = documentsDirectory.appendingPathComponent("ToDoList").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]? {
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: fileURL),
            let decodedToDos = try? propertyListDecoder.decode([ToDo].self, from: data) {
            return decodedToDos
        } else {
            return nil
        }
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedTodos = try? propertyListEncoder.encode(todos)
        
        try? encodedTodos?.write(to: fileURL, options: .noFileProtection)
    }
   
    static func loadSampleToDo() -> [ToDo] {
        return [
            ToDo(title: "Buy batle of milk.",
                 isComplite: false,
                 dueDate: Date(),
                 notes: "Milk with not more then 4% of fat.")
        ]
    }
}
