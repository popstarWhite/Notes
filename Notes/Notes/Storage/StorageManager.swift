//
//  StorageManager.swift
//  Notes
//
//  Created by Максим Шмидт on 15.03.2022.
//

import Foundation

protocol StorageManagerProtocol: AnyObject {
    func getNotes() -> [Note]
//    func saveNotes(_ notes: [Note])
    func saveNote(_ note: Note, index: Int)
    func saveNewNote(_ note: Note)
    
    func removeNote(_ note: Note, index: Int)
}

final class StorageManager: StorageManagerProtocol {
    
    private let defaults = UserDefaults.standard
    
    func getNotes() -> [Note] {
        do {
            guard let data = defaults.object(forKey: "Notes") as? Data else { return [] }
            return try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("fail saving")
            return []
        }
    }
    
    private func saveNotes(_ notes: [Note]) {
        do {
            let encodedData = try JSONEncoder().encode(notes)
            defaults.set(encodedData, forKey: "Notes")
        } catch {
            print("fail saving")
        }
    }
    
    func saveNote(_ note: Note, index: Int) {
        var notes = getNotes()
        notes[index] = note
        saveNotes(notes)
    }
    
    func saveNewNote(_ note: Note) {
        var notes = getNotes()
        notes.append(note)
        saveNotes(notes)
    }
    
    func removeNote(_ note: Note, index: Int) {
        var notes = getNotes()
        notes.remove(at: index)
        saveNotes(notes)
    }
}
