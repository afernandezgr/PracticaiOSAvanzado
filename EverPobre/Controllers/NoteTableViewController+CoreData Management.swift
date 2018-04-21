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
            try fetchedResultController.performFetch()  
            fetchedResultController.delegate = self
        } catch let fetchErr {
            print("Fail restoring notes:", fetchErr)
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func getNotebooks() -> [Notebook] {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Notebook", in: context)
        
        let sortByDefaultFirst = NSSortDescriptor(key: "defaultNotebook", ascending: false)
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortByDefaultFirst, sortByTitle]        
        fetchRequest.fetchBatchSize = 50
        
        var notebooks: [Notebook] = []
        
        do {
            try notebooks = context.fetch(fetchRequest)
        } catch let fetchErr {
            print("Fail restoring notebooks:", fetchErr)
        }
        
        return notebooks
    }
    
}
