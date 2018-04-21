//
//  NoteTableViewController+Ui Configuration.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import Foundation
import UIKit


extension NoteTableViewController {
    
     func setupUI(){
        tableView.backgroundColor = .tealColor
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        navigationItem.title = "Notebooks"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "tools"),  style: UIBarButtonItemStyle.plain, target: self, action: #selector(optionsNote))
        
        let addNewNoteButton  = UIBarButtonItem(image: #imageLiteral(resourceName: "fast"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleNewNote))
        
        let selectNotebookButton  = UIBarButtonItem(image: #imageLiteral(resourceName: "plusnote"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(selectNotebook))
        
        navigationItem.leftBarButtonItems = [addNewNoteButton, selectNotebookButton]
    }
    
    @objc private func optionsNote(){
        let modalNoteViewController = ModalNoteViewController()
        modalNoteViewController.currentDefaultNotebook = currentDefaultNotebook
        
        let navController = UINavigationController(rootViewController: modalNoteViewController)
        navController.modalPresentationStyle = .currentContext
        if UIDevice.current.userInterfaceIdiom == .pad {
            splitViewController?.viewControllers.first?.present(navController, animated: true, completion: nil)
        }
        else {
            self.present(navController, animated: true)
        }
    }
    
    @objc private func selectNotebook(sender: UIBarButtonItem) {
        let notebooks = getNotebooks()
        
        let selectNotebook = UIAlertController(title: "Select Notebook", message: "Please select notebook to create note", preferredStyle: .actionSheet)
        
         let noteViewController = NoteDetailViewController()
        
        notebooks.forEach({ (notebook) in
            selectNotebook.addAction(UIAlertAction(title: notebook.title, style: .default, handler: {
                (action: UIAlertAction) -> Void in
                noteViewController.currentNotebook = notebook
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.splitViewController?.showDetailViewController(noteViewController.wrappedInNavigation(), sender: nil)
                }
                else
                {
                    self.navigationController?.pushViewController(noteViewController, animated: true)
                }
            }))
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        selectNotebook.addAction(cancelAction)
        
        //selectNotebook.prepareForIPAD(source: self.view, bartButtonItem: self.toolbarItems?.first, direction: .down)
        
        
        
        if ( UIDevice.current.userInterfaceIdiom == .pad ){
            
            if let currentPopoverpresentioncontroller = selectNotebook.popoverPresentationController{
                currentPopoverpresentioncontroller.barButtonItem = sender
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down;
                self.present(selectNotebook, animated: true, completion: nil)
            }
        }else{
            self.present(selectNotebook, animated: true, completion: nil)
        }
        
    }
    
    
   
    
    @objc private func handleNewNote() {
        
        if let currentDefaultNotebook = currentDefaultNotebook {
            
            let noteViewController = NoteDetailViewController()
            noteViewController.currentNotebook = currentDefaultNotebook
             
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
}
