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

    //MARK: - Set of object
    
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
                    //recover tag of the TextView to add images inside
                    
                    view.viewWithTag(1010)?.addSubview(newImageView)
                    newImageView.topAnchor.constraint(equalTo: noteTextView.topAnchor, constant: CGFloat(image.posY)).isActive = true
                    newImageView.leftAnchor.constraint(equalTo: noteTextView.leftAnchor, constant: CGFloat(image.posX)).isActive = true
                    newImageView.widthAnchor.constraint(equalToConstant: CGFloat(image.width)).isActive = true
                    newImageView.heightAnchor.constraint(equalToConstant: CGFloat(image.height)).isActive = true
                    
                    let transform : CGAffineTransform  = CGAffineTransform(rotationAngle: CGFloat(image.rotation))
                    newImageView.transform = transform
                    
                    let moveViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
                    newImageView.addGestureRecognizer(moveViewGesture)
                    
                    let pinchViewGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
                    newImageView.addGestureRecognizer(pinchViewGesture)
                    
                    let rotateViewGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
                    newImageView.addGestureRecognizer(rotateViewGesture)

                    images.append(newImageView)
                }
                avoidImageTextOverlap()
            }
         
        }
    }
    
    var currentNotebook: Notebook?
    
    // MARK: - Proporties Components UI

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
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note == nil {
            nameNotebookTextField.text = currentNotebook?.title
        }
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
         
        setupUI()
        setupNavigationBar()
        view.backgroundColor = .lightGray
        
    }

}

extension NoteDetailViewController : NoteTableViewControllerDelegate {
    func noteTableViewController(_ viewController: NoteTableViewController, didSelectNote note : Note) {
        self.note = note
    }
}
