//
//  ImageFiltering.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/9/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import UIKit /// Provides support for images that is not available in `Foundation`
import CoreImage /// Required to access the built-in photo filters

protocol ImageFiltering {
    func apply(filter: String, originalImage: UIImage) -> UIImage
}


/// Declare a protocol `ImageFilteringDelegate`  that may only be adopted by a class. It will be used for passing data between view controllers.
protocol ImageFilteringDelegate: class {
    func filterSelected(item: FilterItem)
}

extension ImageFiltering {
    func apply(filter: String, originalImage: UIImage) -> UIImage {
        
        /// Convert the original image into `CIImage` format so that you can apply filters to it, and assigns it to `initialCIImage`.
        let initialCIImage = CIImage(image: originalImage, options: nil)
        
        /// Store the original image orientation.
        let originalOrientation = originalImage.imageOrientation
        
        /// Get the filter with the same name as `filter` and assign it to `ciFilter`. Returns an empty `UIImage` if the
        /// filter is not found.
        guard let ciFilter = CIFilter(name: filter) else {
            print("filter not found")
            return UIImage()
        }
        
        /// Apply the selected filter to `initialCIImage` and store the result in `filteredCIImage`.
        ciFilter.setValue(initialCIImage, forKey: kCIInputImageKey)
        let context = CIContext()
        let filteredCIImage = (ciFilter.outputImage)!
        
        /// Convert the `CIImage` stored in `filteredCIImage` back into `UIImage` format and return it.
        let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)
        
        return UIImage(cgImage: filteredCGImage!, scale: 1.0, orientation: originalOrientation)
    }
}
