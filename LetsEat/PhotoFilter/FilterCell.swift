//
//  FilterCell.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/9/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgThumb: UIImageView!
    
}

extension FilterCell: ImageFiltering {
    func set(image: UIImage, item: FilterItem) {
        if item.filter != "None" {
            let filteredImg = apply(filter: item.filter, originalImage: image)
            imgThumb.image = filteredImg
        } else {
            imgThumb.image = image
        }
        lblName.text = item.name
        roundedCorners()
    }
    
    func roundedCorners() {
        imgThumb.layer.cornerRadius = 9
        imgThumb.layer.masksToBounds = true
    }
}
