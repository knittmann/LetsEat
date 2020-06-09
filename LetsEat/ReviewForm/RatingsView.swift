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
    
    /// Allow RatingsView to become first responder in order to respond to touch events.
    override var canBecomeFirstResponder: Bool {
        return shouldBecomeFirstResponder
    }
    
    /// This method is called when the user touches any part of the ratings view on the screen. This is known as a touch event. First, it checks to see if the `isEnabled` property is `true`. If it is, the superclass implementation is called. After that, the ratings view on the screen is set to be the first responder, so it will capture touch events when it is touched and the `handle(with:)` method will be executed for every touch event.
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if self.isEnabled {
            super.beginTracking(touch, with: event)
            
            if (shouldBecomeFirstResponder && self.isFirstResponder) {
                becomeFirstResponder()
            }
            
            handle(with: touch)
            return true
        } else {
            return false
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
    
    /// Takes a touch event as a parameter. First, `cellWidth` is assigned the ratings view's width, divided by the totalStars. Next, the touch event's location within the ratings view is assigned to `location`. Then, `value` is assigned the `x` position of `location`, divided by `cellWidth`. The if statement calculates the rating corresponding to the position of the touch and calls `updateRating(with:)`, passing it the value.
    func handle(with touch: UITouch) {
        let cellWidth = self.bounds.size.width / CGFloat(totalStars)
        let location = touch.location(in: self)
        var value = location.x / cellWidth
        
        if (value + 0.5 < CGFloat(ceilf(Float(value)))) {
            value = floor(value) + 0.5
        } else {
            value = CGFloat(ceilf(Float(value)))
        }
        updateRating(with: value)
    }
    
    /// Check to see if `value` is not equal to the current `rating` and between 0 and 5. If it is, `value` is assigned to `rating`, and the screen is redrawn.
    func updateRating(with value: CGFloat) {
        if (self.rating != value && value >= 0 && value <= CGFloat(totalStars)) {
            self.rating = value
            setNeedsDisplay()
        }
    }
}
