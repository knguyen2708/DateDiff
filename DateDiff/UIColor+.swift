//
//  UIColor+.swift
//  BCG_Test
//
//  Created by Khanh Nguyen on 20/04/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     Constructs a color instance with red/green/blue.
     */
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /**
     Constructs a color instance with its hex code.
     */
    public convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1)
    }
    
    /**
     Constructs a color instance with its hex code and alpha.
     */
    public convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex >> 16) & 0xff) / 255.0
        let g = CGFloat((hex >> 8) & 0xff) / 255.0
        let b = CGFloat(hex & 0xff) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIColor {
    /**
     Constructs a color by darkening the receiver.
     */
    public func colorByDarkening(amount: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(
                hue: h,
                saturation: s,
                brightness: max(b - b * amount, 0),
                alpha: a
            )
        } else {
            fatalError()
        }
    }
    
    /**
     Constructs a color by lightening the receiver.
     */
    public func colorByLightening(amount: CGFloat) -> UIColor {
        return colorByDarkening(-amount)
    }
}
