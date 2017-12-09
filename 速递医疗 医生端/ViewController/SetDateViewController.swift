//
//  SetDateViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class SetDateViewController: BaseRefreshController<MineCalendarBean>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SetDateCollectionViewCell
        cell.updateView(data: data[indexPath.row], vc: self)
        return cell
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRefresh(scrollView: collectionView, ApiMethod: .getcalendar(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.getcalendar(self.selectedPage)
        }, isTableView: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.header?.beginRefreshing()
    }
    
    @IBAction func ButtonAcion(_ sender: UIButton) {
        if sender.tag == 666 {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH - 20, height: 150)
    }
    
    
}
