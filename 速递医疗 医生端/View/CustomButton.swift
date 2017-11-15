//
//  CustomButton.swift
//
//


import UIKit

@IBDesignable class CustomButton: UIButton {
    
    
    init(frame: CGRect, imageFrame:CGRect, labelFrame:CGRect) {
        super.init(frame:frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        self.setBackgroundImage(ImageUtil.color2img(color: UIColor.APPGrey), for: .disabled)
    }
    
    

}
