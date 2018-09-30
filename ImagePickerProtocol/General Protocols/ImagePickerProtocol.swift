//
//  ImagePickerProtocol.swift
//  FilePickerProtocol
//
//  Created by Akshay Garg on 30/09/18.
//  Copyright © 2018 Akshay Garg. All rights reserved.
//

import UIKit

protocol ImagePickerProtocol : AuthorizationProtocol {
    
    func openCamera(showFront : Bool)
    func openGallery()
}

extension ImagePickerProtocol {
    func openCamera(showFront : Bool) { }
    func openGallery() { }
}

extension ImagePickerProtocol where Self : UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private var imagePickerController : UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        return imagePickerController
    }
    
    func openCamera(showFront : Bool) {
        checkCameraAuthorization { (authorized) in
            if authorized {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = self.imagePickerController
                    picker.sourceType = .camera
                    picker.cameraDevice = showFront ? .front : .rear
                    self.present(picker, animated: true, completion: nil)
                } else {
                    self.openGallery()
                }
            } else {
                self.showGoToSettingsAlert(isCamera: true)
            }
        }
    }
    
    func openGallery() {
        checkGalleryAuthorization { (authorized) in
            if authorized {
                let picker = self.imagePickerController
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showGoToSettingsAlert(isCamera: false)
            }
        }
    }
    
    private func showGoToSettingsAlert(isCamera : Bool) {
        let text = isCamera ? "Camera" : "Gallery"
        let alert = UIAlertController(title: "No \(text) Access", message: "Permission for \(text) is not granted. Please go to settings to enable \(text) access.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .destructive, handler: { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                DispatchQueue.main.async{
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
