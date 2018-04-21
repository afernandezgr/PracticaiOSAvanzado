//
//  NoteDetailViewController+CoreData operations.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import CoreData
import UIKit

extension NoteDetailViewController {
    //MARK: - CoreData Operations
    
    
     func createNewNote() {
        
        let backMOC = CoreDataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        //save general attributes
        
        if nameNoteTextField.text == "" {
            showError(title: "Name requiered", message: "Please enter note name")
            return
        }
        
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: backMOC) as! Note
        
        
        //validate date
        guard let dateLimitTextField = dateLimitTextField.text else { return }
        if !dateLimitTextField.isEmpty{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            guard let dateLimit = dateFormatter.date(from: dateLimitTextField) else {
                showError(title: "Bad format date", message: "Date format is not correct. Please use (dd/MM/yyyy)")
                return
            }
            newNote.dateLimit = dateLimit
        }
        newNote.notebook = (backMOC.object(with:(currentDefaultNotebook?.objectID)!)  as! Notebook)
        newNote.notebook?.title = nameNotebookTextField.text
        newNote.title = nameNoteTextField.text
        newNote.content = noteTextView.text
        
        //save location
        if !mapView.isHidden{
            newNote.longitude = mapView.centerCoordinate.longitude
            newNote.latitude = mapView.centerCoordinate.latitude
        }
        else {
            newNote.longitude = 0
            newNote.latitude = 0
        }
        
        //save tags
        
        if let count = note?.tags?.count, count > 0 {
            deleteAllTags(note: note!, moc: backMOC)
        }
        var newTag : Tag
        for tag in extractTagsFromText(text: noteTextView.text){
            newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: backMOC) as! Tag
            newTag.name = tag
            newTag.note = note
        }
        
        // save images
        var newImage : ImageNote
        for imageView in images {
            newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageNote", into: backMOC) as! ImageNote
            
            if let imageData = UIImageJPEGRepresentation(imageView.image!, 0.8) {
                newImage.imageData = imageData
            }
            
            newImage.posX = Double(imageView.frame.origin.x)
            newImage.posY = Double(imageView.frame.origin.y)
            newImage.width = Double(imageView.frame.width)
            newImage.height = Double(imageView.frame.height)
           
            let angle : CGFloat = CGFloat(atan2f(Float(imageView.transform.b), Float(imageView.transform.b)))
            newImage.rotation = Double(angle)
            
            newImage.note = note
            //TO DO: Scale management and rotation
            
        }
        
        backMOC.perform {
            //     _ = backMOC.object(with:(newNote.objectID)) as! Note
            
            do {
                try backMOC.save()
            } catch let saveErr {
                print("Fail saving notebook:", saveErr)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveNoteChanges(){
        
        // let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        
        let backMOC = CoreDataManager.sharedManager.persistentContainer.newBackgroundContext()
        
        
        let backNote = backMOC.object(with: (note?.objectID)!) as! Note
        
        //save general attributes
        //validate date
        
        guard let dateLimitTextField = dateLimitTextField.text else { return }
        if !dateLimitTextField.isEmpty{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            guard let dateLimit = dateFormatter.date(from: dateLimitTextField) else {
                showError(title: "Bad format date", message: "Date format is not correct (dd/MM/yyyy")
                return
            }
            backNote.dateLimit = dateLimit
        }
        
        backNote.notebook?.title = nameNotebookTextField.text
        backNote.title = nameNoteTextField.text
        backNote.content = noteTextView.text
        
        //save location
        if !mapView.isHidden{
            backNote.longitude = mapView.centerCoordinate.longitude
            backNote.latitude = mapView.centerCoordinate.latitude
        }
        else {
            backNote.longitude = 0
            backNote.latitude = 0
        }
        
        //save tags
        if (backNote.tags?.count)! > 0{
            deleteAllTags(note: backNote, moc: backMOC)
        }
        var newTag : Tag
        for tag in extractTagsFromText(text: noteTextView.text){
            newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: backMOC) as! Tag
            newTag.name = tag
            newTag.note = backNote
        }
        
        //save images
        if (images.count) > 0{
            deleteAllImages(note: backNote, moc: backMOC)
        }
        
        var newImage : ImageNote
        for imageView in images {
            newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageNote", into: backMOC) as! ImageNote
            
            if let imageData = UIImageJPEGRepresentation(imageView.image!, 0.8) {
                newImage.imageData = imageData
            }
            
            newImage.posX = Double(imageView.frame.origin.x)
            newImage.posY = Double(imageView.frame.origin.y)
            newImage.width = Double(imageView.frame.width)
            newImage.height = Double(imageView.frame.height)
            
            let angle : CGFloat = CGFloat(atan2f(Float(imageView.transform.b), Float(imageView.transform.b)))
            newImage.rotation = Double(angle)
            newImage.note = backNote
            //TO DO: Scale management and rotation
           
        }
        
        
        backMOC.performAndWait {
            do {
                try backMOC.save()
                
            } catch let saveErr {
                print("Fail updating notebook:", saveErr)
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func deleteAllTags(note : Note, moc: NSManagedObjectContext)
    {
        if let tags = note.tags{
            for tag in tags {
                moc.delete(tag as! Tag)
            }
        }
        
    }
    
    private func deleteAllImages(note : Note, moc: NSManagedObjectContext)
    {
        if let images = note.images{
            for image in images {
                moc.delete(image as! ImageNote)
            }
        }
    }
    
    private func extractTagsFromText(text : String) -> [String]
    {
        let words = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return words.filter { $0.hasPrefix("#") }
        
    }
    
    func concatTags(tags : NSSet) -> String
    {
        var tagsString : String = ""
        for tag in tags {
            tagsString = tagsString + " \((tag as! Tag).name ?? "")"
        }
        return tagsString
    }
    
    
}
