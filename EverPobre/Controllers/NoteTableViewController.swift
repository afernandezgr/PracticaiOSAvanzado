//
//  NoteViewController.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 4/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit
import CoreData


protocol NoteTableViewControllerDelegate: class {
    // should, will, did
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note : Note)
}

class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var notes = [Note]() // array vacio
    var fetchedResultController : NSFetchedResultsController<Note>!
    var currentDefaultNotebook: Notebook?
    weak var delegate: NoteTableViewControllerDelegate?

    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        fetchNotes()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(NotebookCell.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        setupUI()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    
    private func setupUI(){
        tableView.backgroundColor = .tealColor
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        navigationItem.title = "Notebooks"
    
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "tools"),  style: UIBarButtonItemStyle.plain, target: self, action: #selector(optionsNote))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleNewNote))
    }
    
    
    @objc private func optionsNote(){
        let modalNoteViewController = ModalNoteViewController()
        modalNoteViewController.currentDefaultNotebook = currentDefaultNotebook
        
        let navController = UINavigationController(rootViewController: modalNoteViewController)
        //navigationController?.pushViewController(navController, animated: true, completion: nil)
        splitViewController?.viewControllers.first?.present(navController, animated: true)
    }
    
    
    @objc private func handleNewNote() {
   
        if let currentDefaultNotebook = currentDefaultNotebook {
            
            let noteViewController = NoteDetailViewController()
            noteViewController.currentDefaultNotebook = currentDefaultNotebook
            //navigationController?.pushViewController(noteViewController, animated: true)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                splitViewController?.showDetailViewController(noteViewController.wrappedInNavigation(), sender: nil)
            }
            else
            {
                navigationController?.pushViewController(noteViewController, animated: true)
            }
        } else {
            showError(title: "Not default notebook selected", message: "You need a default notebook to be selected")
        }
        
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - TableView funcs

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteViewController = NoteDetailViewController()
        noteViewController.note = fetchedResultController.object(at: indexPath)
        noteViewController.currentDefaultNotebook = currentDefaultNotebook
        
//        if splitViewController!.isCollapsed {
//            navigationController?.pushViewController(noteViewController, animated: true)
//        }
//
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            splitViewController?.showDetailViewController(noteViewController.wrappedInNavigation(), sender: nil)
        }
        else
        {
            navigationController?.pushViewController(noteViewController, animated: true)
        }
        
        delegate?.noteTableViewController(self, didSelectNote: noteViewController.note!)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NoteCell
        let note = fetchedResultController.object(at: indexPath)
        cell.note = note
        
        if (note.notebook?.defaultNotebook)!{
            currentDefaultNotebook=note.notebook
        }
        
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
        return fetchedResultController.sections!.count //(fetchedResultController.fetchedObjects?.count)! //fetchedResultController.sections!.count
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
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let note = self.fetchedResultController.object(at: indexPath) 
           // self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
           
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            context.delete(note)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete note:", saveErr)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
       
        return [deleteAction]
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
        fetchNotes()
        tableView.reloadData()
    }
    
   
   

}

