//
//  RatingsView.swift
//  LetsEat
//
//  Created by Krista Nittmann on 6/8/20.
//  Copyright © 2020 MyName. All rights reserved.
//

import UIKit

class RatingsView: UIControl {

    let imgFilledStar = #imageLiteral(resourceName: "filled-star")
    let imgHalfStar = #imageLiteral(resourceName: "half-star")
    let imgEmptyStar = #imageLiteral(resourceName: "empty-star")
    let shouldBecomeFirstResponder = true
    var rating: CGFloat = 0.0
    var totalStars = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        context!.fill(rect)
        
        /// Get the dimensions of the stars to be drawn by dividing the width of the ratings view by the number of stars that need to be drawn and assigning it to `cellWidth`. If `cellWidth` is less than or equal to the ratings view's height, `starSide` is set to `cellWidth`; otherwise, it's set to be the same as ratings view's height.
        let availWidth = rect.size.width
        let cellWidth = availWidth / CGFloat(totalStars)
        let starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height
        
        
        for index in 0...totalStars {
            
            /// For the total number of stars, calculate the location and size of the rectangle where each star should be drawn inside the ratings view. The location values are offset from the top-left corner of the ratings view, and the `width` and `height` are set to `starSide`.
            let value = cellWidth * CGFloat(index) + cellWidth / 2
            let center = CGPoint(x: value + 1, y: rect.size.height / 2)
            let frame = CGRect(x: center.x - starSide / 2, y: center.y - starSide / 2, width: starSide, height: starSide)
            
            /// Depending on the value of the ratings view's `rating` property, determine whether the star is filled, half-filled, or empty.
            let highlighted = (Float(index + 1) <= ceilf(Float(self.rating)))
            if highlighted && (CGFloat(index + 1) > CGFloat(self.rating)) {
                drawHalfStar(with: frame)
            } else {
                drawStar(with: frame, highlighted: highlighted)
            }
        }
    }
}

private extension RatingsView {
    func drawStar(with frame: CGRect, highlighted: Bool) {
        let image = highlighted ? imgFilledStar: imgEmptyStar
        draw(with: image, and: frame)
    }
    
    func drawHalfStar(with frame: CGRect) {
        draw(with: imgHalfStar, and: frame)
    }
    
    func draw(with image: UIImage, and frame: CGRect) {
        image.draw(in: frame)
    }
}
