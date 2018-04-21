//
//  NoteDetailViewController+UImage Management.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import Foundation
import UIKit

extension NoteDetailViewController {
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        addImageToNote(image: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func catchPhoto(sender: UIBarButtonItem)
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
        
        if ( UIDevice.current.userInterfaceIdiom == .pad ){
            
            if let currentPopoverpresentioncontroller = actionSheetAlert.popoverPresentationController{
                currentPopoverpresentioncontroller.barButtonItem = sender
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down;
                self.present(actionSheetAlert, animated: true, completion: nil)
            }
        }else{
            self.present(actionSheetAlert, animated: true, completion: nil)
        }
        
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
    

    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            closeKeyboard()
            break
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            recognizer.view?.center = CGPoint(x: (recognizer.view?.center.x)! + translation.x, y: (recognizer.view?.center.y)! + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        case .ended:
            avoidImageTextOverlap()
        default:
            break
        }
    }
    
    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            closeKeyboard()
            break
        case .changed:
            let currentScale:CGFloat = 1
            var newScale:CGFloat = currentScale * recognizer.scale;
            if (newScale < 0.7) {
                newScale = 0.7;
            }
            if (newScale > 1.5) {
                newScale = 1.5;
            }
            recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: newScale, y: newScale))!
            recognizer.scale = 1.0
            break
        case .ended,.cancelled:
            avoidImageTextOverlap()
            break
        default:
            break
        }
    }
    
    // handle UIRotationGestureRecognizer
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            closeKeyboard()
            recognizer.view?.transform = (recognizer.view?.transform.rotated(by: recognizer.rotation))!
            recognizer.rotation = 0.0
            break
        case .ended,.cancelled:
            avoidImageTextOverlap()
            break
        default:
            break
        }
    }
        
        
    func avoidImageTextOverlap(){
        var paths = [UIBezierPath]()
        
        for image in images {
            var rect = noteTextView.convert(image.frame, to: noteTextView)
            rect = rect.insetBy(dx: -15, dy: -15)
            paths.append(UIBezierPath(rect: rect))
        }
        noteTextView.textContainer.exclusionPaths=paths
    }
}
