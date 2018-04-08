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
            
            if let dateLimit = note?.dateLimit {
                datePicker.date = dateLimit
            }
        }
    }
    
    var relativePoint: CGPoint!
    var topImgConstraint: NSLayoutConstraint!
    var leftImgConstraint: NSLayoutConstraint!
    var map : MKMapView!
    let locationManager = CLLocationManager()

    // MARK: - Components UI

    var images : [UIImageView] = []
    
    
//    let imageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
   
    let nameNotebookLabel: UILabel = {
        let label = UILabel()
        label.text = "Notebook:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let nameNotebookTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name notebook"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    let nameNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    let nameNoteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name note"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Date limit:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let dateLimitTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter date limit"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.isHidden = true
        return dp
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .green
        textView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupUI()
        setupNavigationBar()
        view.backgroundColor = .white
        self.dateLimitTextField.addTarget(self, action: #selector(textFieldTouched), for: UIControlEvents.editingDidBegin)
        self.datePicker.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)

//        let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
//        imageView.addGestureRecognizer(moveViewGesture)

        
    }
    
    
    override func viewDidLayoutSubviews()
    {
        for imageView in images{
            
            var rect = view.convert(imageView.frame, to: noteTextView)
            rect = rect.insetBy(dx: -15, dy: -15)
            
            let paths = UIBezierPath(rect: rect)
            noteTextView.textContainer.exclusionPaths = [paths]
            
        }
        //print (noteTextView.textContainer.exclusionPaths)
    }
    
    private func setupNavigationBar()
    {
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        let mapBarButton = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(addLocation))
        
        navigationItem.rightBarButtonItems = [photoBarButton, mapBarButton]
     }
    
    private func setupUI() {
        
        let headerView = UIView()
        view.addSubview(headerView)
        headerView.backgroundColor = .tealColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
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
        
        
        headerView.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameNoteTextField.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: dateLimitLabel.rightAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        
        
        
        
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
        
        
        
//        view.addSubview(imageView)
//        topImgConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: noteTextView, attribute: .top, multiplier: 1, constant: 20)
//        leftImgConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: noteTextView, attribute: .left, multiplier: 1, constant: 20)
//        var imgConstraints = [NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 100)]
//        imgConstraints.append(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 150))
//        imgConstraints.append(contentsOf: [topImgConstraint,leftImgConstraint])
//        view.addConstraints(imgConstraints)
        
        
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
    
  
    
//    override func viewDidLayoutSubviews()
//    {
//        if let viewBack = view.viewWithTag(1) {
//            var rect = viewBack.convert(imageView.frame, to: noteTextView)
//            rect = rect.insetBy(dx: -15, dy: -15)
//            let paths = UIBezierPath(rect: rect)
//            noteTextView.textContainer.exclusionPaths = [paths]
//
//        } else { return }
//        print(noteTextView.textContainer.exclusionPaths)
//    }
  
  
    
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
        
    }
    

    @objc func datePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        dateLimitTextField.text = strDate
        datePicker.isHidden = true
    }
    
    @objc func textFieldTouched() {
        print("comanienza edición")

        datePicker.isHidden = false
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
        
        let moveViewGesture = UILongPressGestureRecognizer(target: self, action: #selector(userMoveImage))
        newImageView.addGestureRecognizer(moveViewGesture)

        images.append(newImageView)
    }

    @objc func userMoveImage(longPressGesture:UILongPressGestureRecognizer)
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
}
