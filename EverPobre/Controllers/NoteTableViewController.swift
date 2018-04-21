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
        
        forceDisplayFirstNoteiPad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    
   
    // MARK: - TableView funcs

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteViewController = NoteDetailViewController()
        noteViewController.note = fetchedResultController.object(at: indexPath)
        noteViewController.currentDefaultNotebook = currentDefaultNotebook
    
        
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
            
            let backMOC = CoreDataManager.sharedManager.persistentContainer.newBackgroundContext()
           
            backMOC.perform {
                let backNote = backMOC.object(with: note.objectID) as! Note
                
                backMOC.delete(backNote)
                do {
                    try backMOC.save()
                } catch let saveErr
                {
                    print("Fail deleting note:", saveErr)
                }
            }
        
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
        return [deleteAction]
    }
    
    
    private func forceDisplayFirstNoteiPad(){
        if ( fetchedResultController.sections!.count>0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            let indexPath = IndexPath(row: 0, section: 0);
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            self.tableView(self.tableView, didSelectRowAt: indexPath)
        }
    }

}

