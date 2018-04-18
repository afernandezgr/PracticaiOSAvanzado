//
//  NoteTableViewController+CoreData Management.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//
import CoreData


extension NoteTableViewController{

    func fetchNotes() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        
        let sortByDefaultFirst = NSSortDescriptor(key: "notebook.defaultNotebook", ascending: false)
        
        let sortByTitle = NSSortDescriptor(key: "notebook.title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByDefaultFirst, sortByTitle]
        
        fetchedResultController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: context,
                                       sectionNameKeyPath: "notebook.title",
                                       cacheName: nil)
        
        fetchRequest.fetchBatchSize = 25
        do {
            try fetchedResultController.performFetch()  //context.fetch(fetchRequest)
            fetchedResultController.delegate = self
        } catch let fetchErr {
            print("Fallo recuperado notes:", fetchErr)
            //return []
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // fetchNotes()
        tableView.reloadData()
    }
    
    
}
