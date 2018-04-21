//
//  ModalNoteViewController+UI Configuration.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit

extension ModalNoteViewController {
 
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
    
    
    // MARK: - Setup UI
    
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
        nameNotebookToDeleteAskLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        nameNotebookToDeleteAskLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        deleteNotebookVC.view.addSubview(notebookSwitchTransfer)
        notebookSwitchTransfer.topAnchor.constraint(equalTo: notebookToDeletePicker.bottomAnchor,constant: 12).isActive = true
        notebookSwitchTransfer.leftAnchor.constraint(equalTo: nameNotebookToDeleteAskLabel.rightAnchor, constant: 8).isActive = true
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

    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
}
