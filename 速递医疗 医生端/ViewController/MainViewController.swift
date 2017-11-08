//
//  MainViewController.swift


import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private Method
    
    func setUpTabBar(){
        // 设置tabBar
// 设置图标切换颜色
        
//        let vc_home = HomeViewController()
//        vc_home.tabBarItem = UITabBarItem(title: "主页", image: #imageLiteral(resourceName: "home"), tag: 0)
//        let nav_home = UINavigationController(rootViewController: vc_home)
//        self.addChildViewController(nav_home)
//
//        let vc_business = BusinessViewController()
//        vc_business.tabBarItem = UITabBarItem(title: "商户", image: #imageLiteral(resourceName: "business"), tag: 0)
//        let nav_business = UINavigationController(rootViewController: vc_business)
//        self.addChildViewController(nav_business)
//
//        let vc_user = UserViewController()
//        vc_user.tabBarItem = UITabBarItem(title: "用户", image: #imageLiteral(resourceName: "mine"), tag: 0)
//        let nav_user = UINavigationController(rootViewController: vc_user)
//        self.addChildViewController(nav_user)
        
        
    }

}
