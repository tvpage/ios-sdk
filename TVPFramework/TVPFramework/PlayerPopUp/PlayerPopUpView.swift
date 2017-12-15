//
//  PlayerPopUpView.swift
//  TVPagePhase2
//


import UIKit
//import TVP
import SafariServices
class PlayerPopUpView: UIView {
    
    //MARK: - IBOutlet Declaration
    
    @IBOutlet var lblHeaderTitle: UILabel!
    @IBOutlet var imgBtnClose: UIImageView!
    @IBOutlet var btnClose: UIControl!
    @IBOutlet var viewPlayer: UIView!
    @IBOutlet var cvProductList: UICollectionView!
    
    //MARK: - Variable Declaration
    var cellWidth = 0.0
    var cellHeight = 0.0
    
    var isSetPlayerData:Bool = false
    var viewTVP:TVPagePlayerView!
    var playerData = ModelVideoList(dictJSON: NSDictionary())
    
    //Get Products On Video API Calling
    var isGetProductsOnVideoAPICalling = false
    var arrProductsOnVideo = [ModelProductsOnVideo]()
    
    //For Closure
    var handler : ((Int)->())?
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)

        //Initialization
        self.initialization()
    }
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        //Load View From Nib
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nibPlayerPopUpView = UINib(nibName: "PlayerPopUpView", bundle: bundle)
        let viewPlayerPopUpView = nibPlayerPopUpView.instantiate(withOwner: self, options: nil)[0] as! UIView
        viewPlayerPopUpView.frame = bounds
        viewPlayerPopUpView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewPlayerPopUpView);
        
    }
    //MARK: - Set Player Data
    func setPlayerData(playerData:ModelVideoList) {
        
        //Set player data
        self.playerData = playerData
        
        let dictVideoDetails = playerData.dictJSON.mutableCopy() as! [String:Any]
        viewTVP.getDATAandALLCheck(dict: dictVideoDetails)
        isSetPlayerData = true
        
        //Set header title
        lblHeaderTitle.text = self.playerData.title
        
        //Get Products On Video API Calling
        self.getProductsOnVideoAPICalling()
        
        //Remove All previous data
        self.arrProductsOnVideo.removeAll()
        cvProductList.reloadData()
    }
    func showPlayer(complete : ((Int)->())?) {
     
        handler = complete
    }
    //MARK: - Stop Player
    func stopPlayer() {
        
        if isSetPlayerData == true {
         
            isSetPlayerData = false
            
            //Stop player view
            viewTVP.pause()
        }
    }
    //MARK: - Initialization
    func initialization() {
        
        //Load View From Nib
        loadViewFromNib ()
        
        //Install font
        installFont("DosisBold")
        installFont("DosisBook")
        installFont("DosisExtraBold")
        installFont("DosisExtraLight")
        installFont("DosisLight")
        installFont("DosisMedium")
        installFont("DosisSemiBold")
        
        //Register Cell
        let cellIdentifier = "CellProduct"
        
        let bundle = Bundle(for: type(of: self))
        cvProductList.register(UINib(nibName:"CellProduct", bundle: bundle), forCellWithReuseIdentifier: cellIdentifier)
        //cvProductList.delegate = self
        //cvProductList.dataSource = self
        cvProductList.contentInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        cvProductList.register(VideoListFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        //Header View
        lblHeaderTitle.font = UIFont(name: "Dosis-Book", size: lblHeaderTitle.font.pointSize)
        
        //Cell Size
        cellWidth = (Double((cvProductList.frame.size.width - (26)) - 58.0))
        cellHeight = Double(cvProductList.frame.size.height)
        
        //Create Player View
        viewTVP = TVPagePlayerView.init(frame: CGRect(x: 50, y: 200, width: 350, height: 200))
        self.viewPlayer.addSubview(viewTVP)
        viewTVP.delegate = self
        viewTVP.show(frame: CGRect(x:0,y:0,width:self.viewPlayer.frame.size.width,height:self.viewPlayer.frame.size.height), view: self.viewPlayer)
        
        imgBtnClose.image = self.getIconImage(imageName: "imgPlayerClose")
    }
    //MARK: - Get Icon Image
    func getIconImage(imageName:String) -> UIImage {
        let  bundle = Bundle(url: Bundle.main.url(forResource: "TVPResources", withExtension: "bundle")!)
        let  imagePath: String? = bundle?.path(forResource: imageName, ofType: "png")
        let  image = UIImage(contentsOfFile: imagePath!)
        return image!
    }
    func getFontURL(fontName:String) -> String {
        let  bundle = Bundle(url: Bundle.main.url(forResource: "TVPResources", withExtension: "bundle")!)
        let  strURL: String? = bundle?.path(forResource: fontName, ofType: "ttf")
        return strURL!
    }
    //MARK: - Font Install
    @discardableResult
    func installFont(_ font:String) -> Bool {
        
        let data = NSData(contentsOfFile: getFontURL(fontName: font))
        
        let fontData = data! as Data
        
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
}
//MARK: - IBAction
extension PlayerPopUpView {
    
    //Close PopUp Event
    @IBAction func btnClosePressed(_ sender: Any) {
        
        if self.handler != nil {
            
            //O for close button
            self.handler!(0)
        }
    }
    @objc func btnShowDetailPressed(sender:UIControl){
        print("Btn Show detail pressed at index : \(sender.tag)")
        print("Open url : \(arrProductsOnVideo[sender.tag].linkUrl)")
        if arrProductsOnVideo[sender.tag].linkUrl.count > 0 {
            let safariVC = SFSafariViewController(url: NSURL(string: arrProductsOnVideo[sender.tag].linkUrl)! as URL)
            self.window?.rootViewController?.present(safariVC, animated: true, completion: nil)
        }
    }
}
//MARK: - UICollectionViewDelegate methods
extension PlayerPopUpView:UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("INDEX : ",indexPath.row)
        
    }
}
//MARK: - UICollectionViewDataSource methods
extension PlayerPopUpView:UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Products List
        return arrProductsOnVideo.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create Video Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellProduct", for: indexPath) as! CellProduct
        
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Video List
        if (cvProductList == collectionView) {
            
            //Video List Cell
            if let cellProduct = cell as? CellProduct {
                
                //Set Font
                cellProduct.viewContainer.layer.borderWidth = 0.5
                cellProduct.viewContainer.layer.borderColor = UIColor.black.cgColor
                cellProduct.lblTitle.font = UIFont(name: "Dosis-Book", size: cellProduct.lblTitle.font.pointSize)
                cellProduct.lblDetail.font = UIFont(name: "Dosis-Book", size: cellProduct.lblDetail.font.pointSize)
                cellProduct.lblRatings.font = UIFont(name: "Dosis-Book", size: cellProduct.lblRatings.font.pointSize)
                cellProduct.lblRate.font = UIFont(name: "Dosis-Bold", size: cellProduct.lblRate.font.pointSize)
                cellProduct.btnViewDetails.tag = indexPath.row
                cellProduct.btnViewDetails.addTarget(self, action: #selector(self.btnShowDetailPressed(sender:)), for: UIControlEvents.touchUpInside)
                cellProduct.lblViewDetails.font = UIFont(name: "Dosis-Bold", size: cellProduct.lblViewDetails.font.pointSize)
                
                //Set Data
                cellProduct.lblTitle.text = arrProductsOnVideo[indexPath.row].title
                cellProduct.lblRate.text = arrProductsOnVideo[indexPath.row].price
        
                //Product Image
                cellProduct.imgPlaceholder.image = self.getIconImage(imageName: "imgPlaceholder")
                cellProduct.imgPlaceholder.isHidden = false
                cellProduct.imgProducts.image = UIImage()
                cellProduct.imgProducts.isHidden = true
                
                if arrProductsOnVideo[indexPath.row].imageUrl.characters.count > 0 {
                    
                    let urlProduct = URL(string: arrProductsOnVideo[indexPath.row].imageUrl)
                    cellProduct.imgProducts.image?.loadFromURL(url: urlProduct! as NSURL, callback: { (image) in
                        cellProduct.imgPlaceholder.isHidden = true
                        cellProduct.imgProducts.isHidden = false
                        cellProduct.imgProducts.image = image
                    })
                }
                
                //Review
                cellProduct.viewRatings.starNormalColor = UIColor.white
                cellProduct.viewRatings.starFillColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0)
                cellProduct.viewRatings.starBorderColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0)
                cellProduct.viewRatings.starSize = 9.0
                cellProduct.viewRatings.padding = 5.0
                cellProduct.viewRatings.starFillMode = StarFillModeHorizontal
                cellProduct.viewRatings.rating = 2.5
            }
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout methods
extension PlayerPopUpView:UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Video List Cell Size
        return CGSize(width: cellWidth, height: cellHeight)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if arrProductsOnVideo.count == 0 {
            
            return CGSize.zero
        } else {
            
            return CGSize.zero
        }
    }
}
//MARK: - TVPlayerDelegate
extension PlayerPopUpView:TVPlayerDelegate {
    
    public func tvPlayerReady(flag: Bool) {
        
        print("tvPlayerReady")
    }
    
    public func tvPlayerError(error: Error) {
        
        print("tvPlayerError")
    }
    
    public func tvPlayerMediaReady(flag: Bool) {
        
        print("tvPlayerMediaReady")
    }
    
    public func tvPlayerMediaError(error: Error) {
        
        print("tvPlayerMediaError")
    }
    
    public func tvPlayerErrorForbidden(error: Error) {
        
        print("tvPlayerErrorForbidden")
    }
    
    public func tvPlayerErrorHTML5Forbidden(error: Error) {
        
        print("tvPlayerErrorHTML5Forbidden")
    }
    
    public func tvPlayerMediaComplete(flag: Bool) {
        
        print("tvPlayerMediaComplete")
    }
    
    public func tvPlayerCued(flag: Bool) {
        
        print("tvPlayerCued")
    }
    
    public func tvPlayerMediaVideoended(flag: Bool) {
        
        print("tvPlayerMediaVideoended")
    }
    
    public func tvPlayerMediaVideoplaying(flag: Bool) {
        
        print("tvPlayerMediaVideoplaying")
    }
    
    public func tvPlayerMediaVideopaused(flag: Bool) {
        
        print("tvPlayerMediaVideopaused")
    }
    
    public func tvPlayerMediaVideobuffering(flag: Bool) {
        
        print("tvPlayerMediaVideobuffering")
    }
    
    public func tvPlayerPlaybackQualityChange(flag: String) {
        
        print("tvPlayerPlaybackQualityChange")
    }
    
    public func tvPlayerMediaProviderChange(flag: String) {
        
        print("tvPlayerMediaProviderChange")
    }
    
    public func tvPlayerSeek(flag: String) {
        
        print("tvPlayerSeeks")
    }
    
    public func tvPlayerVideoLoad(flag: Bool) {
        
        print("tvPlayerVideoLoad")
    }
    
    public func tvPlayerVideoCued(flag: Bool) {
        
        print("tvPlayerVideoCued")
    }
}
//MARK: - API Calling
extension PlayerPopUpView {
    
    //Get Products On Video API Calling
    func getProductsOnVideoAPICalling() {
    
        if isGetProductsOnVideoAPICalling == false {
        
            isGetProductsOnVideoAPICalling = true
            
            let videoID = playerData.id
            TVPApiClass.getProductsOnVideo(loginID: Constants.loginID, videoID: videoID, completion: { (arrProductlist, strError) in
                
                print(strError)
                self.isGetProductsOnVideoAPICalling = false
                
                //Hide progress hud
                //appDelegateShared.dismissHud()
                
                if strError == "" {
                    
                    //Remove All Products On Video
                    self.arrProductsOnVideo.removeAll()
                    
                    //Set video data
                    for productData in arrProductlist {
                        
                        let dictProductData = productData as! NSDictionary
                        //print(dictProductData)
                        self.arrProductsOnVideo.append(ModelProductsOnVideo(dictJSON: dictProductData))
                    }
                    
                    //Reload video list
                    self.cvProductList.reloadData()
                    
                } else {
                    
                    //appDelegateShared.showToastMessage(message: strerror as NSString)
                }
                
            })
        }
    }
    
    
    
}
