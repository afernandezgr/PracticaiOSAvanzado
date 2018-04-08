//
//  NoteViewController.swift
//  EverPobre
//
//  Created by Adolfo Fernandez on 6/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NoteViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    var note: Note? {
        didSet {
        
            nameNotebookTextField.text = note?.notebook?.title
            nameNoteTextField.text = note?.title
            
            
     //       noteTextView.text = note?.content
            
//
//            if let imageData = company?.imageData {
//                companyImageView.image = UIImage(data: imageData)
//                setupCircularImageStyle()
//            }
//
//            guard let founded = company?.founded else { return }
//
            
            //dateLimitTextField.text = note?.dateLimit
        }
    }
    
    var relativePoint: CGPoint!
    var topImgConstraint: NSLayoutConstraint!
    var leftImgConstraint: NSLayoutConstraint!
    var map : MKMapView!
    let locationManager = CLLocationManager()


    // MARK: - Components UI

    var images : [UIImageView] = []
    
   
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
        label.text = "Tags"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 12)
  
        textView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        return textView
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isHidden = true
        return map
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        let madridLocation = CLLocation(latitude:40.41889 , longitude: -3.69194)
        self.mapView.setCenter(madridLocation.coordinate, animated: true)
        
        setupUI()
        setupNavigationBar()
        view.backgroundColor = .white

    }
    
    
    override func viewDidLayoutSubviews()
    {
        for imageView in images {
            
            var rect = view.convert(imageView.frame, to: noteTextView)
            rect = rect.insetBy(dx: -15, dy: -15)
            
            let paths = UIBezierPath(rect: rect)
            noteTextView.textContainer.exclusionPaths = [paths]
            
        }
        
    }
    
    private func setupNavigationBar()
    {
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        let mapBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "map")  , style: UIBarButtonItemStyle.plain, target: self, action: #selector(addLocation))
        
        navigationItem.title = "Note"
        navigationItem.rightBarButtonItems = [photoBarButton, mapBarButton]
//         navigationItem.rightBarButtonItems = [photoBarButton]
     }
    
    private func setupUI() {
        
        let headerView = UIView()
        view.addSubview(headerView)
        headerView.backgroundColor = .tealColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        
        
        headerView.addSubview(nameNotebookLabel)
        nameNotebookLabel.topAnchor.constraint(equalTo: headerView.topAnchor,constant: 4).isActive = true
        nameNotebookLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        nameNotebookLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameNotebookLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        headerView.addSubview(nameNotebookTextField)
        nameNotebookTextField.topAnchor.constraint(equalTo: headerView.topAnchor,constant: 4).isActive = true
        nameNotebookTextField.leftAnchor.constraint(equalTo: nameNotebookLabel.rightAnchor).isActive = true
        nameNotebookTextField.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        nameNotebookTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        headerView.addSubview(nameNoteLabel)
        nameNoteLabel.topAnchor.constraint(equalTo: nameNotebookLabel.bottomAnchor, constant: 2).isActive = true
        nameNoteLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        nameNoteLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameNoteLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        headerView.addSubview(nameNoteTextField)
        nameNoteTextField.topAnchor.constraint(equalTo: nameNotebookLabel.bottomAnchor, constant: 2).isActive = true
        nameNoteTextField.leftAnchor.constraint(equalTo: nameNotebookLabel.rightAnchor).isActive = true
        nameNoteTextField.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        nameNoteTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        headerView.addSubview(dateLimitLabel)
        dateLimitLabel.topAnchor.constraint(equalTo: nameNoteLabel.bottomAnchor, constant: 2).isActive = true
        dateLimitLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        dateLimitLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        dateLimitLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        headerView.addSubview(dateLimitTextField)
        dateLimitTextField.topAnchor.constraint(equalTo: nameNoteLabel.bottomAnchor, constant: 2).isActive = true
        dateLimitTextField.leftAnchor.constraint(equalTo: dateLimitLabel.rightAnchor).isActive = true
        dateLimitTextField.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        dateLimitTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        headerView.addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint(equalTo: dateLimitLabel.bottomAnchor, constant: 2).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        tagsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        tagsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    
        headerView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 2).isActive = true
        mapView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        mapView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        let backView = UIView()
        backView.tag = 1
        view.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
      
        backView.addSubview(noteTextView)
        noteTextView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 1).isActive = true
        noteTextView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        
      
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
        
        if noteTextView.isFirstResponder
        {
            noteTextView.resignFirstResponder()
        }
//        else if titleTextField.isFirstResponder
//        {
//            titleTextField.resignFirstResponder()
//        }
    }
    
    
    @objc func addLocation()
    {
        mapView.isHidden = false

    }
    

  
 
    
    @objc private func handleSave() {
        if note == nil {
            //createCompany()
        } else {
            //saveCompanyChanges()
        }
    }
    
  
   
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        addImageToNote(image: image)
        
        //imageView.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
   
    
    func addImageToNote(image: UIImage){
        let newImageView = UIImageView()
        newImageView.image = image
        
        view.addSubview(newImageView)
       
        newImageView.contentMode = .scaleAspectFill
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.isUserInteractionEnabled = true
        topImgConstraint = NSLayoutConstraint(item: newImageView, attribute: .top, relatedBy: .equal, toItem: noteTextView, attribute: .top, multiplier: 1, constant: 20)
        leftImgConstraint = NSLayoutConstraint(item: newImageView, attribute: .left, relatedBy: .equal, toItem: noteTextView, attribute: .left, multiplier: 1, constant: 20)
        var imgConstraints = [NSLayoutConstraint(item: newImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100)]
        imgConstraints.append(NSLayoutConstraint(item: newImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 150))
     
        imgConstraints.append(contentsOf: [topImgConstraint,leftImgConstraint])
        view.addConstraints(imgConstraints)
        
        //let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePan))
        let moveViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        newImageView.addGestureRecognizer(moveViewGesture)

        let pinchViewGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        newImageView.addGestureRecognizer(pinchViewGesture)

        let rotateViewGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        newImageView.addGestureRecognizer(rotateViewGesture)

        images.append(newImageView)
    }

    @objc func handleMoveImage(longPressGesture:UILongPressGestureRecognizer)
    {
    
        switch longPressGesture.state {
        case .began:
            closeKeyboard()
            relativePoint = longPressGesture.location(in: longPressGesture.view)
            UIView.animate(withDuration: 0.1, animations: {
                longPressGesture.view?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            })
            
        case .changed:
            let location = longPressGesture.location(in: noteTextView)
            
            leftImgConstraint.constant = location.x - relativePoint.x
            topImgConstraint.constant = location.y - relativePoint.y
            
        case .ended, .cancelled:
            
            UIView.animate(withDuration: 0.1, animations: {
                longPressGesture.view?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            
        default:
            break
        }
    }

    
    // handle UIPanGestureRecognizer
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let gview = recognizer.view
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: gview?.superview)
            gview?.center = CGPoint(x: (gview?.center.x)! + translation.x, y: (gview?.center.y)! + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: gview?.superview)
        }
    }
    
    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
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
