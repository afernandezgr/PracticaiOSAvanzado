//
//  ModalNoteViewController.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 10/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class ModalNoteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {
 
    //MARK: - Set of object

    var currentDefaultNotebook : Notebook?
    {
        didSet {
            currentDefaultNotebookTextField.text = currentDefaultNotebook?.title
        }
    }
    var fetchedResultControllerDefault : NSFetchedResultsController<Notebook>!
    var fetchedResultControllerDelete : NSFetchedResultsController<Notebook>!
    var fetchedResultControllerTransfer : NSFetchedResultsController<Notebook>!
    
   
      // MARK: - Proporties Components UI
    
    let tabBarCnt = UITabBarController()
    
    let createNotebookVC = UIViewController()
    let deleteNotebookVC = UIViewController()
    let setDefaultNotebookVC = UIViewController()
    
    let nameNotebookLabel: UILabel = {
        let label = UILabel()
        label.text = "Notebook name:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let nameNotebookTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name notebook:"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    let nameNotebookSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "Select new default notebook:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    let currentDefaultNotebookLabel: UILabel = {
        let label = UILabel()
        label.text = "Current default Notebook name:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
   
    
    let currentDefaultNotebookTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    let notebookDefaultPicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
   
        return picker
    }()
    
    let nameNotebookToDeleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Notebook to delete:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let notebookToDeletePicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    let nameNotebookToDeleteAskLabel: UILabel = {
        let label = UILabel()
        label.text = "If you want to assign notes in the notebook to another notebook please mark this option and select:"
        label.textAlignment = .justified
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let notebookToTransferPicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    let notebookSwitchTransfer : UISwitch = {
       let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.isOn = false
        switcher.tintColor = .darkBlue
        return switcher
    }()
    


    // MARK: - Cycle life
   
    override func viewDidLoad() {
        super.viewDidLoad()
       setupCancelButton()
       setupSaveButton()
        
        
       navigationItem.title = "Options Notebook"
        
       tabBarCnt.tabBar.tintColor = .darkBlue
       createTabBarController()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
        swipeGesture.direction = .down
        
        
        notebookDefaultPicker.dataSource = self
        notebookDefaultPicker.delegate = self
        
        notebookToDeletePicker.dataSource = self
        notebookToDeletePicker.delegate = self
        
        notebookToTransferPicker.dataSource = self
        notebookToTransferPicker.delegate = self
        
        fetchNotesbooksDefault()
        fetchNotesbooksDelete()
        fetchNotesbooksTransfer()
    }


 
    

  
 
    
    
}
