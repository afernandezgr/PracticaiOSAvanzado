//
//  ModalNoteViewController+CoreData operations.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import CoreData

extension ModalNoteViewController {
    
   
    // MARK: - Fecth Data CD
    
    
    func fetchNotesbooksDefault() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByTitle]
        fetchRequest.fetchBatchSize = 25
        fetchedResultControllerDefault =
            NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: title, cacheName: nil)
        
        
        let predicate = NSPredicate(format: "defaultNotebook = false")  //avoid current default notebook
        fetchRequest.predicate = predicate
        
        fetchedResultControllerDefault.delegate = self
        
        do {
            try fetchedResultControllerDefault.performFetch()
            print(fetchedResultControllerDefault)
        } catch let fetchErr {
            print("Failing recovering notebooks:", fetchErr)
            
        }
        self.notebookDefaultPicker.reloadAllComponents()
    }
    
    func fetchNotesbooksDelete() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByTitle]
        fetchRequest.fetchBatchSize = 25
        fetchedResultControllerDelete =
            NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: title, cacheName: nil)
        
        
        fetchedResultControllerDelete.delegate = self
        
        do {
            try fetchedResultControllerDelete.performFetch()
            
        } catch let fetchErr {
            print("Failing recovering notebooks:", fetchErr)
            
        }
        self.notebookToDeletePicker.reloadAllComponents()
    }
    
    func fetchNotesbooksTransfer() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
        
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByTitle]
        fetchRequest.fetchBatchSize = 25
        fetchedResultControllerTransfer =
            NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: title, cacheName: nil)
        
        
        fetchedResultControllerTransfer.delegate = self
        
        do {
            try fetchedResultControllerTransfer.performFetch()
            
        } catch let fetchErr {
            print("Failing recovering notebooks:", fetchErr)
            
        }
        self.notebookToTransferPicker.reloadAllComponents()
    }
    
    
    @objc func handleSave() {
        
        //let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if tabBarCnt.selectedIndex ==  0 {  //new notebook creation
            //verify notebook name empty
            if (nameNotebookTextField.text?.isEmpty)! {
                showError(title: "Empty notebook name", message: "You have not entered notebook name.")
                return
            }
            let noteName = self.nameNotebookTextField.text
            
            //verify notebook already used
            if ((fetchedResultControllerDefault.fetchedObjects as! [Notebook]).filter { $0.title == noteName }).count > 0 {
                showError(title: "Wrong name", message: "Notebook name already used. Please choose another name")
                return
            }

            let backMOC = CoreDataManager.sharedManager.persistentContainer.newBackgroundContext()
            backMOC.performAndWait {
                let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: backMOC)  as! Notebook
                notebook.setValue(noteName, forKey: "title")
                notebook.setValue(false, forKey: "defaultNotebook")
                
                let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: backMOC) as! Note
                note.title = "My note"
                note.notebook = notebook
                
                do {
                    try backMOC.save()
                } catch let saveErr {
                    print("Fail saving notebook:", saveErr)
                }
            }
            dismiss(animated: true, completion: nil)
            
        }
        else if tabBarCnt.selectedIndex == 1 { //delete
            var indexPath = IndexPath(row:  notebookToDeletePicker.selectedRow(inComponent: 0),  section: 0)
            let deleteNotebook  = self.fetchedResultControllerDelete.object(at: indexPath as IndexPath) as Notebook
            
            if (notebookSwitchTransfer.isOn){
                indexPath = IndexPath(row:  notebookToTransferPicker.selectedRow(inComponent: 0),  section: 0)
            }
            let transferNotebook  = self.fetchedResultControllerTransfer.object(at: indexPath as IndexPath) as Notebook
            if (notebookSwitchTransfer.isOn && deleteNotebook == transferNotebook) {
                showError(title: "Warning!", message: "Notebook to delete and notebook to transfer notes is the same")
                return
            }
            
            let backMOC = CoreDataManager.sharedManager.persistentContainer.newBackgroundContext()
            backMOC.performAndWait{
                
                let backNotebookToDelete = backMOC.object(with: deleteNotebook.objectID) as! Notebook
                let backTransferNotebook = backMOC.object(with: transferNotebook.objectID) as! Notebook
                backMOC.delete(backNotebookToDelete)
                for note in backNotebookToDelete.notes! {
                    (note as! Note).notebook = backTransferNotebook
                }
                
                do {
                    try backMOC.save()
                } catch let saveErr {
                    print("Fail deleting notebook:", saveErr)
                }
            }
            dismiss(animated: true, completion: nil)
        }
        else if tabBarCnt.selectedIndex == 2 { //setdefault
//            if let currentNotebook = currentDefaultNotebook {
//                currentNotebook.defaultNotebook = false
//            }
//
            let indexPath = IndexPath(row: notebookDefaultPicker.selectedRow(inComponent: 0),  section: 0)
            let newDefaultNotebook  = self.fetchedResultControllerDefault.object(at: indexPath as IndexPath) as Notebook
            
            let backMOC = CoreDataManager.sharedManager.persistentContainer.newBackgroundContext()
            backMOC.performAndWait {
              
                if let currentNotebook = currentDefaultNotebook {
                    currentNotebook.defaultNotebook = false
                    let backCurrentDefaulNotebook = backMOC.object(with: currentNotebook.objectID) as! Notebook
                    backCurrentDefaulNotebook.defaultNotebook = false
                }
                let backNewDefaulNotebook = backMOC.object(with: newDefaultNotebook.objectID) as! Notebook
                backNewDefaulNotebook.defaultNotebook = true
                do {
                    try backMOC.save()
                } catch let saveErr {
                    print("Fail setting new default notebook:", saveErr)
                }
                
            }
            dismiss(animated: true, completion: nil)
            
        }
    }

}
