//
//  BaseCollectionView.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
@IBDesignable
class BaseCollectionView: UICollectionView {
    
    @IBInspectable var nibName:String = "MineOrderCollectionViewCell" {
        didSet{
            setUPView()
        }
    }
    @IBInspectable var height:Int = 150 {
        didSet {
            setUPView()
        }
    }
    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUPView()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    private func setUPView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: Int(SCREEN_WIDTH - 20), height: height)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        self.collectionViewLayout = flowLayout
        self.backgroundColor = UIColor.white
        self.register(UINib.init(nibName: self.nibName, bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
}
