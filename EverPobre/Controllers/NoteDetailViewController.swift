//
//  NoteViewController.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 6/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MapKit

class NoteDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    
    var note: Note? {
        didSet {
        
            nameNotebookTextField.text = note?.notebook?.title
            nameNoteTextField.text = note?.title
            noteTextView.text = note?.content
            
            if let dateLimit = note?.dateLimit {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                dateLimitTextField.text = formatter.string(from: dateLimit)
            }
            
            if let tags = note?.tags {
                if tags.count > 0{
                    tagsTextField.text = concatTags(tags: tags)
                }
            }
            
            let location : CLLocation
            mapView.isHidden = true
            if let longitude = note?.longitude, let latitude = note?.latitude {
                location = CLLocation(latitude: latitude, longitude: longitude)
            } else {
                location = CLLocation(latitude:0 , longitude: 0)
            }
            mapView.setCenter(location.coordinate, animated: true)
        
            if (location.coordinate.latitude != 0 && location.coordinate.longitude != 0) {
                mapView.isHidden = false
            }
            
            if let imagesNote = note?.images {
                for case let image as ImageNote in imagesNote {
                    let newImageView = UIImageView()
                    
                    newImageView.image = UIImage(data: image.imageData!)
                    newImageView.contentMode = .scaleAspectFill
                    newImageView.translatesAutoresizingMaskIntoConstraints = false
                    newImageView.isUserInteractionEnabled = true
                    
                    view.viewWithTag(1010)?.addSubview(newImageView)
                    newImageView.topAnchor.constraint(equalTo: noteTextView.topAnchor, constant: CGFloat(image.posY)).isActive = true
                    newImageView.leftAnchor.constraint(equalTo: noteTextView.leftAnchor, constant: CGFloat(image.posX)).isActive = true
                    newImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
                    newImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                    
                    let moveViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
                    newImageView.addGestureRecognizer(moveViewGesture)
                    
                    let pinchViewGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
                    newImageView.addGestureRecognizer(pinchViewGesture)
                    
                    let rotateViewGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
                    newImageView.addGestureRecognizer(rotateViewGesture)

                   images.append(newImageView)
                    avoidImageTextOverlap(imageView: newImageView)
                }
            }
         
        }
    }
    
    var currentDefaultNotebook: Notebook?
    
    // MARK: - Components UI

    var images : [UIImageView] = []
    var map : MKMapView!
    let locationManager = CLLocationManager()
   
    let nameNotebookLabel: UILabel = {
        let label = UILabel()
        label.text = "Notebook:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let nameNotebookTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name notebook"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    
    let nameNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    let nameNoteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name note"
        textField.translatesAutoresizingMaskIntoConstraints = false
         textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let dateLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Date limit:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let dateLimitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "dd/mm/yyyy"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tags:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "write # symbol in text to create tags"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isEnabled = false
        return textField
    }()
    
    
    let spaceView : UIView = {
        let spaceView = UIView()
        spaceView.backgroundColor = .darkGray
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        return spaceView
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.backgroundColor = .white
        textView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        return textView
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isHidden = true
        map.mapType = .hybrid
        map.showsCompass = true
        map.showsScale = true
        return map
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note == nil {
            nameNotebookTextField.text = currentDefaultNotebook?.title
        }
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
  
       
        setupUI()
        setupNavigationBar()
        view.backgroundColor = .lightGray
        
    }
    
    
    func avoidImageTextOverlap(imageView: UIView)
    {
            var rect = noteTextView.convert(imageView.frame, to: noteTextView)
            rect = rect.insetBy(dx: -15, dy: -15)

            let path = UIBezierPath(rect: rect)
            noteTextView.textContainer.exclusionPaths=[path]
    }
    
    private func setupNavigationBar()
    {
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        let mapBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "map")  , style: UIBarButtonItemStyle.plain, target: self, action: #selector(addLocation))
        let saveButton = UIBarButtonItem(image: #imageLiteral(resourceName: "save") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSave))
        
        
        navigationItem.title = "Note"
        navigationItem.rightBarButtonItems = [saveButton, photoBarButton, mapBarButton]
    }
    
    private func setupUI() {
        
        
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
        
    }

    @objc func catchPhoto()
    {
        let actionSheetAlert = UIAlertController(title: NSLocalizedString("Add photo", comment: "Add photo"), message: nil, preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let useCamera = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let usePhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        
        actionSheetAlert.addAction(useCamera)
        actionSheetAlert.addAction(usePhotoLibrary)
        actionSheetAlert.addAction(cancel)
        
        present(actionSheetAlert, animated: true, completion: nil)
    }
    
    @objc func closeKeyboard()
    {
        
//        if noteTextView.isFirstResponder
//        {
//            noteTextView.resignFirstResponder()
//        }
//        else if titleTextField.isFirstResponder
//        {
//            titleTextField.resignFirstResponder()
//        }
    }
    
    
    @objc func addLocation()
    {
        mapView.isHidden =  !mapView.isHidden
    }

    
    @objc private func handleSave() {
        if note == nil {
            createNewNote()
        } else {
            saveNoteChanges()
        }
    }
    
    private func createNewNote() {
        
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
            newImage.note = note
            
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
    
    private func saveNoteChanges(){
        
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
            newImage.note = backNote
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
      // let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        if let tags = note.tags{
            for tag in tags {
                moc.delete(tag as! Tag)
            }
        }
        
    }
    
    private func deleteAllImages(note : Note, moc: NSManagedObjectContext)
    {
  //      let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
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
    
    private func concatTags(tags : NSSet) -> String
    {
        var tagsString : String = ""
        for tag in tags {
            tagsString = tagsString + " \((tag as! Tag).name ?? "")"
        }
        return tagsString
        
    }
    
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
  
   
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        addImageToNote(image: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
   
    
    func addImageToNote(image: UIImage){
        let newImageView = UIImageView()
        newImageView.image = image
        newImageView.contentMode = .scaleAspectFill
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.isUserInteractionEnabled = true
        
        view.viewWithTag(1010)?.addSubview(newImageView)
        newImageView.topAnchor.constraint(equalTo: noteTextView.topAnchor, constant: 50).isActive = true
        newImageView.leftAnchor.constraint(equalTo: noteTextView.leftAnchor, constant: 50).isActive = true
        newImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        newImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let moveViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        newImageView.addGestureRecognizer(moveViewGesture)

        let pinchViewGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        newImageView.addGestureRecognizer(pinchViewGesture)

        let rotateViewGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        newImageView.addGestureRecognizer(rotateViewGesture)

        images.append(newImageView)
    }

//    @objc func handlePan(longPressGesture:UIPanGestureRecognizer)
//    {
//
//        switch longPressGesture.state {
//        case .began:
//            closeKeyboard()
//            relativePoint = longPressGesture.location(in: longPressGesture.view)
//            UIView.animate(withDuration: 0.1, animations: {
//                longPressGesture.view?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
//            })
//
//        case .changed:
//            let location = longPressGesture.location(in: noteTextView)
//
////            longPressGesture.view?.constraints[
//            leftImgConstraint.constant = location.x - relativePoint.x
//            topImgConstraint.constant = location.y - relativePoint.y
//
//        case .ended, .cancelled:
//
//            UIView.animate(withDuration: 0.1, animations: {
//                longPressGesture.view?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//            })
//
//        default:
//            break
//        }
//    }

    
   
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        //let gview = recognizer.view
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: recognizer.view)

            //let translation = recognizer.translation(in: noteTextView)
            recognizer.view?.center = CGPoint(x: (recognizer.view?.center.x)! + translation.x, y: (recognizer.view?.center.y)! + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            //viewDidLayoutSubviews()
            avoidImageTextOverlap(imageView: recognizer.view!)
        }
    }

    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed || recognizer.state == .ended {
//            var currentScale:CGFloat = 1
//
//            var newScale:CGFloat = currentScale * recognizer.scale;
//            if (newScale < 0.7) {
//                newScale = 0.7;
//            }
//            if (newScale > 1.5) {
//                newScale = 1.5;
//            }
//
            
            if (recognizer.scale >= 0.7 && recognizer.scale<=1.3){
                recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
            }
            recognizer.scale = 1.0
        }
    }
    
    // handle UIRotationGestureRecognizer
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
           
            recognizer.view?.transform = (recognizer.view?.transform.rotated(by: recognizer.rotation))!
            recognizer.rotation = 0.0
                
        }
    }
    
    // MARK: - Location Manage Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.mapView.setCenter(location.coordinate, animated: true)
    }

}

extension NoteDetailViewController : NoteTableViewControllerDelegate {
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note : Note) {
        self.note = note
    }
}
