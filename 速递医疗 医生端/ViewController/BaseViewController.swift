//
//  BaseViewController.swift


import UIKit
import MJRefresh
import Moya
import SnapKit
import ObjectMapper
import HJPhotoBrowser


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
    
    func initTextFieldDelegate(tv_source:[UITextField], updateBtnState:@escaping () -> Void) {
        self.updateBtnState = updateBtnState
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
        self.updateBtnState()
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
    
    func setUpSlideSwitchNoNavigation(titles:[String], vcs:[UIViewController])
    {
        let slideSwitch = XLSegmentedSlideSwitch(frame: CGRect(x: 0,  y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), titles: titles, viewControllers: vcs)
        slideSwitch?.tintColor = UIColor.APPColor
        slideSwitch?.show(in: self)
    }
}

// 下拉刷新
// 下拉刷新
class BaseRefreshController<T:Mappable>:BaseViewController {
    var header:MJRefreshStateHeader?
    var footer:MJRefreshFooter?
    var data = [T]()
    var scrollView:UIScrollView?
    var selectedPage = 1
    var getMoreHandler:()->Void = {} //动态改变 获取更多的API
    var refreshHandler:(()->Void)? // 动态改变 刷新数据的API
    var ApiMethod:API?
    var getMoreMethod:API?
    var isTableView:Bool = true
    var button:UIButton = {
        let button = UIButton()
        button.setTitle("数据为空，点击重新加载", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(BaseRefreshController.refreshBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "empty"))
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(BaseRefreshController.refreshBtn))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initRefresh(scrollView:UIScrollView, ApiMethod:API,refreshHandler:(()->Void)?,getMoreHandler:@escaping ()->Void, isTableView:Bool = true) {
        self.ApiMethod = ApiMethod
        self.isTableView = isTableView
        self.refreshHandler = refreshHandler
        self.getMoreHandler = getMoreHandler
        self.scrollView = scrollView
        // 下拉刷新
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        self.scrollView?.mj_header = self.header
        // 上拉加载
        self.footer = MJRefreshBackNormalFooter.init(refreshingBlock: self.getMoreData)
        self.scrollView?.mj_footer = self.footer
    }
    
    func initNoFooterRefresh(scrollView:UIScrollView, ApiMethod:API, isTableView:Bool) {
        self.isTableView = isTableView
        self.ApiMethod = ApiMethod
        self.scrollView = scrollView
        // 下拉刷新
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        self.scrollView?.mj_header = self.header
    }
    
    func showRefreshBtn() {
        self.scrollView?.isHidden = true
        self.button.isHidden = false
        self.imageView.isHidden = false
        self.view.addSubview(button)
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view).offset(-32)
            make.centerX.equalTo(self.view)
            make.height.equalTo(125)
            make.width.equalTo(100)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    func getData() {
        //刷新数据
        self.selectedPage = 1
        let Provider = MoyaProvider<API>()
        if self.refreshHandler != nil {
            self.refreshHandler!()
        }
        Provider.request(self.ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    self.header?.endRefreshing()
                    let bean = Mapper<BaseListBean<T>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.dataList == nil {
                            bean?.dataList = [T]()
                        }
                        self.data = (bean?.dataList)!
                        if self.data.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                        }
                        if self.isTableView {
                            let tableView = self.scrollView as! UITableView
                            tableView.reloadData()
                        }else {
                            let collectionView = self.scrollView as! UICollectionView
                            collectionView.reloadData()
                        }
                        
                    }else {
                        showToast(self.view, (bean?.msg!)!)
                    }
                    
                }catch {
                    //隐藏tableView,添加刷新按钮
                    if self.data.count == 0{
                        self.showRefreshBtn()
                    }
                    showToast(self.view,CATCHMSG)
                }
            case let .failure(error):
                self.header?.endRefreshing()
                if self.data.count == 0{
                    self.showRefreshBtn()
                }
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
    }
    
    
    func refreshData(){
        //刷新数据
        self.selectedPage = 1
        MapUtil.singleLocation(successHandler: { (loc, code) in
            self.getData()
        }, failHandler: {
            self.getData()
        })
    }
    
    func getMoreData(){
        self.selectedPage += 1
        //获取更多数据
        getMoreHandler()
        let Provider = MoyaProvider<API>()
        Provider.request(self.getMoreMethod!) { result in
            switch result {
            case let .success(response):
                self.footer?.endRefreshing()
                do {
                    let bean = Mapper<BaseListBean<T>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.dataList?.count == 0 || bean?.dataList == nil{
                            self.footer!.endRefreshingWithNoMoreData()
                            return
                        }
                        self.data += (bean?.dataList)!
                        
                        if self.isTableView {
                            let tableView = self.scrollView as! UITableView
                            tableView.reloadData()
                        }else {
                            let CollectionView = self.scrollView as! UICollectionView
                            CollectionView.reloadData()
                        }
                        
                    }else {
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.footer?.endRefreshing()
                    showToast(self.view, CATCHMSG)
                }
            case let .failure(error):
                self.footer?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
        
    }
    
    @objc func refreshBtn() {
        button.isHidden = true
        imageView.isHidden = true
        self.scrollView?.isHidden = false
        self.header?.beginRefreshing()
    }
    
}

// 信息填写
class BaseTableInfoViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var tableTiles = [[String]]()
    var tableInfo = [[String]]()
    var mTableView:UITableView?
    var clickHandler:((IndexPath)->Void)?
    var flags:([[Bool]])? = nil {
        didSet {
            self.mTableView?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTiles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableTiles.count == 0 {
            return 0
        }
        return tableTiles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? InfoTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("InfoTableViewCell", owner: nil, options: nil)?.last as? InfoTableViewCell
        }
        if let flags = flags {
            let redPointFlag = flags[indexPath.section][indexPath.row]
            cell?.titleLabel.isRedPoint = redPointFlag
        }

        cell?.titleLabel.text = tableTiles[indexPath.section][indexPath.row]
        cell?.infoLabel.text = tableInfo[indexPath.section][indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.clickHandler != nil {
            clickHandler!(indexPath)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initViewController(tableTiles: [[String]], tableInfo:[[String]],tableView:UITableView, clickHandler:((IndexPath)->Void)?) {
        self.mTableView = tableView
        self.tableInfo = tableInfo
        self.tableTiles = tableTiles
        self.clickHandler = clickHandler
        self.mTableView?.dataSource = self
        self.mTableView?.delegate = self
    }
}

class  BasicCollectionViewBrowserController:BaseViewController, UICollectionViewDelegate, HJPhotoBrowserDelegate {
    
    var picArray = [String]()
    
//    var mCollectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
//    public func initViewController(mCollectionView:UICollectionView) {
//        mCollectionView.delegate = self
//    }
    
    func photoBrowser(_ browser: HJPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL.init(string: picArray[index])
    }
    
    func photoBrowser(_ browser: HJPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return #imageLiteral(resourceName: "photo_default")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = picArray.count;
        let browser = HJPhotoBrowser()
        browser.sourceImagesContainerView = collectionView
        browser.imageCount = count
        browser.currentImageIndex = indexPath.row;
        browser.delegate = self
        browser.show()
    }
    
}
class BasePickImgViewController:BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var handler:((UIImage) -> Void)?
    
    // MARK: - pickImage
    
    func updatePicture() {
        AlertUtil.popMenu(vc: self, title: "请选择", msg: "", btns: ["从图库选择", "拍照"]) { (str) in
            if str == "拍照" {
                self.pickImage(1)
            }else {
                self.pickImage(0)
            }
        }
    }
    
    func pickImage(_ type: Int) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        if type == 0{
            imagePickerController.sourceType = .photoLibrary
        }else {
            imagePickerController.sourceType = .camera
        }
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if handler != nil {
            self.handler!(selectedImage)
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


