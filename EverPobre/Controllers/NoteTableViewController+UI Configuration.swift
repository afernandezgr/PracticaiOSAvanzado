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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plusnote"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleNewNote))
    }
    
    @objc private func optionsNote(){
        let modalNoteViewController = ModalNoteViewController()
        modalNoteViewController.currentDefaultNotebook = currentDefaultNotebook
        
        let navController = UINavigationController(rootViewController: modalNoteViewController)
        self.present(navController, animated: true)
    }
    
    
    @objc private func handleNewNote() {
        
        if let currentDefaultNotebook = currentDefaultNotebook {
            
            let noteViewController = NoteDetailViewController()
            noteViewController.currentDefaultNotebook = currentDefaultNotebook
             
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
