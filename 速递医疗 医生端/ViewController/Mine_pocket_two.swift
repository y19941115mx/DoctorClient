//
//  Mine_pocket_two.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_pocket_two: BaseRefreshController<MineTradeBean>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MinePocketCollectionViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MinePocketCollectionViewCell", owner: nil, options: nil)?.last as? MinePocketCollectionViewCell
            
        }
        let bean = data[indexPath.row]
        cell?.updataView(bean: bean)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: SCREEN_WIDTH - 20, height: 200)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "MinePocketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        initRefresh(scrollView: collectionView, ApiMethod: .listtraderecord(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .listtraderecord(self.selectedPage)
        }, isTableView: false)
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }

    

}
