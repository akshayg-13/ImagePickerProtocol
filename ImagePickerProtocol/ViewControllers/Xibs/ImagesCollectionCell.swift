//
//  ImagesCollectionCell.swift
//  FilePickerProtocol
//
//  Created by Akshay Garg on 30/09/18.
//  Copyright © 2018 Akshay Garg. All rights reserved.
//

import UIKit

class ImagesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
}
