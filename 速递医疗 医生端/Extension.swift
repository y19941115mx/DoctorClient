//
//  UIcolorExtension.swift


import Foundation
import UIKit
//UIColor colorWithRed:50/255.0 green:195/255.0 blue:170/255.0 alpha:1.0
extension UIColor {
    static let APPColor = UIColor(red: 50/255, green: 195/255.0, blue: 170/255.0, alpha: 1.0)
    static let LightSkyBlue = UIColor(red:0.5, green:0.85, blue:0.99, alpha:1)
    static let APPGrey = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
}


extension UIView{
     var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }set{
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        
    }
     var borderColor:UIColor{
        get{
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set{
            layer.borderColor = newValue.cgColor
        }
    }
     var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }set{
            layer.borderWidth = newValue
        }
    }
}
