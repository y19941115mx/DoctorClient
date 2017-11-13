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
        let vc_home = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController()!
        vc_home.tabBarItem = UITabBarItem(title: "主页", image: #imageLiteral(resourceName: "index_home"), tag: 0)
        self.viewControllers = [vc_home]
    }

}
