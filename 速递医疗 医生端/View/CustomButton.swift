//
//  CustomButton.swift
//
//


import UIKit

class CustomButton: UIButton {
    var imageRect:CGRect?
    var labelRect:CGRect?
    
    init(frame: CGRect, imageFrame:CGRect, labelFrame:CGRect) {
        super.init(frame:frame)
        imageRect = imageFrame
        labelRect = labelFrame
        self.imageView?.contentMode = .scaleAspectFill
        self.titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return labelRect!
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return imageRect!
    }

}
