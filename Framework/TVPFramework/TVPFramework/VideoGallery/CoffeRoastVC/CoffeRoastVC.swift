

import UIKit

//MARK: - UITable Cell
class cellCofee: MTTableCell {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var imgVideo: UIImageView!
    @IBOutlet var lblVideoDetail: MTLabel!
    @IBOutlet var imgPlay: UIImageView!
}

public class CoffeRoastVC: MTViewController, UITableViewDelegate, UITableViewDataSource, DropDownViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var viewTableHeader: UIView!
    @IBOutlet var imgViewTableHeader: UIImageView!
    @IBOutlet var lblCoffeeRoast: MTLabel!
    @IBOutlet var lblVideoCount: MTLabel!
    @IBOutlet var lblSubscribeToChannel: MTLabel!
    @IBOutlet var viewProductCategory: UIView!
    @IBOutlet var lblProductCategory: MTLabel!
    @IBOutlet var viewTypeOfVideo: UIView!
    @IBOutlet var lblTypeOfVideo: MTLabel!
    @IBOutlet var tblCoffee: UITableView!
    @IBOutlet var viewTableFooter: UIView!
    @IBOutlet var imgEnvope: UIImageView!
    @IBOutlet var imgProductOption: UIImageView!
    @IBOutlet var imgVideoOption: UIImageView!
    @IBOutlet var btnReset: UIButton!
    
    @IBOutlet var viewReset: UIView!
    @IBOutlet var btnTypeOFVideo: UIControl!
    @IBOutlet var btnProductCategory: UIControl!
    @IBOutlet var constraintWidthBackButton: NSLayoutConstraint!
    
    @IBOutlet var lblLoadMore: UILabel!
    @IBOutlet var lblCopyRights: UILabel!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var imgTitle: UIImageView!
    @IBOutlet var imgMenu: UIImageView!
    @IBOutlet var imgSearch: UIImageView!
    @IBOutlet var imgShop: UIImageView!
    
    var isChannelVideoListAPICalling = false
    
    //Variables
    var DictChannelData = NSDictionary()
    var arrData = NSMutableArray()
    var arrTempData = NSMutableArray()
    var arrFilters = NSMutableArray()
    var arrFiltersProductType = NSMutableArray()
    var arrFiltersTypeOfVideo = NSMutableArray()
    var isFiltershow: Bool = false
    var varConstTableHight = NSLayoutConstraint()
    var dropDownView = DropDownView()
    var dataVideoLoadingPageNo = 0
    
    var TVPView:TVPagePlayerView = TVPagePlayerView()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tblCoffee.tableHeaderView = self.viewTableHeader
        self.viewProductCategory.layer.cornerRadius = 5.0
        self.viewTypeOfVideo.layer.cornerRadius = 5.0
        
        arrData = NSMutableArray.init()
        arrTempData = NSMutableArray.init()
        self.lblVideoCount.text = ""
        
        lblCoffeeRoast.text = NSString.init(format: "%@", DictChannelData.value(forKey:"title") as! CVarArg).uppercased
        
        arrFilters = ["Coffee",
                      "Beans",
                      "Vieos"]
        arrFiltersProductType = ["Product Category"];
        arrFiltersTypeOfVideo = ["Youtube",
                                 "Vimeo",
                                 "Mp4"
        ];
        
        self.getChannelVideoList()
        initialization()
        setFonts()
        setImages()
        
        //Change statusbar color
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    override public func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    override public func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.tblCoffee.reloadData()
    }
    override public func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        //self.tblCoffee.reloadData()
    }
    
    //MARK: - Initialization
    func initialization(){
        //Install font
        installFont("Dosis-Regular")
        installFont("DosisBold")
        installFont("DosisBook")
        installFont("DosisExtraBold")
        installFont("DosisExtraLight")
        installFont("DosisLight")
        installFont("DosisMedium")
        installFont("DosisSemiBold")
        
    }
    
    //MARK: - Set Fonts
    func setFonts(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            self.lblCoffeeRoast.font = UIFont(name: "Dosis-Regular", size: 37.0)
            self.lblVideoCount.font = UIFont(name: "Dosis-Regular", size: 17.0)
            self.lblSubscribeToChannel.font = UIFont(name: "Dosis-Regular", size: 17.0)
            self.btnReset.titleLabel?.font = UIFont(name: "Dosis-Regular", size: 17.0)
            
            self.lblLoadMore.font = UIFont(name: "Dosis-SemiBold", size: 23.0)
            self.lblCopyRights.font = UIFont(name: "Dosis-Regular", size: 14.0)
        }
    }
    func setImages(){
        imgViewTableHeader.image = TVPView.getIconimage(iconname: "BgHeaderCofeeRosting")
        imgEnvope.image = TVPView.getIconimage(iconname: "Envelope")
        imgProductOption.image = TVPView.getIconimage(iconname: "TriangleDown")
        imgVideoOption.image = TVPView.getIconimage(iconname: "TriangleDown")
        imgBack.image = TVPView.getIconimage(iconname: "leftArrow")
        imgMenu.image = TVPView.getIconimage(iconname: "imgMenuMaterial")
        imgTitle.image = TVPView.getIconimage(iconname: "imgHeaderLogo")
        imgSearch.image = TVPView.getIconimage(iconname: "imgHeaderSearch")
        imgShop.image = TVPView.getIconimage(iconname: "imgHeaderShop")
    }
    //MARK: - Font Install
    @discardableResult
    func installFont(_ font:String) -> Bool {
        
        let  bundle = Bundle(url: Bundle.main.url(forResource: "TVPResources", withExtension: "bundle")!)
        guard let fontUrl = bundle?.url(forResource: font, withExtension: "ttf") else {
            return false
        }
        
        let fontData = try! Data(contentsOf: fontUrl)
        
        if let provider = CGDataProvider.init(data: fontData as CFData) {
            
            var error: Unmanaged<CFError>?
            
            let font:CGFont = CGFont(provider)!
            if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                print(error.debugDescription)
                return false
            } else {
                return true
            }
        }
        return false
    }
    @IBAction func tappedOnBack(_ sender: Any) {
        
        //SNavigataionVC.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMenuTap(_ sender: Any) {
        
        //SMainRootVC.showLeftView(animated: true, completionHandler: nil)
    }
    @IBAction func btnLogoTap(_ sender: Any) {
        
    }
    @IBAction func btnSubcribeToChannelTap(_ sender: Any) {
        
    }
    @IBAction func btnResetTap(_ sender: Any) {
        
    }
    @IBAction func btnProductCategoryTap(_ sender: Any) {
        
        if isFiltershow {
            
            isFiltershow = false
            dropDownView.closeAnimation()
            
        } else {
            
            isFiltershow = true
            dropDownView = DropDownView.init(arrayData: arrFiltersProductType as [AnyObject] , cellHeight: 35, heightTableView: (CGFloat(arrFiltersProductType.count * 35)), paddingTop: self.viewReset.frame.origin.y + btnProductCategory.frame.minY + btnProductCategory.frame.size.height + 1, paddingLeft: btnTypeOFVideo.frame.minX, paddingRight: self.btnTypeOFVideo.frame.size.width, refView: view, animation: BOTH, openAnimationDuration: 0.1, closeAnimationDuration: 0.1)
            
            dropDownView.delegate = self
            self.tblCoffee.addSubview(dropDownView.view)
            dropDownView.openAnimation()
            
        }
    }
    @IBAction func btnTypeOFVideoTap(_ sender: Any) {
        
        if isFiltershow {
            
            isFiltershow = false
            dropDownView.closeAnimation()
            
        } else {
            
            isFiltershow = true
            dropDownView = DropDownView.init(arrayData: arrFiltersTypeOfVideo as [AnyObject] , cellHeight: 35, heightTableView: (CGFloat(arrFiltersTypeOfVideo.count * 35)), paddingTop: self.viewReset.frame.origin.y + btnTypeOFVideo.frame.minY + btnTypeOFVideo.frame.size.height + 1, paddingLeft: btnTypeOFVideo.frame.minX, paddingRight: self.btnTypeOFVideo.frame.size.width, refView: view, animation: BOTH, openAnimationDuration: 0.1, closeAnimationDuration: 0.1)
            
            dropDownView.delegate = self
            self.tblCoffee.addSubview(dropDownView.view)
            dropDownView.openAnimation()
        }
    }
    @IBAction func btnLoadMoreTap(_ sender: Any){
        
        self.getChannelVideoList()
    }
// MARK: - ScrollView View Delegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isFiltershow = false
        dropDownView.closeAnimation()
    }
//MARK: - DropDown Delegate Method
    public func dropDownCellSelected(_ returnIndex: Int) {
        
        isFiltershow = false
        dropDownView.closeAnimation()
    }
// MARK: - UITableView Delegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let frameworkBundle = Bundle(identifier: "com.test.TVPFramework")
        let storyboard = UIStoryboard(name: "VideoGallery", bundle: frameworkBundle)
        let initVC = storyboard.instantiateViewController(withIdentifier: "videoPlaybackVC") as! videoPlaybackVC
        initVC.dictVideoData = arrData[indexPath.row] as! NSDictionary
        initVC.btnBackWidthConst = (Int(DeviceScale.x * 44.0))
        initVC.strChannelID = (DictChannelData.value(forKey:"id")! as? String)!
        initVC.isVideoListOpen = true
        initVC.arrVideoList = self.arrData.mutableCopy() as! NSMutableArray
        initVC.dataVideoLoadingPageNo = dataVideoLoadingPageNo
        self.navigationController?.pushViewController(initVC, animated: true)
        //SNavigataionVC.pushViewController(initVC, animated:true)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tblCoffee {
            
            return arrData.count
            
        } else {
            
            return 0
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCofee", for: indexPath) as! cellCofee
        
        if arrData.count > indexPath.row {
            
            let dic = arrData[indexPath.row] as! NSDictionary
            cell.lblVideoDetail.text = dic.object(forKey: "title") as? String
            let dict_asset = dic.value(forKey:"asset") as! NSDictionary
            //var url_string = dict_asset.value(forKey:"thumbnailUrl") as! String
            var url_string:String = dict_asset.getString(key: "thumbnailUrl")
            if !url_string.hasPrefix("http"){
                url_string = "http:" + url_string
            }
            let url =  URL(string:url_string)
            
            //cell.imgVideo.sd_setImage(with: url, placeholderImage:TVPView.getIconimage(iconname: "placeholder"))
            
            
            //let url =  URL(string:url_string)
            cell.imgVideo.image = TVPView.getIconimage(iconname: "placeholder")
            
            cell.imgVideo.image?.loadFromURL(url: url! as NSURL, callback: { (image) in                        cell.imgVideo.image = image
            })
            
            cell.imgPlay.image = TVPView.getIconimage(iconname: "imgPlay")
            //Set Cell Fonts
            cell.lblVideoDetail.font = UIFont(name: "Dosis-Regular", size: 14.0)
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    //MARK: - Get Channel Video List
    func getChannelVideoList() {
        
        if isChannelVideoListAPICalling == false {
            
            isChannelVideoListAPICalling = true
            
            if self.arrData.count == 0 {
            
                showHud()
            }
            
            print("dataVideoLoadingPageNo : \(dataVideoLoadingPageNo)")
            
            TvpApiClass.ChannelVideoList(strLoginID: Constants.loginID, strChhanelID: (DictChannelData.value(forKey:"id")! as? String)!, searchString: "", pageNumber: dataVideoLoadingPageNo, numberOfVideo: 5) { (arrChannelVideolist:NSArray,strerror:String) in
                
                self.isChannelVideoListAPICalling = false
                print(strerror)
                dismissHud()
                
                if strerror == "" {
                    
                    for videoData in arrChannelVideolist {
                        
                        self.arrData.add(videoData)
                    }
                    
                    if self.dataVideoLoadingPageNo == 0 && self.arrData.count != 0 {
                    
                        self.tblCoffee.tableFooterView = self.viewTableFooter
                    }
                    
                    if arrChannelVideolist.count != 0 {
                    
                        self.dataVideoLoadingPageNo += 1
                        
                        if self.arrData.count < 2 {
                        
                            self.lblVideoCount.text = "\(self.arrData.count) VIDEO"
                            
                        } else {
                        
                            self.lblVideoCount.text = "\(self.arrData.count) VIDEOS"
                        }
                        self.tblCoffee.reloadData()
                    }
                } else {
                    
                    showToastMessage(message: strerror as NSString)
                }
            }
        }
    }
}
