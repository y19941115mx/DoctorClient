//
//  MainViewController.swift


import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        APPLICATION.tabBarController = self
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
        let vc_patient = UIStoryboard.init(name: "MyPatient", bundle: nil).instantiateInitialViewController()!
        vc_patient.tabBarItem = UITabBarItem.init(title: "我的病人", image: #imageLiteral(resourceName: "index_patient"), tag: 1)
        let vc_date = UIStoryboard.init(name: "Date", bundle: nil).instantiateInitialViewController()!
        vc_date.tabBarItem = UITabBarItem.init(title: "我的日程", image: #imageLiteral(resourceName: "index_dindan"), tag: 2)
        let vc_consultation = UIStoryboard.init(name: "Consultation", bundle: nil).instantiateInitialViewController()!
        vc_consultation.tabBarItem = UITabBarItem.init(title: "我的会诊", image: #imageLiteral(resourceName: "index_wdys_"), tag: 3)
        let vc_mine = UIStoryboard.init(name: "Mine", bundle: nil).instantiateInitialViewController()!
        vc_mine.tabBarItem = UITabBarItem.init(title: "我的", image: #imageLiteral(resourceName: "index_mine"), tag: 4)
        self.viewControllers = [vc_home,vc_patient,vc_date, vc_consultation,vc_mine]
    }

}
