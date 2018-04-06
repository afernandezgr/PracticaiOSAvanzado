//
//  CoreDataManager.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 3/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EverPobre")
        container.loadPersistentStores{ (description, err) in
            if let err = err {
                fatalError("Carga de PersistantStore ha fallado: \(err)")
            }
        }
        return container
    }()

    func fetchNotebooks() -> [Notebook] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        do {
            let notebooks = try context.fetch(fetchRequest)
            return notebooks
        } catch let fetchErr {
            print("Fallo recuperado notebooks:", fetchErr)
            return []
        }
    }

//    func fetchNotes() -> [Note] {
//        let context = persistentContainer.viewContext
//        
//        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
//
//        
//        let sortByDefaultFirst = NSSortDescriptor(key: "note.defaultNotebook", ascending: true)
//        
//        let sortByTitle = NSSortDescriptor(key: "note.title", ascending: true)
//       
//        fetchRequest.sortDescriptors = [sortByDefaultFirst,sortByTitle]
//        
//        fetchedResultsController =
//            NSFetchedResultsController(fetchRequest: fetchRequest,
//                                       managedObjectContext: context,
//                                       sectionNameKeyPath: "letter.letterName",
//                                       cacheName: "dict")
//        
//        do {
//            let notes = try context.fetch(fetchRequest)
//            return notes
//        } catch let fetchErr {
//            print("Fallo recuperado notes:", fetchErr)
//            return []
//        }
//    }

    
}
