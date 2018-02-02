

import UIKit

public class SoloView: UIView {
   
    //MARK: - IBOutlet Declaration
    @IBOutlet var cvVideoList: UICollectionView!
    
    //MARK: - Variable Declaration
    var arrVideosList = [ModelVideoList]()
    var cellWidth = 0.0
    var cellHeight = 0.0
    
    //API Calling
    var isProductVideoListAPICalling:Bool = false
    
    //Player Popup
    var playerPopUpVeiw:PlayerPopUpView!
    
    
    //MARK: - Customization Declaration
    //MARK: - Collection View Cell Property
    public var item_image_overlay_color: UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2){
        didSet {
            self.reloadData()
        }
    }
    public var item_play_button_background_color: UIColor = UIColor.white{
        didSet {
            self.reloadData()
        }
    }
    public var item_play_button_border:CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    public var item_play_button_border_color: UIColor = UIColor.white{
        didSet {
            self.reloadData()
        }
    }
    public var item_play_button_icon_color: UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    public var item_title_font_family: String = "Dosis-Book"{
        didSet {
            self.reloadData()
        }
    }
    public var item_title_font_size: CGFloat = CGFloat(12.0){
        didSet {
            self.reloadData()
        }
    }
    public var item_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    public var item_title_padding:CGFloat = CGFloat(7.0){
        didSet {
            self.reloadData()
        }
    }
    public var item_title_text_align: NSTextAlignment = .left{
        didSet {
            self.reloadData()
        }
    }
    public var item_title_background:UIColor = UIColor.clear{
        didSet {
            self.reloadData()
        }
    }
    
    //MARK: - Player View Property
    public var modal_background:UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.modal_background = modal_background
        }
    }
    public var modal_border:CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.modal_border = modal_border
        }
    }
    public var modal_border_color: UIColor = UIColor.white{
        didSet {
            playerPopUpVeiw.modal_border_color = modal_border_color
        }
    }
    public var modal_box_shadow:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5){
        didSet {
            playerPopUpVeiw.modal_box_shadow = modal_box_shadow
        }
    }
    public var modal_body_padding:CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.modal_body_padding = modal_body_padding
        }
    }
    public var modal_title_font_family: String = "Dosis-Book"{
        didSet {
            playerPopUpVeiw.modal_title_font_family = modal_title_font_family
        }
    }
    public var modal_title_font_size: CGFloat = CGFloat(16.0){
        didSet {
            playerPopUpVeiw.modal_title_font_size = modal_title_font_size
        }
    }
    public var modal_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.modal_title_font_color = modal_title_font_color
        }
    }
    public var modal_title_position: NSTextAlignment = .left{
        didSet {
            playerPopUpVeiw.modal_title_position = modal_title_position
        }
    }
    //Player view collection cell property
    public var product_popup_background:UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_popup_background = product_popup_background
        }
    }
    public var product_popup_border: CGFloat = CGFloat(1.0){
        didSet {
            playerPopUpVeiw.product_popup_border = product_popup_border
        }
    }
    public var product_popup_border_color: UIColor = UIColor.black{
        didSet {
            playerPopUpVeiw.product_popup_border_color = product_popup_border_color
        }
    }
    public var product_popup_box_shadow:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0){
        didSet {
            playerPopUpVeiw.product_popup_box_shadow = product_popup_box_shadow
        }
    }
    public var product_popup_padding: CGFloat = CGFloat(10.0){
        didSet {
            playerPopUpVeiw.product_popup_padding = product_popup_padding
        }
    }
    public var product_popup_border_radius: CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.product_popup_border_radius = product_popup_border_radius
        }
    }
    public var product_popup_width: CGFloat = CGFloat(292.0){
        didSet {
            playerPopUpVeiw.product_popup_width = product_popup_width
        }
    }
    public var product_border: CGFloat = CGFloat(1.0){
        didSet {
            playerPopUpVeiw.product_border = product_border
        }
    }
    public var product_border_color: UIColor = UIColor.black {
        didSet {
            playerPopUpVeiw.product_border_color = product_border_color
        }
    }
    public var product_title_font_family: String = "Dosis-Book"{
        didSet {
            playerPopUpVeiw.product_title_font_family = product_title_font_family
        }
    }
    public var product_title_font_size: CGFloat = CGFloat(14.0){
        didSet {
            playerPopUpVeiw.product_title_font_size = product_title_font_size
        }
    }
    public var product_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_title_font_color = product_title_font_color
        }
    }
    public var product_title_text_align: NSTextAlignment = .left{
        didSet {
            playerPopUpVeiw.product_title_text_align = product_title_text_align
        }
    }
    public var product_price_font_family: String = "Dosis-Bold"{
        didSet {
            playerPopUpVeiw.product_price_font_family = product_price_font_family
        }
    }
    public var product_price_font_size: CGFloat = CGFloat(16.0){
        didSet {
            playerPopUpVeiw.product_price_font_size = product_price_font_size
        }
    }
    public var product_price_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_price_font_color = product_price_font_color
        }
    }
    public var product_price_text_align: NSTextAlignment = .left{
        didSet {
            playerPopUpVeiw.product_price_text_align = product_price_text_align
        }
    }
    public var product_reviews_font_family: String = "Dosis-Book"{
        didSet {
            playerPopUpVeiw.product_reviews_font_family = product_reviews_font_family
        }
    }
    public var product_reviews_font_size: CGFloat = CGFloat(12.0){
        didSet {
            playerPopUpVeiw.product_reviews_font_size = product_reviews_font_size
        }
    }
    public var product_reviews_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_reviews_font_color = product_reviews_font_color
        }
    }
    public var product_ratings_border_color:UIColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_ratings_border_color = product_ratings_border_color
        }
    }
    public var product_ratings_fill_color:UIColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_ratings_fill_color = product_ratings_fill_color
        }
    }
    //Player view collection cell CTA property
    public var product_popup_cta_text: String = "View Details" {
        didSet {
            playerPopUpVeiw.product_popup_cta_text = product_popup_cta_text
        }
    }
    public var product_popup_cta_text_transform:TextTransform = .uppercase{
        didSet {
            playerPopUpVeiw.product_popup_cta_text_transform = product_popup_cta_text_transform
        }
    }
    public var product_popup_cta_font_family: String = "Dosis-Light"{
        didSet {
            playerPopUpVeiw.product_popup_cta_font_family = product_popup_cta_font_family
        }
    }
    public var product_popup_cta_font_size: CGFloat = CGFloat(14.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_font_size = product_popup_cta_font_size
        }
    }
    public var product_popup_cta_font_color:UIColor = UIColor.white{
        didSet {
            playerPopUpVeiw.product_popup_cta_font_color = product_popup_cta_font_color
        }
    }
    public var product_popup_cta_background:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_background = product_popup_cta_background
        }
    }
    public var product_popup_cta_border_radius: CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_border_radius = product_popup_cta_border_radius
        }
    }
    public var product_popup_cta_border: CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_border = product_popup_cta_border
        }
    }
    public var product_popup_cta_border_color: UIColor = UIColor.black {
        didSet {
            playerPopUpVeiw.product_popup_cta_border_color = product_popup_cta_border_color
        }
    }
    //MARK: - Init
    required public override init(frame: CGRect) {
        
        super.init(frame: frame)
        loadViewFromNib ()
        
        //Initialization
        self.initialization()
        
        
    }
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        loadViewFromNib ()
        
    }
    private func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nibSoloView = UINib(nibName: "SoloView", bundle: bundle)
        let viewSolo = nibSoloView.instantiate(withOwner: self, options: nil)[0] as! UIView
        viewSolo.frame = bounds
        viewSolo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewSolo);
        
        for view in self.cvVideoList.subviews {
            
            if view is UIImageView {
                
                let imageView = view as? UIImageView
                imageView?.isHidden = false
                imageView?.layer.removeAllAnimations()
                imageView?.alpha = 1.0
            }
        }
        
        
    }
    //MARK: - initialization
    private func initialization() {
        
        //Install font
        installFont("DosisBold")
        installFont("DosisBook")
        installFont("DosisExtraBold")
        installFont("DosisExtraLight")
        installFont("DosisLight")
        installFont("DosisMedium")
        installFont("DosisSemiBold")
        
        //Register Cell
        let cellIdentifier = "CellSoloVideoList"
        
        let bundle = Bundle(for: type(of: self))
        cvVideoList.register(UINib(nibName:"CellSoloVideoList", bundle: bundle), forCellWithReuseIdentifier: cellIdentifier)
        cvVideoList.delegate = self
        cvVideoList.dataSource = self
        cvVideoList.contentInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        cvVideoList.register(VideoListFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        
        //Cell Size
        cellWidth = (Double((frame.size.width) - 26))
        cellHeight = (cellWidth * 0.69)
        
        //Get Channel Video List
        self.getProductVideoList()
        
        
        //Create Player View
        self.createPlayerView()
        
    }
    //MARK: - Create Player View
    private func createPlayerView() {
        
        playerPopUpVeiw = PlayerPopUpView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        self.addSubview(playerPopUpVeiw);
        
        //Hide Player View Popup
        self.hidePlayerViewPopup(isAnimated: false)
    }
    //MARK: - Show Player View Popup
    private func showPlayerViewPopup(playerData:ModelVideoList , isAnimated:Bool) {
        
        //Set handle for events
        playerPopUpVeiw.showPlayer { (index) in
            
            if index == 0 {
                
                //Hide Player view popup
                self.hidePlayerViewPopup(isAnimated: true);
            }
        }
        
        //Set player data when player view open
        playerPopUpVeiw.setPlayerData(playerData: playerData)
        
        playerPopUpVeiw.isHidden = false
        
        if isAnimated == true {
            
            //Show Popup with animation
            playerPopUpVeiw.alpha = 0.01
            UIView.animate(withDuration: 0.25, animations: {
                
                self.playerPopUpVeiw.alpha = 1.0
                
            }, completion: { (finished) in
                
            })
            
        } else {
            
            //Show Popup without animation
            playerPopUpVeiw.alpha = 1.0
        }
    }
    //MARK: - Hide Player View Popup
    private func hidePlayerViewPopup(isAnimated:Bool) {
        
        //Stop player when hide player popup
        playerPopUpVeiw.stopPlayer()
        
        if isAnimated == true {
            
            //Hide Popup with animation
            UIView.animate(withDuration: 0.25, animations: {
                
                self.playerPopUpVeiw.alpha = 0.01
                
            }, completion: { (finished) in
                
                self.playerPopUpVeiw.isHidden = true
            })
            
        } else {
            
            //Hide Popup without animation
            self.playerPopUpVeiw.isHidden = true
        }
    }
    //MARK: - Get Icon Image
    private func getIconImage(imageName:String) -> UIImage {
        let  bundle = Bundle(url: Bundle.main.url(forResource: "TVPResources", withExtension: "bundle")!)
        let  imagePath: String? = bundle?.path(forResource: imageName, ofType: "png")
        let  image = UIImage(contentsOfFile: imagePath!)
        return image!
    }
    //MARK: - Font Install
    @discardableResult
    func installFont(_ font:String) -> Bool {
        
        guard let fontUrl = Bundle.main.url(forResource: font, withExtension: "ttf") else {
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

}
//MARK: - API Calling
extension SoloView {
    
    //MARK: - Get Product Video List
    private func getProductVideoList() {
        
        //Check for stop continiously calling API
        if isProductVideoListAPICalling == false {
            isProductVideoListAPICalling = true
            
            TVPApiClass.productVideoList(strLoginID: Constants.loginID, strProductID:Constants.productID) { (arrChannelVideolist:NSArray,strError:String) in
                
                print(strError)
                self.isProductVideoListAPICalling = false
                
                //Hide progress hud
                //appDelegateShared.dismissHud()
                
                if strError == "" {
                    
                    //Set video data
                    for videoData in arrChannelVideolist {
                        
                        //appDelegateShared.arrVideoList.add(videoData)
                        
                        let dictVideoData = videoData as! NSDictionary
                        let videoDataModel:ModelVideoList = ModelVideoList(dictJSON: dictVideoData)
                        if let videoDataM = self.arrVideosList.first(where: { $0.id == videoDataModel.id }) {
                            print(videoDataM.id)
                        }else{
                            
                            if self.arrVideosList.count == 0 {
                                
                                self.arrVideosList.append(ModelVideoList(dictJSON: dictVideoData))
                            }
                        }
                        
                    }
                    
                    //Increase pageing counter
                    if arrChannelVideolist.count > 0 {

                        //Reload video list
                        self.cvVideoList.reloadData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            for view in self.cvVideoList.subviews {
                                
                                if view is UIImageView {
                                    
                                    let imageView = view as? UIImageView
                                    imageView?.isHidden = false
                                    imageView?.layer.removeAllAnimations()
                                    imageView?.alpha = 1.0
                                }
                            }
                        }
                    }
                    
                    
                    
                } else {
                    
                    //appDelegateShared.showToastMessage(message: strerror as NSString)
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate methods
extension SoloView:UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("INDEX : ",indexPath.row)
        
        //Video List
        if (cvVideoList == collectionView) {
            self.showPlayerViewPopup(playerData: arrVideosList[indexPath.row], isAnimated: true)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        for view in self.cvVideoList.subviews {
            
            if view is UIImageView {
                
                let imageView = view as? UIImageView
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    
                    imageView?.isHidden = false
                    imageView?.layer.removeAllAnimations()
                    imageView?.alpha = 1.0
                }
            }
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        for view in self.cvVideoList.subviews {
            
            if view is UIImageView {
                
                let imageView = view as? UIImageView
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    
                    imageView?.isHidden = false
                    imageView?.layer.removeAllAnimations()
                    imageView?.alpha = 1.0
                }
            }
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        for view in self.cvVideoList.subviews {
            
            if view is UIImageView {
                
                let imageView = view as? UIImageView
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    
                    imageView?.isHidden = false
                    imageView?.layer.removeAllAnimations()
                    imageView?.alpha = 1.0
                }
            }
        }
    }
}
//MARK: - UICollectionViewDataSource methods
extension SoloView:UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Video List
        return arrVideosList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create Video Cell
        let cellVideo = collectionView.dequeueReusableCell(withReuseIdentifier: "CellSoloVideoList", for: indexPath) as! CellSoloVideoList
        
        return cellVideo
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Video List
        if (cvVideoList == collectionView) {
            
            //Video List Cell
            if let cellVideo = cell as? CellSoloVideoList {
                
                cellVideo.imgPlaceholder.image = self.getIconImage(imageName: "imgPlaceholder")
                cellVideo.imgPlay.image = self.getIconImage(imageName: "imgplay-arrow")
                cellVideo.ViewPlay.layer.cornerRadius = cellVideo.ViewPlay.bounds.height/2.0
                cellVideo.imgThumbnail.image = UIImage()
                cellVideo.imgThumbnail.isHidden = true
                if arrVideosList[indexPath.row].asset.thumbnailUrl.characters.count > 0 {
                    
                    let urlThumb = URL(string: arrVideosList[indexPath.row].asset.thumbnailUrl)
                    cellVideo.imgThumbnail.image?.loadFromURL(url: urlThumb! as NSURL, callback: { (image) in
                        
                        cellVideo.imgThumbnail.isHidden = false
                        cellVideo.imgThumbnail.image = image
                    })
                }
                cellVideo.lblVideoContent.text = arrVideosList[indexPath.row].title
                
                //Set Property
                cellVideo.ViewPlay.backgroundColor = item_play_button_background_color
                cellVideo.ViewPlay.layer.borderWidth = item_play_button_border
                cellVideo.ViewPlay.layer.borderColor = item_play_button_border_color.cgColor
                cellVideo.imgPlay.image = cellVideo.imgPlay.image?.maskWithColor(color: item_play_button_icon_color)
                cellVideo.viewImageOverlay.backgroundColor = item_image_overlay_color
                cellVideo.lblVideoContent.font = UIFont(name: item_title_font_family, size: item_title_font_size)
                cellVideo.lblVideoContent.textColor = item_title_font_color
                cellVideo.lblVideoContent.backgroundColor = item_title_background
                cellVideo.constraintLblVideoContentLeading.constant = item_title_padding
                cellVideo.constraintLblVideoContentTrailing.constant = item_title_padding
                cellVideo.lblVideoContent.textAlignment = item_title_text_align
                cellVideo.contentView.layoutIfNeeded()
            }
        }
    }
    
}
//MARK: - UICollectionViewDelegateFlowLayout methods
extension SoloView:UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Video List Cell Size
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
//MARK: - Customization
extension SoloView {
    
    //Reload List Data
    func reloadData(){
        self.cvVideoList.reloadData()
    }
}
