//
//  ChatViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/2.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import EaseUILite

class ChatViewController: EaseMessageViewController, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.showRefreshHeader = true
    }
    
    func messageViewController(_ viewController: EaseMessageViewController!, modelFor message: EMMessage!) -> IMessageModel! {
        //用户可以根据自己的用户体系，根据message设置用户昵称和头像
        let model:IMessageModel = EaseMessageModel.init(message: message)
        model.avatarImage = #imageLiteral(resourceName: "photo_loading")
        if model.nickname == user_default.account.getStringValue() {
            model.avatarURLPath = user_default.pix.getStringValue()
            model.nickname = ""
            return model
        }
        let user = UserInfo.searchUser(user_id: model.nickname)
        if user != nil {
            model.avatarURLPath = user!.user_photo
            model.nickname = user!.nick_name
        }
        return model
    }
    
    
    func setUpNavTitle(title:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
}

class ConversationListViewController: EaseConversationListViewController,EaseConversationListViewControllerDataSource,EaseConversationListViewControllerDelegate {
    
    //
    func conversationListViewController(_ conversationListViewController: EaseConversationListViewController!, didSelect conversationModel: IConversationModel!) {
        //
        let viewController = ChatViewController.init(conversationChatter: conversationModel.conversation.conversationId, conversationType: EMConversationTypeChat)
        viewController?.setUpNavTitle(title: conversationModel.title)
        viewController?.hidesBottomBarWhenPushed = true
        conversationListViewController.navigationController?.pushViewController(viewController!, animated: false)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.showRefreshHeader = true
        self.dataSource = self
        self.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //首次进入加载数据
        self.tableViewDidTriggerHeaderRefresh()
    }
    
    // 自定义
    func conversationListViewController(_ conversationListViewController: EaseConversationListViewController!, modelFor conversation: EMConversation!) -> IConversationModel! {
        
        
        let model:EaseConversationModel = EaseConversationModel.init(conversation: conversation)
        let user = UserInfo.searchUser(user_id: model.conversation.conversationId)
        if user != nil {
            model.avatarURLPath = user!.user_photo
            model.title = user!.nick_name
        }
        model.avatarImage = #imageLiteral(resourceName: "photo_loading")
        return model
    }
    
    
    func setUpNavTitle(title:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
}

