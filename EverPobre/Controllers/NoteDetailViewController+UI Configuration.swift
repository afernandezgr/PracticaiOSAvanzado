//
//  NoteDetailViewController+UI Configuration.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit

extension NoteDetailViewController {
    
    func setupNavigationBar()
    {
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        let mapBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "map")  , style: UIBarButtonItemStyle.plain, target: self, action: #selector(addLocation))
        let saveButton = UIBarButtonItem(image: #imageLiteral(resourceName: "save") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSave))
        
        navigationItem.title = "Note"
        navigationItem.rightBarButtonItems = [saveButton, photoBarButton, mapBarButton]
    }
    
    func setupUI() {
        
        
        view.addSubview(nameNotebookLabel)
        nameNotebookLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 4).isActive = true
        nameNotebookLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        nameNotebookLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameNotebookLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(nameNotebookTextField)
        nameNotebookTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 4).isActive = true
        nameNotebookTextField.leftAnchor.constraint(equalTo: nameNotebookLabel.rightAnchor).isActive = true
        nameNotebookTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameNotebookTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(nameNoteLabel)
        nameNoteLabel.topAnchor.constraint(equalTo: nameNotebookLabel.bottomAnchor, constant: 2).isActive = true
        nameNoteLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        nameNoteLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameNoteLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(nameNoteTextField)
        nameNoteTextField.topAnchor.constraint(equalTo: nameNotebookLabel.bottomAnchor, constant: 2).isActive = true
        nameNoteTextField.leftAnchor.constraint(equalTo: nameNotebookLabel.rightAnchor).isActive = true
        nameNoteTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        nameNoteTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(dateLimitLabel)
        dateLimitLabel.topAnchor.constraint(equalTo: nameNoteLabel.bottomAnchor, constant: 2).isActive = true
        dateLimitLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        dateLimitLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        dateLimitLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(dateLimitTextField)
        dateLimitTextField.topAnchor.constraint(equalTo: nameNoteLabel.bottomAnchor, constant: 2).isActive = true
        dateLimitTextField.leftAnchor.constraint(equalTo: dateLimitLabel.rightAnchor).isActive = true
        dateLimitTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        dateLimitTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint(equalTo: dateLimitLabel.bottomAnchor, constant: 2).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        tagsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        tagsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        view.addSubview(tagsTextField)
        tagsTextField.topAnchor.constraint(equalTo: dateLimitLabel.bottomAnchor, constant: 2).isActive = true
        tagsTextField.leftAnchor.constraint(equalTo: tagsLabel.rightAnchor).isActive = true
        tagsTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tagsTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 2).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        view.addSubview(spaceView)
        spaceView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 2).isActive = true
        spaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        spaceView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        spaceView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        view.addSubview(noteTextView)
        noteTextView.tag = 1010
        noteTextView.topAnchor.constraint(equalTo: spaceView.bottomAnchor, constant: 2).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        noteTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func closeKeyboard()
    {
        
        if noteTextView.isFirstResponder
        {
            noteTextView.resignFirstResponder()
        }
        else if nameNoteTextField.isFirstResponder
        {
            nameNoteTextField.resignFirstResponder()
        }
    }
    
    @objc  func handleSave() {
        if note == nil {
            createNewNote()
        } else {
            saveNoteChanges()
        }
    }
}
