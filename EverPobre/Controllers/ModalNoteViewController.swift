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
 
    // MARK: - Initialization

    var currentDefaultNotebook : Notebook?
    {
        didSet {
            
            currentDefaultNotebookTextField.text = currentDefaultNotebook?.title
        
        }
    }
    

    var fetchedResultControllerDefault : NSFetchedResultsController<Notebook>!
    var fetchedResultControllerDelete : NSFetchedResultsController<Notebook>!
    var fetchedResultControllerTransfer : NSFetchedResultsController<Notebook>!
    
    
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
    
    // MARK: - Picker Notebook default management

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == notebookDefaultPicker {
            return fetchedResultControllerDefault.fetchedObjects!.count
        }
        else if pickerView == notebookToDeletePicker {
            return fetchedResultControllerDelete.fetchedObjects!.count
        }
        else if pickerView == notebookToTransferPicker {
            return fetchedResultControllerTransfer.fetchedObjects!.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let indexPath = IndexPath(row: row,  section: 0)
        var notebook = Notebook()
        if pickerView == notebookDefaultPicker {
            notebook   = self.fetchedResultControllerDefault.object(at: indexPath as IndexPath) as Notebook
        }
        else if  pickerView == notebookToDeletePicker {
            notebook  = self.fetchedResultControllerDelete.object(at: indexPath as IndexPath) as Notebook
        }
        else if  pickerView == notebookToTransferPicker {
            notebook  = self.fetchedResultControllerTransfer.object(at: indexPath as IndexPath) as Notebook
        }
        return notebook.title
    }
    

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


    
    // MARK: - UI Interaction

    
    @objc func closeKeyboard()
    {
        
        if nameNotebookTextField.isFirstResponder
        {
            nameNotebookTextField.resignFirstResponder()
        }
    }
    
    
   
    @objc func handleCancelModal() {
        
        dismiss(animated: true, completion: nil)
    }

   
    
    @objc func handleSave() {
       
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if tabBarCnt.selectedIndex ==  0 {  //new notebook creation
            
            if (nameNotebookTextField.text?.isEmpty)! {
                showError(title: "Empty notebook name", message: "You have not entered notebook name.")
                return
            }
            
            let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: context)  as! Notebook
            notebook.setValue(nameNotebookTextField.text, forKey: "title")
            notebook.setValue(false, forKey: "defaultNotebook")
            
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
            note.title = "New note +++3"
            note.notebook = notebook
            
            do {
                try context.save()
                dismiss(animated: true, completion: nil)
            } catch let saveErr {
                print("Fail saving notebook:", saveErr)
            }
            
        }
        else if tabBarCnt.selectedIndex == 1 { //delete
            var indexPath = IndexPath(row:  notebookToDeletePicker.selectedRow(inComponent: 0),  section: 0)
            let deleteNotebook  = self.fetchedResultControllerDelete.object(at: indexPath as IndexPath) as Notebook
           
            if (notebookSwitchTransfer.isOn){
                indexPath = IndexPath(row:  notebookToTransferPicker.selectedRow(inComponent: 0),  section: 0)
                let transferNotebook  = self.fetchedResultControllerTransfer.object(at: indexPath as IndexPath) as Notebook
                
                if deleteNotebook == transferNotebook {
                    showError(title: "Warning!", message: "Notebook to delete and notebook to transfer notes is the same")
                    return
                }
                for note in deleteNotebook.notes! {
                    (note as! Note).notebook = transferNotebook
                }
            }
            
            context.delete(deleteNotebook)
            do {
                try context.save()
                dismiss(animated: true, completion: nil)
            } catch let saveErr {
                print("Fail setting new default notebook:", saveErr)
            }
         }
        else if tabBarCnt.selectedIndex == 2 { //setdefault
            if let currentNotebook = currentDefaultNotebook {
                 currentNotebook.defaultNotebook = false
            }
            
            let indexPath = IndexPath(row: notebookDefaultPicker.selectedRow(inComponent: 0),  section: 0)
            let newDefaultNotebook  = self.fetchedResultControllerDefault.object(at: indexPath as IndexPath) as Notebook
            newDefaultNotebook.defaultNotebook = true
                    
            do {
                try context.save()
                dismiss(animated: true, completion: nil)
            } catch let saveErr {
                print("Fail setting new default notebook:", saveErr)
            }
            
        }
    }

    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Setup UI
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    
    
    func setupUIcreateNotebookVC(){
        createNotebookVC.title = "Create"
        createNotebookVC.view.backgroundColor =  .lightBlue



        createNotebookVC.view.addSubview(nameNotebookLabel)
        nameNotebookLabel.topAnchor.constraint(equalTo: createNotebookVC.view.topAnchor,constant: 4).isActive = true
        nameNotebookLabel.leftAnchor.constraint(equalTo: createNotebookVC.view.leftAnchor, constant: 16).isActive = true
        nameNotebookLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        nameNotebookLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        createNotebookVC.view.addSubview(nameNotebookTextField)
        nameNotebookTextField.topAnchor.constraint(equalTo: nameNotebookLabel.bottomAnchor,constant: 4).isActive = true
        nameNotebookTextField.leftAnchor.constraint(equalTo: createNotebookVC.view.leftAnchor,constant: 16).isActive = true
        nameNotebookTextField.rightAnchor.constraint(equalTo: createNotebookVC.view.rightAnchor, constant: -16).isActive = true
        nameNotebookTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
    }
    
    func setupUIdeleteNotebookVC(){
        deleteNotebookVC.title = "Delete"
        deleteNotebookVC.view.backgroundColor =  .lightBlue
        
        deleteNotebookVC.view.addSubview(nameNotebookToDeleteLabel)
        nameNotebookToDeleteLabel.topAnchor.constraint(equalTo: deleteNotebookVC.view.topAnchor,constant: 4).isActive = true
        nameNotebookToDeleteLabel.leftAnchor.constraint(equalTo: deleteNotebookVC.view.leftAnchor, constant: 16).isActive = true
        nameNotebookToDeleteLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameNotebookToDeleteLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
     
        deleteNotebookVC.view.addSubview(notebookToDeletePicker)
        notebookToDeletePicker.topAnchor.constraint(equalTo: nameNotebookToDeleteLabel.bottomAnchor,constant: 4).isActive = true
        notebookToDeletePicker.leftAnchor.constraint(equalTo: deleteNotebookVC.view.leftAnchor,constant: 16).isActive = true
        notebookToDeletePicker.rightAnchor.constraint(equalTo: deleteNotebookVC.view.rightAnchor, constant: -16).isActive = true
        notebookToDeletePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true

        
        
        deleteNotebookVC.view.addSubview(nameNotebookToDeleteAskLabel)
        nameNotebookToDeleteAskLabel.topAnchor.constraint(equalTo: notebookToDeletePicker.bottomAnchor,constant: 4).isActive = true
        nameNotebookToDeleteAskLabel.leftAnchor.constraint(equalTo: deleteNotebookVC.view.leftAnchor, constant: 16).isActive = true
        nameNotebookToDeleteAskLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameNotebookToDeleteAskLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        deleteNotebookVC.view.addSubview(notebookSwitchTransfer)
        notebookSwitchTransfer.topAnchor.constraint(equalTo: notebookToDeletePicker.bottomAnchor,constant: 4).isActive = true
        notebookSwitchTransfer.leftAnchor.constraint(equalTo: nameNotebookToDeleteAskLabel.rightAnchor, constant: 8).isActive = true
        notebookSwitchTransfer.rightAnchor.constraint(equalTo: deleteNotebookVC.view.rightAnchor, constant: -16).isActive = true
        notebookSwitchTransfer.widthAnchor.constraint(equalToConstant: 50).isActive = true
        notebookSwitchTransfer.centerYAnchor.constraint(equalTo: nameNotebookToDeleteAskLabel.centerYAnchor).isActive = true

        deleteNotebookVC.view.addSubview(notebookToTransferPicker)
        notebookToTransferPicker.topAnchor.constraint(equalTo: nameNotebookToDeleteAskLabel.bottomAnchor,constant: 4).isActive = true
        notebookToTransferPicker.leftAnchor.constraint(equalTo: deleteNotebookVC.view.leftAnchor,constant: 16).isActive = true
        notebookToTransferPicker.rightAnchor.constraint(equalTo: deleteNotebookVC.view.rightAnchor, constant: -16).isActive = true
        notebookToTransferPicker.heightAnchor.constraint(equalToConstant: 150).isActive = true


    }
    
    
    func setupUIsetDefaultNotebookVC(){
        setDefaultNotebookVC.title = "Set default"
        setDefaultNotebookVC.view.backgroundColor =  .lightBlue
        
        setDefaultNotebookVC.view.addSubview(currentDefaultNotebookLabel)
        currentDefaultNotebookLabel.topAnchor.constraint(equalTo: setDefaultNotebookVC.view.topAnchor,constant: 4).isActive = true
        currentDefaultNotebookLabel.leftAnchor.constraint(equalTo: setDefaultNotebookVC.view.leftAnchor, constant: 16).isActive = true
        currentDefaultNotebookLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        currentDefaultNotebookLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        setDefaultNotebookVC.view.addSubview(currentDefaultNotebookTextField)
        currentDefaultNotebookTextField.topAnchor.constraint(equalTo: currentDefaultNotebookLabel.bottomAnchor,constant: 4).isActive = true
        currentDefaultNotebookTextField.leftAnchor.constraint(equalTo: setDefaultNotebookVC.view.leftAnchor, constant: 16).isActive = true
        currentDefaultNotebookTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        currentDefaultNotebookTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        setDefaultNotebookVC.view.addSubview(nameNotebookSelectLabel)
        nameNotebookSelectLabel.topAnchor.constraint(equalTo: currentDefaultNotebookTextField.bottomAnchor,constant: 20).isActive = true
        nameNotebookSelectLabel.leftAnchor.constraint(equalTo: setDefaultNotebookVC.view.leftAnchor, constant: 16).isActive = true
        nameNotebookSelectLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameNotebookSelectLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        setDefaultNotebookVC.view.addSubview(notebookDefaultPicker)
        notebookDefaultPicker.topAnchor.constraint(equalTo: nameNotebookSelectLabel.bottomAnchor,constant: 4).isActive = true
        notebookDefaultPicker.leftAnchor.constraint(equalTo: setDefaultNotebookVC.view.leftAnchor,constant: 16).isActive = true
        notebookDefaultPicker.rightAnchor.constraint(equalTo: setDefaultNotebookVC.view.rightAnchor, constant: -16).isActive = true
        notebookDefaultPicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }

    func createTabBarController() {
        
        setupUIcreateNotebookVC()
        setupUIdeleteNotebookVC()
        setupUIsetDefaultNotebookVC()
        
        createNotebookVC.tabBarItem = UITabBarItem.init(title: "Create", image: #imageLiteral(resourceName: "plus"), tag: 0)
        deleteNotebookVC.tabBarItem = UITabBarItem.init(title: "Delete", image: #imageLiteral(resourceName: "delete"), tag: 1)
        setDefaultNotebookVC.tabBarItem = UITabBarItem.init(title: "Set default", image: #imageLiteral(resourceName: "favorites"), tag: 2)
        let controllerArray = [createNotebookVC, deleteNotebookVC,setDefaultNotebookVC]
        tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
        
        self.view.addSubview(tabBarCnt.view)
    }


    // MARK: - Fecth Data CD

    
    func fetchNotesbooksDefault() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
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
    
}
