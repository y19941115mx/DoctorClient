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




class Mine_balance: BaseRefreshController<MineBlanceBean>, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: BaseTableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let bean = data[indexPath.row]
        cell.selectionStyle = .none
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        let signLabel = cell.viewWithTag(3) as! UILabel
        let accountLabel = cell.viewWithTag(4) as! UILabel
        nameLabel.text = bean.pursetypename
        timeLabel.text = bean.docpursetime
        if bean.docpursetypeid == 0 {
            signLabel.text = "-"
        }
        accountLabel.text = "\(bean.docpurseamount!)"
        //
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        initRefresh(scrollView: tableView, ApiMethod: API.listbalancerecord(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .listtraderecord(self.selectedPage)
        })
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }
}
