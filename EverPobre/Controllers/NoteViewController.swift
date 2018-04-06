//
//  NoteViewController.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 6/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    var note: Note? {
        didSet {
        
            nameNotebookTextField.text = note?.notebook?.title
            nameNoteTextField.text = note?.title
            
//
//            if let imageData = company?.imageData {
//                companyImageView.image = UIImage(data: imageData)
//                setupCircularImageStyle()
//            }
//
//            guard let founded = company?.founded else { return }
//
//            datePicker.date = founded
        }
    }
    
   
    let nameNotebookLabel: UILabel = {
        let label = UILabel()
        label.text = "Name notebook:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        return label
    }()
    
    let nameNotebookTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name notebook"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .green
        return textField
    }()
    
    
    let nameNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Name note:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let nameNoteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name note"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
    }
    
    @objc private func handleSave() {
        if note == nil {
            //createCompany()
        } else {
            //saveCompanyChanges()
        }
    }
    
    private func setupUI() {
        //let backView = UIView()
       
        
        
//        view.addSubview(companyImageView)
//        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
//        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(nameNotebookLabel)
        nameNotebookLabel.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        nameNotebookLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        nameNotebookLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        nameNotebookLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        view.addSubview(nameNotebookTextField)
//        nameNotebookTextField.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
//        nameNotebookTextField.leftAnchor.constraint(equalTo: nameNotebookLabel.rightAnchor).isActive = true
//        nameNotebookTextField.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
//        nameNotebookLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
      
        
        // setup the date picker here
        
//        view.addSubview(datePicker)
//        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
//        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true

        //self.view = backView
    }
   
    

   

}
