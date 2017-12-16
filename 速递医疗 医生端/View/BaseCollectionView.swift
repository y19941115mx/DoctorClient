//
//  BaseCollectionView.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import HJPhotoBrowser
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


class BasePhotoCollectionView: UICollectionView,UICollectionViewDelegate,HJPhotoBrowserDelegate {
    
    func photoBrowser(_ browser: HJPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL.init(string: picArray[index])
    }
    
    func photoBrowser(_ browser: HJPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return #imageLiteral(resourceName: "photo_error")
    }
    
    var picArray = [String]()
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = picArray.count;
        let browser = HJPhotoBrowser()
        browser.sourceImagesContainerView = self
        browser.imageCount = count
        browser.currentImageIndex = indexPath.row;
        browser.delegate = self
        browser.show()
    }
    
}
