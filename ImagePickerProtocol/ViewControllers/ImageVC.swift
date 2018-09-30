//
//  ImageVC.swift
//  FilePickerProtocol
//
//  Created by Akshay Garg on 30/09/18.
//  Copyright © 2018 Akshay Garg. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, ImagePickerProtocol {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Images"
        setupAddButton()
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped(_ sender : UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "Select source type", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.openCamera(showFront: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ImageVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as? ImagesCollectionCell else { return UICollectionViewCell() }
        
        cell.mainImageView.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 6) / 4
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ImageVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else { return }
        let indexPath = IndexPath(item: images.count, section: 0)
        images.append(image)
        mainCollectionView.insertItems(at: [indexPath])
    }
}
