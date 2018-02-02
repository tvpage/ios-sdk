//
//  VideoGalleryVC.swift
//  TVPage Player
//
//  Created by Dilip manek on 10/04/17.
//
//

import UIKit

class cellCollectVideo504: MTCollectionCell {
    
    @IBOutlet var imgName: UIImageView!
    @IBOutlet var lblTitle: MTLabel!
    @IBOutlet var imgPlay: UIImageView!
}
class cellCollectBrand: MTCollectionCell {
    
    @IBOutlet var imgName: UIImageView!
}

class cellTblChennelHome: MTTableCell {
    
    @IBOutlet var imgName: UIImageView!
    @IBOutlet var lblName: MTLabel!
}

public class VideoGalleryVC: MTViewController ,  UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var ctrlsideMenu: UIControl!
    @IBOutlet var imgsideMenu: UIImageView!
    @IBOutlet var imgTitle: UIImageView!
    @IBOutlet var imgSearch: UIImageView!
    @IBOutlet var imgShop: UIImageView!
    
    @IBOutlet var VideoHeightConst: NSLayoutConstraint!
    @IBOutlet var collectvideolist: UICollectionView!
    @IBOutlet var collectBrandlist: UICollectionView!
    @IBOutlet var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tblHome: UITableView!
    
    @IBOutlet var lblBrands: MTLabel!
    @IBOutlet var lblLatestVideos: MTLabel!
    @IBOutlet var lblLoadMore: UILabel!
    @IBOutlet var lblCopyRights: UILabel!
    
    var arryTbl = NSMutableArray()
    var arryBrand = NSMutableArray()
    var arryVideoList = NSMutableArray()
    var isChannelVideoListAPICalling = false
    
    var TVPView:TVPagePlayerView = TVPagePlayerView()
    
    var arrVideoList = NSMutableArray()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        arryBrand = ["brandLogo_NinjaCoffeeBar"]
        
        arryVideoList = arrVideoList.mutableCopy() as! NSMutableArray
        
        VideoHeightConst.constant = CGFloat((arryVideoList.count * 250))
        collectvideolist.reloadData()
        
        initialization()
        setFonts()
        setImages()
        
        serviceCall()
        
        
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            self.lblBrands.font = UIFont(name: "Dosis-Bold", size: 25.0)
            self.lblLatestVideos.font = UIFont(name: "Dosis-Bold", size: 25.0)
            self.lblLoadMore.font = UIFont(name: "Dosis-SemiBold", size: 23.0)
            self.lblCopyRights.font = UIFont(name: "Dosis-Regular", size: 14.0)
        }
    }
    func setImages(){
        imgsideMenu.image = TVPView.getIconimage(iconname: "imgMenuMaterial")
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
    func serviceCall() {
        
        showHud()
        
        TvpApiClass.ChannelList(loginID: Constants.loginID, pageNumber: "", Max: "", orderBy: "", Order_direction: "", searchString: "") { (arrChannellist:NSArray,strerror:String) in
            print(strerror)
            dismissHud()
            
            if strerror == "" {
                
                self.arryTbl = NSMutableArray(array: arrChannellist)
                self.tblHeightConstraint.constant = CGFloat(150*self.arryTbl.count)
                self.view.layoutIfNeeded()
                self.tblHome.reloadData()
                
            } else {
                
                showToastMessage(message: strerror as NSString)
                
            }
        }
    }
    //MARK: - Action Event
    @IBAction func sideMenuTap(_ sender: Any) {
        
        //SMainRootVC.showLeftView(animated: true, completionHandler: nil)
    }
    @IBAction func btnLoadMoreClicked(_ sender: Any) {
        
        self.getChannelVideoList()
        
    }
    //MARK: - Tableview Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arryTbl.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTblChennelHome", for: indexPath) as! cellTblChennelHome
        
        //Set Cell Fonts
        cell.lblName.font = UIFont(name: "Dosis-SemiBold", size: 20.0)
        
        let dictionorydata = self.arryTbl[indexPath.row] as! NSDictionary
        let dict_asset = dictionorydata.value(forKey:"settings") as! NSDictionary
        
        if (dict_asset.value(forKey:"canvasUrl") != nil) {
            
            let url_string = dict_asset.value(forKey:"canvasUrl") as! String
            let urlWithHttps = "https:\(url_string)"
            let url =  URL(string:urlWithHttps)!
            //cell.imgName.sd_setImage(with: url, placeholderImage: TVPView.getIconimage(iconname: "placeholder"))
            cell.imgName.image = TVPView.getIconimage(iconname: "placeholder")
            cell.imgName.image?.loadFromURL(url: url as NSURL, callback: { (image) in
                
                cell.imgName.image = image
            })
            
            
        } else {
            
            let url =  URL(string:"")
            //cell.imgName.sd_setImage(with: url, placeholderImage: TVPView.getIconimage(iconname: "placeholder"))
            cell.imgName.image = TVPView.getIconimage(iconname: "placeholder")
        }
        cell.lblName.text = dictionorydata.value(forKey:"title")! as? String
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let frameworkBundle = Bundle(identifier: "com.manektech.TVPFramework")
        let storyboard = UIStoryboard(name: "VideoGallery", bundle: frameworkBundle)
        let coffeRoast = storyboard.instantiateViewController(withIdentifier: "CoffeRoastVC") as! CoffeRoastVC
        coffeRoast.DictChannelData = self.arryTbl[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(coffeRoast, animated: true)
        //SNavigataionVC.pushViewController(vc, animated: true)
    }
    //MARK: - CollectionView Delegate
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 504 {
            
            return arryVideoList.count
            
        } else if collectionView.tag == 503 {
            
            return arryBrand.count
        }
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 504 {
            
            return CGSize(width: self.collectvideolist.frame.size.width, height: 250)
            
        } else if collectionView.tag == 503 {
            
            return CGSize(width: collectBrandlist.frame.size.width, height: collectBrandlist.frame.size.height)
            
        }
        return CGSize(width: 0, height: 0)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 504 {
            
            let cell503 = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectVideo504", for: indexPath) as! cellCollectVideo504
            //Set Cell Fonts
            cell503.lblTitle.font = UIFont(name: "Dosis-Regular", size: 14.0)
            let dictionorydata = arryVideoList[indexPath.row] as! NSDictionary
            let dict_asset = dictionorydata.value(forKey:"asset") as! NSDictionary
            //var url_string = dict_asset.value(forKey:"thumbnailUrl") as! String
            var url_string:String = dict_asset.getString(key: "thumbnailUrl")
            if !url_string.hasPrefix("http"){
                url_string = "http:" + url_string
            }
            let url =  URL(string:url_string)
            
            //cell503.imgName.sd_setImage(with: url, placeholderImage:TVPView.getIconimage(iconname: "placeholder"))
            
            cell503.imgName.image = TVPView.getIconimage(iconname: "placeholder")
            cell503.imgName.image?.loadFromURL(url: url! as NSURL, callback: { (image) in
                
                cell503.imgName.image = image
            })
            
            cell503.imgPlay.image = TVPView.getIconimage(iconname: "imgPlay")
            cell503.lblTitle.text = dictionorydata.value(forKey:"title") as? String
            return cell503
            
        } else if collectionView.tag == 503 {
            
            let cell503 = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectBrand", for: indexPath) as! cellCollectBrand
            cell503.imgName.image = TVPView.getIconimage(iconname: self.arryBrand.object(at: indexPath.row) as! String)
              
            return cell503
            
        }
        let cell = MTCollectionCell()
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 504 {
            
            let frameworkBundle = Bundle(identifier: "com.manektech.TVPFramework")
            let storyboard = UIStoryboard(name: "VideoGallery", bundle: frameworkBundle)
            let initVC = storyboard.instantiateViewController(withIdentifier: "videoPlaybackVC") as! videoPlaybackVC
            initVC.dictVideoData = arryVideoList[indexPath.row] as! NSDictionary
            initVC.btnBackWidthConst = (Int(DeviceScale.x * 44.0))
            initVC.isVideoListOpen = true
            initVC.strChannelID = Constants.channelID
            initVC.arrVideoList = arrVideoList.mutableCopy() as! NSMutableArray
            initVC.dataVideoLoadingPageNo = Constants.videoPageNumber
            self.navigationController?.pushViewController(initVC, animated: true)
            //SNavigataionVC.pushViewController(initVC, animated:true)
        }
    }
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - Get Channel Video List
    func getChannelVideoList() {
        
        if isChannelVideoListAPICalling == false {
            
            isChannelVideoListAPICalling = true
            
            if arrVideoList.count == 0 {
                
                showHud()
            }
            
            TvpApiClass.ChannelVideoList(strLoginID: Constants.loginID, strChhanelID:Constants.channelID, searchString: "", pageNumber: Constants.videoPageNumber,numberOfVideo: 5) { (arrChannelVideolist:NSArray,strerror:String) in
                
                print(strerror)
                self.isChannelVideoListAPICalling = false
                dismissHud()
                
                if strerror == "" {
                    
                    for videoData in arrChannelVideolist {
                        
                        self.arrVideoList.add(videoData)
                    }
                    
                    if arrChannelVideolist.count > 0 {
                        
                        Constants.videoPageNumber = Constants.videoPageNumber + 1
                    }
                    
                    self.arryVideoList = self.arrVideoList.mutableCopy() as! NSMutableArray
                    
                    self.VideoHeightConst.constant = CGFloat((self.arryVideoList.count * 250))
                    self.collectvideolist.reloadData()
                    
                } else {
                    
                    showToastMessage(message: strerror as NSString)
                }
            }
        }
    }
}
