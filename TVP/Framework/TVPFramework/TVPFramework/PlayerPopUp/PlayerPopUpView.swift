

import UIKit
import SafariServices
class PlayerPopUpView: UIView {
    
    //MARK: - IBOutlet Declaration
    
    @IBOutlet var lblHeaderTitle: UILabel!
    @IBOutlet var imgBtnClose: UIImageView!
    @IBOutlet var btnClose: UIControl!
    @IBOutlet var viewPlayer: UIView!
    @IBOutlet var cvProductList: UICollectionView!
    @IBOutlet var viewModal: UIView!
    @IBOutlet var modalPadding: [NSLayoutConstraint]!
    
    //MARK: - Variable Declaration
    var cellHeight = 0.0
    var isSetPlayerData:Bool = false
    var viewTVP:TVPagePlayerView!
    var playerData = ModelVideoList(dictJSON: NSDictionary())
    
    //Get Products On Video API Calling
    var isGetProductsOnVideoAPICalling = false
    var arrProductsOnVideo = [ModelProductsOnVideo]()
    
    //MARK: - Player View Property
    var modal_background:UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet {
            self.setProperties()
        }
    }
    var modal_border:CGFloat = CGFloat(0.0){
        didSet {
            self.setProperties()
        }
    }
    var modal_border_color: UIColor = UIColor.white{
        didSet {
            self.setProperties()
        }
    }
    var modal_box_shadow:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5){
        didSet {
            self.setProperties()
        }
    }
    var modal_body_padding:CGFloat = CGFloat(0.0){
        didSet {
            self.setProperties()
        }
    }
    var modal_title_font_family: String = "Dosis-Book"{
        didSet {
            lblHeaderTitle.font = UIFont(name: modal_title_font_family, size: lblHeaderTitle.font.pointSize)
        }
    }
    var modal_title_font_size: CGFloat = CGFloat(16.0){
        didSet {
            lblHeaderTitle.font = UIFont(name: lblHeaderTitle.font.fontName, size: modal_title_font_size)
        }
    }
    var modal_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            lblHeaderTitle.textColor = modal_title_font_color
        }
    }
    var modal_title_position: NSTextAlignment = .left{
        didSet {
            lblHeaderTitle.textAlignment = modal_title_position
        }
    }
    //Player view collection cell property
    var product_popup_background:UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_border: CGFloat = CGFloat(1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_border_color: UIColor = UIColor.black{
        didSet {
            self.reloadData()
        }
    }
    var product_popup_box_shadow:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_padding: CGFloat = CGFloat(10.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_width: CGFloat = CGFloat(292.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_border_radius: CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    var product_border: CGFloat = CGFloat(1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_border_color: UIColor = UIColor.black {
        didSet {
            self.reloadData()
        }
    }
    var product_title_font_family: String = "Dosis-Book"{
        didSet {
            self.reloadData()
        }
    }
    var product_title_font_size: CGFloat = CGFloat(14.0){
        didSet {
            self.reloadData()
        }
    }
    var product_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_title_text_align: NSTextAlignment = .left{
        didSet {
            self.reloadData()
        }
    }
    var product_price_font_family: String = "Dosis-Bold"{
        didSet {
            self.reloadData()
        }
    }
    var product_price_font_size: CGFloat = CGFloat(16.0){
        didSet {
            self.reloadData()
        }
    }
    var product_price_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_price_text_align: NSTextAlignment = .left{
        didSet {
            self.reloadData()
        }
    }
    var product_reviews_font_family: String = "Dosis-Book"{
        didSet {
            self.reloadData()
        }
    }
    var product_reviews_font_size: CGFloat = CGFloat(12.0){
        didSet {
            self.reloadData()
        }
    }
    var product_reviews_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_ratings_border_color:UIColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_ratings_fill_color:UIColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    //Player view collection cell CTA property
    var product_popup_cta_text: String = "View Details" {
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_text_transform:TextTransform = .uppercase{
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_font_family: String = "Dosis-Bold"{
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_font_size: CGFloat = CGFloat(14.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_font_color:UIColor = UIColor.white{
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_background:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_border_radius: CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_border: CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    var product_popup_cta_border_color: UIColor = UIColor.black {
        didSet {
            self.reloadData()
        }
    }
    
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
        
        let dictVideoDetails:NSDictionary = playerData.dictJSON.mutableCopy() as! NSDictionary
        let dictAsset:NSDictionary = dictVideoDetails.getDictionary(key: "asset")
        let arrAssetSources:NSArray = dictAsset.getArray(key: "sources")
        let actualyQualityArray = arrAssetSources.value(forKey: "quality") as! NSArray
        
        let sortedFriends3 = playerData.asset.sources.sorted {$0.quality.localizedStandardCompare($1.quality) == .orderedDescending}
        
        viewTVP.getDATAandALLCheck(dict: dictVideoDetails as! [String : Any])
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
        //Set Modal Properties
        self.setProperties()
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
        cellHeight = Double(cvProductList.frame.size.height)
        
        //Create Player View
        viewTVP = TVPagePlayerView.init(frame: CGRect(x: 50, y: 200, width: 350, height: 200))
        self.viewPlayer.addSubview(viewTVP)
        viewTVP.delegate = self
        viewTVP.show(frame: CGRect(x:0,y:0,width:self.viewPlayer.frame.size.width,height:self.viewPlayer.frame.size.height), view: self.viewPlayer)
        
        //Close button
        imgBtnClose.image = self.getIconImage(imageName: "imgCloseMaterial")
        
        //Set Modal Properties
        self.setProperties()
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
               // cellProduct.viewContainer.layer.borderWidth = 0.5
                //cellProduct.viewContainer.layer.borderColor = UIColor.black.cgColor
                //cellProduct.lblTitle.font = UIFont(name: "Dosis-Book", size: cellProduct.lblTitle.font.pointSize)
                //cellProduct.lblDetail.font = UIFont(name: "Dosis-Book", size: cellProduct.lblDetail.font.pointSize)
                //cellProduct.lblRatings.font = UIFont(name: "Dosis-Book", size: cellProduct.lblRatings.font.pointSize)
                //cellProduct.lblRate.font = UIFont(name: "Dosis-Bold", size: cellProduct.lblRate.font.pointSize)
                
                //cellProduct.lblViewDetails.font = UIFont(name: "Dosis-Bold", size: cellProduct.lblViewDetails.font.pointSize)
                
                //Set properties
                cellProduct.viewMainContainer.backgroundColor = product_popup_background
                cellProduct.viewMainContainer.layer.borderWidth = product_popup_border
                cellProduct.viewMainContainer.layer.borderColor = product_popup_border_color.cgColor
                cellProduct.viewMainContainer.layer.cornerRadius = product_popup_border_radius
                
                //cellProduct.viewMainContainer.layer.sublayers = nil
                cellProduct.viewMainContainer.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                cellProduct.viewMainContainer.layer.shadowColor = product_popup_box_shadow.cgColor
                cellProduct.viewMainContainer.layer.shadowRadius = 3.0
                cellProduct.viewMainContainer.layer.shadowOpacity = 1.0
                cellProduct.viewMainContainer.layer.shadowPath = UIBezierPath(rect: cellProduct.viewMainContainer.bounds).cgPath
                cellProduct.contentView.clipsToBounds = true
                
                cellProduct.viewContainerTop.constant = product_popup_padding
                cellProduct.viewContainerBottom.constant = product_popup_padding
                cellProduct.viewContainerLeading.constant = product_popup_padding
                cellProduct.viewContainerTrailing.constant = product_popup_padding
                cellProduct.viewMainContainer.layoutIfNeeded()
                
                cellProduct.imgProducts.layer.borderWidth = product_border
                cellProduct.imgProducts.layer.borderColor = product_border_color.cgColor
                
                cellProduct.lblTitle.font = UIFont(name: product_title_font_family, size: product_title_font_size)
                cellProduct.lblTitle.textColor = product_title_font_color
                cellProduct.lblTitle.textAlignment = product_title_text_align
                
                cellProduct.lblRate.font = UIFont(name: product_price_font_family, size: product_price_font_size)
                cellProduct.lblRate.textColor = product_price_font_color
                cellProduct.lblRate.textAlignment = product_price_text_align
                
                cellProduct.lblRatings.font = UIFont(name: product_reviews_font_family, size: product_reviews_font_size)
                cellProduct.lblRatings.textColor = product_reviews_font_color
                
                //Set Data
                
                cellProduct.btnViewDetails.tag = indexPath.row
                cellProduct.btnViewDetails.addTarget(self, action: #selector(self.btnShowDetailPressed(sender:)), for: UIControlEvents.touchUpInside)
                
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
                cellProduct.viewRatings.starFillColor = self.product_ratings_fill_color
                cellProduct.viewRatings.starBorderColor = self.product_ratings_border_color
                cellProduct.viewRatings.starSize = 9.0
                cellProduct.viewRatings.padding = 5.0
                cellProduct.viewRatings.starFillMode = StarFillModeHorizontal
                cellProduct.viewRatings.rating = 2.5
                
                cellProduct.lblViewDetails.text = product_popup_cta_text
                cellProduct.lblViewDetails.font = UIFont(name: product_popup_cta_font_family, size: product_popup_cta_font_size)
                cellProduct.lblViewDetails.textColor = product_popup_cta_font_color

                
                switch product_popup_cta_text_transform {
                case .capitalized :
                        cellProduct.lblViewDetails.text = cellProduct.lblViewDetails.text?.capitalized
                case .uppercase :
                    cellProduct.lblViewDetails.text = cellProduct.lblViewDetails.text?.uppercased()
                case .lowercase :
                    cellProduct.lblViewDetails.text = cellProduct.lblViewDetails.text?.lowercased()
                case .none :
                    cellProduct.lblViewDetails.text = cellProduct.lblViewDetails.text

                }
                cellProduct.btnViewDetails.backgroundColor = product_popup_cta_background
                cellProduct.btnViewDetails.layer.cornerRadius = product_popup_cta_border_radius
                cellProduct.btnViewDetails.layer.borderWidth = product_popup_cta_border
                cellProduct.btnViewDetails.layer.borderColor = product_popup_cta_border_color.cgColor
                /*
                 product_popup_cta_text
                 product_popup_cta_text_transform
                 product_popup_cta_font_family
                 product_popup_cta_font_size
                 product_popup_cta_font_color
                 product_popup_cta_background
                 product_popup_cta_border_radius
                 product_popup_cta_border
                 product_popup_cta_border_color
                 */
            }
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout methods
extension PlayerPopUpView:UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Video List Cell Size
        return CGSize(width: product_popup_width, height: CGFloat(cellHeight))
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
//MARK: - Set properties
extension PlayerPopUpView {
    func setProperties(){
        lblHeaderTitle.font = UIFont(name: modal_title_font_family, size: modal_title_font_size)
        lblHeaderTitle.textColor = modal_title_font_color
        lblHeaderTitle.textAlignment = modal_title_position
        viewModal.backgroundColor = modal_background
        viewModal.layer.borderWidth = modal_border
        viewModal.layer.borderColor = modal_border_color.cgColor
        viewModal.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        viewModal.layer.shadowColor = modal_box_shadow.cgColor
        viewModal.layer.shadowRadius = 5
        viewModal.layer.shadowOpacity = 1.0
        viewModal.layer.shadowPath = UIBezierPath(rect: viewModal.bounds).cgPath
        for const in modalPadding {
            const.constant = modal_body_padding
        }
        self.layoutIfNeeded()
        viewTVP.frame = CGRect(x:0,y:0,width:self.viewPlayer.frame.size.width,height:self.viewPlayer.frame.size.height)
        
    }
    func reloadData(){
        self.cvProductList.reloadData()
    }
}
