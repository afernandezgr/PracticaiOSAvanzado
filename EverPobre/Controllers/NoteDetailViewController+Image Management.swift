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
    
    func avoidImageTextOverlap(imageView: UIView)
    {
        var rect = noteTextView.convert(imageView.frame, to: noteTextView)
        rect = rect.insetBy(dx: -15, dy: -15)
        
        let path = UIBezierPath(rect: rect)
        noteTextView.textContainer.exclusionPaths=[path]
    }
}
