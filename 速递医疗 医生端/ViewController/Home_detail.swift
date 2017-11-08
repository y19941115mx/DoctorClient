////
////  PatientDetailViewController.swift
////  DoctorClient
////
////  Created by admin on 2017/8/31.
////  Copyright © 2017年 victor. All rights reserved.
////
//
//import UIKit
//
//class PatientDetailViewController: BaseViewController, UICollectionViewDataSource{
//    var patientBean:PatientMsgBean?
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    
//    @IBOutlet weak var patientName: UILabel!
//    
//    @IBOutlet weak var timeLabel: UILabel!
//    
//    @IBOutlet weak var describeLabel: UILabel!
//    
//    @IBOutlet weak var imageLayout: UICollectionView!
//    
//    var images = ["http://192.168.2.2:8080/picture/1.jpg",
//                  "http://192.168.2.2:8080/picture/2.jpg",
//                  "http://192.168.2.2:8080/picture/3.jpg",
//                  "http://192.168.2.2:8080/picture/1.jpg",
//                  "http://192.168.2.2:8080/picture/1.jpg",
//                  "http://192.168.2.2:8080/picture/1.jpg",
//                  "http://192.168.2.2:8080/picture/1.jpg"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imageLayout.dataSource = self
//        if let patient = patientBean{
//            titleLabel.text = patient.desc
//            timeLabel.text =  patient.time
//            patientName.text = patient.name
//            describeLabel.text = "病情描述： " + patient.desc
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        return images.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//        let cellIdentifilter = "reusedCell"
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifilter, for: indexPath)
//        let imageView = cell.viewWithTag(1) as! UIImageView
//        ImageUtil.setImage(path: images[indexPath.row], imageView: imageView)
//        
//        return cell
//    }
//    
//
//}

