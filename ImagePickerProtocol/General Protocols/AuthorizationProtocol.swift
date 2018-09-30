//
//  AuthorizationProtocol.swift
//  FilePickerProtocol
//
//  Created by Akshay Garg on 30/09/18.
//  Copyright © 2018 Akshay Garg. All rights reserved.
//

import Foundation

import Photos

protocol AuthorizationProtocol {
    
    /// Method to check camera authorization
    ///
    /// - Parameter completion: Completion closure. Parameter will let us know if access was granted
    func checkCameraAuthorization(_ completion:@escaping (Bool)->())
    
    
    /// Method to check gallery authorization
    ///
    /// - Parameter completion: Completion closure. Parameter will let us know if access was granted.
    func checkGalleryAuthorization(_ completion:@escaping(Bool)->())
}

extension AuthorizationProtocol {
    
    func checkCameraAuthorization(_ completion:@escaping (Bool)->()){
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized : completion(true)
        case .restricted, .denied : completion(false)
        case .notDetermined :
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                completion(success)
            }
        }
    }
    
    func checkGalleryAuthorization(_ completion:@escaping(Bool)->()){
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized : completion(true)
        case .denied, .restricted : completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            })
        }
    }
}
