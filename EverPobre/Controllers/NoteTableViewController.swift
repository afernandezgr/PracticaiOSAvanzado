//
//  NoteViewController.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 4/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit
import CoreData
class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var notes = [Note]() // array vacio
    
    var fetchedResultController : NSFetchedResultsController<Note>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.notes = fetchNotes()
        fetchNotes()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(NotebookCell.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        setupUI()
    }
    
    
    private func setupUI(){
        tableView.backgroundColor = .tealColor
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        navigationItem.title = "Notebooks"
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
    }
    
    @objc private func addNewNote(){
        print("Adding new note...")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context)  as! Notebook
        notebook.setValue("Notebook example7", forKey: "title")
        notebook.setValue(true, forKey: "defaultNotebook")
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.title = "Note 7"
        note.notebook = notebook
    
        
        //        if let companyImage = companyImageView.image {
        //            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
        //            company.setValue(imageData, forKey: "imageData")
        //        }
        
        // perform the save
        
        do {
            try context.save()
            
            // success
            //            dismiss(animated: true, completion: {
            //                self.delegate?.didAddCompany(company: company as! Company)
            //            })
            
        } catch let saveErr {
            print("Fallo salvando note:", saveErr)
        }
    }
    
    
    @objc private func handleReset() {
        print("Intentando eliminar todos los core data objects")
   
 
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Notebook.fetchRequest())
//
//        do {
//            try context.execute(batchDeleteRequest)
//
//
//
//            var indexPathsToRemove = [IndexPath]()
//
//            for (index, _) in notes.enumerated() {
//                let indexPath = IndexPath(row: index, section: 0)
//                indexPathsToRemove.append(indexPath)
//            }
//            notes.removeAll()
//            tableView.deleteRows(at: indexPathsToRemove, with: .left)
//
//        } catch let delErr {
//            print("Fallo el borrado de objetos de Core Data:", delErr)
//        }
//
    }
    
    
    // MARK: - TableView funcs

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteViewController = NoteViewController()
        noteViewController.note = fetchedResultController.object(at: indexPath)
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NoteCell
        let note = fetchedResultController.object(at: indexPath)
        cell.note = note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No hay notebooks registradas"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return fetchedResultController.sections!.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultController.sections![section].numberOfObjects
        
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! NotebookCell
        let note = fetchedResultController.sections![section].objects![0] as! Note
        cell.notebook = note.notebook
        return cell

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func fetchNotes() { //}-> [Note] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        
        let sortByDefaultFirst = NSSortDescriptor(key: "notebook.defaultNotebook", ascending: false)
        
        let sortByTitle = NSSortDescriptor(key: "notebook.title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByDefaultFirst, sortByTitle]
        
        fetchedResultController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: context,
                                       sectionNameKeyPath: "notebook.title",
                                       cacheName: "dict")
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()  //context.fetch(fetchRequest)
            //return notes
        } catch let fetchErr {
            print("Fallo recuperado notes:", fetchErr)
            //return []
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

}

