//
//  THLVenueDiscoveryViewCell.swift
//  Hype
//
//  Created by Edgar Li on 6/21/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import ParseUI

class THLVenueDiscoveryViewCell : PFCollectionViewCell {
    var venueImageView: PFImageView!
    lazy var venueImageView: [PFImageView] = {
        var imageView = [PFImageView]()
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        return imageView
    }()
    
    var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            venueImageView.image = imageToDisplay
            
        }
        else {
            spinner.startAnimating()
            venueImageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(nil)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    }
}

