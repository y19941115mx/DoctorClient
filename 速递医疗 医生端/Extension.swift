//
//  UIcolorExtension.swift


import Foundation
import UIKit

extension UIColor {
    static let APPColor = UIColor(red:0.39, green:0.68, blue:0.99, alpha:1)
    static let LightSkyBlue = UIColor(red:0.5, green:0.85, blue:0.99, alpha:1)
    static let APPGrey = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
}

@IBDesignable
extension UIView{
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }set{
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        
    }
    @IBInspectable var borderColor:UIColor{
        get{
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set{
            layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }set{
            layer.borderWidth = newValue
        }
    }
}

