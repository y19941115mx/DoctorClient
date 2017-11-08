//
//  BaseViewController.swift


import UIKit
import MJRefresh
import Moya
import SnapKit
import ObjectMapper


// 基本
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //设置导航栏颜色和字体
        navigationController?.navigationBar.barTintColor = UIColor.APPColor
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    func setUpNavTitle(title:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
    
}

// 多个输入框

class BaseTextViewController:BaseViewController, UITextFieldDelegate {
    var tv_source = [UITextField]()
    var updateBtnState: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initTextFieldDelegate(tv_source:[UITextField]) {
        self.tv_source = tv_source
        if tv_source.count != 0 {
            for textField in tv_source {
                textField.delegate = self
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if tv_source.count != 0 {
            for textField in tv_source {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBtnState()
    }
}



class SegmentedSlideViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 初始化分栏
    func setUpSlideSwitch(titles:[String], vcs:[UIViewController])
    {
        let slideSwitch = XLSegmentedSlideSwitch(frame: CGRect(x: 0,  y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), titles: titles, viewControllers: vcs)
        slideSwitch?.tintColor = UIColor.APPColor
        slideSwitch?.show(in: self)
    }
    
    func setUpSlideSwitchWithNavigation(titles:[String], vcs:[UIViewController])
    {
        let slideSwitch = XLSegmentedSlideSwitch(frame: CGRect(x: 0,  y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), titles: titles, viewControllers: vcs)
        slideSwitch?.tintColor = UIColor.APPColor
        slideSwitch?.show(in: self)
    }
}

// 下拉刷新
class BaseRefreshController<T>:BaseViewController {
    var header:MJRefreshStateHeader?
    var footer:MJRefreshAutoStateFooter?
    var data = [T]()
    var scrollView:UIScrollView?
    var selectedPage = 1
    var refreshHandler:(_ jsonObj:Any)->Void = {_ in}
    var getMoreHandler:()->Void = {}
    var ApiMethod:API?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initRefresh(scrollView:UIScrollView, ApiMethod:API, refreshHandler:@escaping (_ jsonObj:Any)->Void, getMoreHandler:@escaping ()->Void) {
        self.ApiMethod = ApiMethod
        self.refreshHandler = refreshHandler
        self.getMoreHandler = getMoreHandler
        self.scrollView = scrollView
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true;
        self.scrollView?.mj_header = self.header
        self.footer = MJRefreshAutoNormalFooter(refreshingBlock: self.getMoreData)
        self.footer?.isRefreshingTitleHidden = true
        self.footer?.setTitle("", for: MJRefreshState.idle)
        self.scrollView?.mj_footer = self.footer
    }
    
    func initNoFooterRefresh(scrollView:UIScrollView, ApiMethod:API, refreshHandler:@escaping (_ jsonObj:Any)->Void) {
        self.ApiMethod = ApiMethod
        self.refreshHandler = refreshHandler
        self.scrollView = scrollView
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true;
        self.scrollView?.mj_header = self.header
    }
    
    func showRefreshBtn() {
        self.scrollView?.isHidden = true
        let button = UIButton()
        //label
        button.setTitle("无内容，点击刷新", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(refreshBtn(button:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
    }
    
    func refreshData(){
        self.selectedPage = 1
        //刷新数据
        let Provider = MoyaProvider<API>()
        
        Provider.request(ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    self.header?.endRefreshing()
                    let jsonObj = try response.mapJSON()
                    self.refreshHandler(jsonObj)
                }catch {
                    showToast(self.view,CATCHMSG)
                }
            case let .failure(error):
                self.header?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
        
    }
    
    private func getMoreData(){
        //获取更多数据
        getMoreHandler()
    }
    
    
    @objc func refreshBtn(button:UIButton) {
        // 点击刷新
        self.scrollView?.isHidden = false
        button.removeFromSuperview()
        self.header?.beginRefreshing()
    }
    
    
}



