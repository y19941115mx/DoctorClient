//
//  UIcolorExtension.swift


import Foundation
import UIKit
import SnapKit

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

@IBDesignable class RedPointImageView:UIImageView {
    var redPoint = UIView()
    @IBInspectable var isRedPoint:Bool = false {
        didSet {
            setup()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        redPoint.layer.cornerRadius = 3
        redPoint.backgroundColor = UIColor.red
        self.addSubview(redPoint)
        redPoint.snp.makeConstraints { (make) in
            make.height.equalTo(6)
            make.width.equalTo(6)
            make.right.equalTo(0)
            make.top.equalTo(0)
        }
    }
    

    private func setup() {
        if isRedPoint {
            redPoint.isHidden = false
        }else {
            redPoint.isHidden = true
        }
    }
}

@IBDesignable class RedPointLabel:UILabel {
    var redPoint = UIView()
    @IBInspectable var isRedPoint:Bool = false {
        didSet {
            setup()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        redPoint.layer.cornerRadius = 3
        redPoint.backgroundColor = UIColor.red
        let ract = self.text!.getTextRectSize(font: self.font, size: self.frame.size)
        self.addSubview(redPoint)
        redPoint.snp.makeConstraints { (make) in
            make.height.equalTo(6)
            make.width.equalTo(6)
            make.right.equalTo(self.frame.size.width -  ract.width)
            make.top.equalTo(0)
        }
    }
    
    
    private func setup() {
        if isRedPoint {
            redPoint.isHidden = false
        }else {
            redPoint.isHidden = true
        }
    }
}

extension String {
    // 动态获取字符串宽、高度
    func getTextRectSize(font:UIFont, size:CGSize) -> CGRect {
        // 传入字符串的字体、最大宽高，返回字符串实际占用的宽高(.width   .height)
        let attributes = [NSAttributedStringKey.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect
    }
    
    func getTextRectHeight(font:UIFont, width:CGFloat) -> CGFloat {
        // 传入字符串的字体、最大宽高，返回字符串实际占用的宽高(.width   .height)
        let attributes = [NSAttributedStringKey.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let textMaxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect:CGRect = self.boundingRect(with: textMaxSize, options: option, attributes: attributes, context: nil)
        return rect.height
    }
}

