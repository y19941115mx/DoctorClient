//
//  HomeMainTableViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/4.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class HomeMainTableViewCell: UITableViewCell {
    
    var sickBean:SickBean?
    var vc:UIViewController = UIViewController()
    
    @IBOutlet weak var pixImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func updateViews(result:SickBean, vc:UIViewController) {
        self.vc = vc
        self.sickBean = result
        nameLabel.text = result.familyname
        sexLabel.text = result.familymale
        if result.usersickptime == nil {
            timeLabel.text = ""
        }else {
            timeLabel.text = StringUTil.getComparedTimeStr(str: result.usersickptime!)
        }
        detailLabel.text = result.usersickdesc
        ImageUtil.setAvator(path: result.userloginpix!, imageView: pixImageView)
    }
    
    @IBAction func BeginChat(_ sender: Any) {
        let viewController = ChatViewController.init(conversationChatter: sickBean?.userhuanxinaccount, conversationType: EMConversationTypeChat)
        viewController?.setUpNavTitle(title: (sickBean?.familyname)!)
        viewController?.hidesBottomBarWhenPushed = true
        self.vc.navigationController?.pushViewController(viewController!, animated: false)
    }
    
    
}
