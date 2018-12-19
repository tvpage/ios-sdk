
//  https://medium.com/@zaidkhanintel/develop-a-swift-framework-1c7fdda27bf1

import UIKit

public class SidebarView: UIView {

    //MARK: - IBOutlet Declaration
    @IBOutlet var constraintHeaderTitleLeading: NSLayoutConstraint!
    @IBOutlet var constraintHeaderTitleTrailing: NSLayoutConstraint!
    @IBOutlet var lblHeaderTitle: UILabel!
    @IBOutlet var imgHeaderUnderLine: UIImageView!
    @IBOutlet var cvVideoList: UICollectionView!
    
    //MARK: - Variable Declaration
    var arrVideosList = [ModelVideoList]()
    var cellWidth = 0.0
    var cellHeight = 0.0
    
    //More Button Validation
    var isMoreButtonHidden:Bool = true
    
    //TVPage Player View
    @IBOutlet var viewContentPlayer: UIView!
    var playerView:TVPagePlayerView!
    
    //API Calling
    var isChannelVideoListAPICalling:Bool = false
    var videoPageNumber:Int = 0
    
    //Player Popup
    var playerPopUpVeiw:PlayerPopUpView!
    
    //MARK: - Customization Declaration
    
    //Header
    public var  title: String = "" {
        didSet {
            lblHeaderTitle.text = title
        }
    }
    public var  title_font_family: String = "" {
        didSet {
            lblHeaderTitle.font = UIFont(name: title_font_family, size: lblHeaderTitle.font.pointSize)
        }
    }
    public var  title_font_size: CGFloat = CGFloat(10.0) {
        didSet {
            lblHeaderTitle.font = UIFont(name: lblHeaderTitle.font.fontName, size: title_font_size)
        }
    }
    public var  title_color: UIColor = UIColor.black {
        didSet {
            lblHeaderTitle.textColor = title_color
        }
    }
    public var  title_text_align: NSTextAlignment = .center {
        didSet {
            lblHeaderTitle.textAlignment = title_text_align
        }
    }
    public var  title_text_padding: CGFloat = CGFloat(0.0) {
        didSet {
            constraintHeaderTitleLeading.constant = title_text_padding
            constraintHeaderTitleTrailing.constant = title_text_padding
        }
    }
    public var  title_background: UIColor = UIColor.clear {
        didSet {
            lblHeaderTitle.backgroundColor = title_background
        }
    }
    
    //MARK: - Collection View Cell Property
    public var  item_image_overlay_color: UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2){
        didSet {
            self.reloadData()
        }
    }
    public var  item_play_button_background_color: UIColor = UIColor.white{
        didSet {
            self.reloadData()
        }
    }
    public var  item_play_button_border:CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    public var  item_play_button_border_color: UIColor = UIColor.white{
        didSet {
            self.reloadData()
        }
    }
    public var  item_play_button_icon_color: UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    public var  item_title_font_family: String = "Dosis-Light"{
        didSet {
            self.reloadData()
        }
    }
    public var  item_title_font_size: CGFloat = CGFloat(12.0){
        didSet {
            self.reloadData()
        }
    }
    public var  item_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    public var  item_title_padding:CGFloat = CGFloat(7.0){
        didSet {
            self.reloadData()
        }
    }
    public var  item_title_text_align: NSTextAlignment = .left{
        didSet {
            self.reloadData()
        }
    }
    public var  item_title_background:UIColor = UIColor.clear{
        didSet {
            self.reloadData()
        }
    }
    public var  items_per_page:Int = Int(4){
        didSet {
            isChannelVideoListAPICalling = false
            self.arrVideosList.removeAll()
            self.reloadData()
            self.videoPageNumber = 0
            self.getChannelVideoList()
        }
    }
    public var  items_per_row:Int = Int(2){
        didSet {
            cellWidth = (Double((frame.size.width - CGFloat(13 + (13 * items_per_row))) / CGFloat(items_per_row)))
            cellHeight = (cellWidth * 0.83)
            self.reloadData()
        }
    }
    public var  load_button_text:String = "View More"{
        didSet{
            self.reloadData()
        }
    }
    public var  load_button_text_color: UIColor = UIColor.white{
        didSet {
            self.reloadData()
        }
    }
    public var  load_button_background_color: UIColor = UIColor.init(red: 31.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    public var  load_button_border_color: UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            self.reloadData()
        }
    }
    public var  load_button_border:CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    public var  load_button_border_radius:CGFloat = CGFloat(0.0){
        didSet {
            self.reloadData()
        }
    }
    
    //MARK: - Player View Property
    public var  modal_background:UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.modal_background = modal_background
        }
    }
    public var  modal_border:CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.modal_border = modal_border
        }
    }
    public var  modal_border_color: UIColor = UIColor.white{
        didSet {
            playerPopUpVeiw.modal_border_color = modal_border_color
        }
    }
    public var  modal_box_shadow:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5){
        didSet {
            playerPopUpVeiw.modal_box_shadow = modal_box_shadow
        }
    }
    public var  modal_body_padding:CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.modal_body_padding = modal_body_padding
        }
    }
    public var  modal_title_font_family: String = "Helvetica"{
        didSet {
            playerPopUpVeiw.modal_title_font_family = modal_title_font_family
        }
    }
    public var  modal_title_font_size: CGFloat = CGFloat(16.0){
        didSet {
            playerPopUpVeiw.modal_title_font_size = modal_title_font_size
        }
    }
    public var  modal_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.modal_title_font_color = modal_title_font_color
        }
    }
    public var  modal_title_position: NSTextAlignment = .left{
        didSet {
            playerPopUpVeiw.modal_title_position = modal_title_position
        }
    }
    //Player view collection cell property
    public var  product_popup_background:UIColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_popup_background = product_popup_background
        }
    }
    public var  product_popup_border: CGFloat = CGFloat(1.0){
        didSet {
            playerPopUpVeiw.product_popup_border = product_popup_border
        }
    }
    public var  product_popup_border_color: UIColor = UIColor.black{
        didSet {
            playerPopUpVeiw.product_popup_border_color = product_popup_border_color
        }
    }
    public var  product_popup_box_shadow:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0){
        didSet {
            playerPopUpVeiw.product_popup_box_shadow = product_popup_box_shadow
        }
    }
    public var  product_popup_padding: CGFloat = CGFloat(10.0){
        didSet {
            playerPopUpVeiw.product_popup_padding = product_popup_padding
        }
    }
    public var  product_popup_border_radius: CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.product_popup_border_radius = product_popup_border_radius
        }
    }
    public var  product_popup_width: CGFloat = CGFloat(292.0){
        didSet {
            playerPopUpVeiw.product_popup_width = product_popup_width
        }
    }
    public var  product_border: CGFloat = CGFloat(1.0){
        didSet {
            playerPopUpVeiw.product_border = product_border
        }
    }
    public var  product_border_color: UIColor = UIColor.black {
        didSet {
            playerPopUpVeiw.product_border_color = product_border_color
        }
    }
    public var  product_title_font_family: String = "Helvetica"{
        didSet {
            playerPopUpVeiw.product_title_font_family = product_title_font_family
        }
    }
    public var  product_title_font_size: CGFloat = CGFloat(14.0){
        didSet {
            playerPopUpVeiw.product_title_font_size = product_title_font_size
        }
    }
    public var  product_title_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_title_font_color = product_title_font_color
        }
    }
    public var  product_title_text_align: NSTextAlignment = .left{
        didSet {
            playerPopUpVeiw.product_title_text_align = product_title_text_align
        }
    }
    public var  product_price_font_family: String = "Helvetica"{
        didSet {
            playerPopUpVeiw.product_price_font_family = product_price_font_family
        }
    }
    public var  product_price_font_size: CGFloat = CGFloat(16.0){
        didSet {
            playerPopUpVeiw.product_price_font_size = product_price_font_size
        }
    }
    public var  product_price_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_price_font_color = product_price_font_color
        }
    }
    public var  product_price_text_align: NSTextAlignment = .left{
        didSet {
            playerPopUpVeiw.product_price_text_align = product_price_text_align
        }
    }
    public var  product_reviews_font_family: String = "Helvetica"{
        didSet {
            playerPopUpVeiw.product_reviews_font_family = product_reviews_font_family
        }
    }
    public var  product_reviews_font_size: CGFloat = CGFloat(12.0){
        didSet {
            playerPopUpVeiw.product_reviews_font_size = product_reviews_font_size
        }
    }
    public var  product_reviews_font_color:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_reviews_font_color = product_reviews_font_color
        }
    }
    public var  product_ratings_border_color:UIColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_ratings_border_color = product_ratings_border_color
        }
    }
    public var  product_ratings_fill_color:UIColor = UIColor.init(red: 169.0/255.0, green: 190.0/255.0, blue: 175.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_ratings_fill_color = product_ratings_fill_color
        }
    }
    //Player view collection cell CTA property
    public var  product_popup_cta_text: String = "View Details" {
        didSet {
            playerPopUpVeiw.product_popup_cta_text = product_popup_cta_text
        }
    }
    public var  product_popup_cta_text_transform:TextTransform = .uppercase{
        didSet {
            playerPopUpVeiw.product_popup_cta_text_transform = product_popup_cta_text_transform
        }
    }
    public var  product_popup_cta_font_family: String = "Helvetica"{
        didSet {
            playerPopUpVeiw.product_popup_cta_font_family = product_popup_cta_font_family
        }
    }
    public var  product_popup_cta_font_size: CGFloat = CGFloat(14.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_font_size = product_popup_cta_font_size
        }
    }
    public var  product_popup_cta_font_color:UIColor = UIColor.white{
        didSet {
            playerPopUpVeiw.product_popup_cta_font_color = product_popup_cta_font_color
        }
    }
    public var  product_popup_cta_background:UIColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_background = product_popup_cta_background
        }
    }
    public var  product_popup_cta_border_radius: CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_border_radius = product_popup_cta_border_radius
        }
    }
    public var  product_popup_cta_border: CGFloat = CGFloat(0.0){
        didSet {
            playerPopUpVeiw.product_popup_cta_border = product_popup_cta_border
        }
    }
    public var  product_popup_cta_border_color: UIColor = UIColor.black {
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
        let nibSidebarView = UINib(nibName: "SidebarView", bundle: bundle)
        let viewSidebar = nibSidebarView.instantiate(withOwner: self, options: nil)[0] as! UIView
        viewSidebar.frame = bounds
        viewSidebar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewSidebar);
        
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
        let cellIdentifier = "CellVideoList"
        
        let bundle = Bundle(for: type(of: self))
        cvVideoList.register(UINib(nibName:"CellVideoList", bundle: bundle), forCellWithReuseIdentifier: cellIdentifier)
        cvVideoList.delegate = self
        cvVideoList.dataSource = self
        cvVideoList.contentInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        cvVideoList.register(VideoListFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        //Header View
        imgHeaderUnderLine.image = self.getIconImage(imageName: "imgHeaderUnderLine")
        lblHeaderTitle.font = UIFont(name: "Dosis-Bold", size: lblHeaderTitle.font.pointSize)
        
        //Cell Size
        cellWidth = (Double((frame.size.width - CGFloat(13 + (13 * items_per_row))) / CGFloat(items_per_row)))
        cellHeight = (cellWidth * 0.83)
        
        //Get Channel Video List
        self.getChannelVideoList()
        
        //Create Player View
        self.createPlayerView()
        
        //ReSetSidebar
        self.resetSidebar()
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
    private func getFontURL(fontName:String) -> String {
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
//MARK: - API Calling
extension SidebarView {
    
    //MARK: - Get Channel Video List
    private func getChannelVideoList() {
        
        //Check for stop continiously calling API
        if isChannelVideoListAPICalling == false {
            isChannelVideoListAPICalling = true
            
            if videoPageNumber == 0 {
                //Show progress hud
                //appDelegateShared.showHud()
            }
            
            TVPApiClass.channelVideoList(strLoginID: Constants.loginID, strChhanelID:Constants.channelID, searchString: "", pageNumber: videoPageNumber,numberOfVideo: self.items_per_page) { (arrChannelVideolist:NSArray,strError:String) in
                
                print(strError)
                self.isChannelVideoListAPICalling = false
                
                //Hide progress hud
                //appDelegateShared.dismissHud()
                
                if strError == "" {
                    
                    //Set video data
                    for videoData in arrChannelVideolist {
                        
                        print(videoData)
                        //appDelegateShared.arrVideoList.add(videoData)
                        let dictVideoData = videoData as! NSDictionary
                        let videoDataModel:ModelVideoList = ModelVideoList(dictJSON: dictVideoData)
                        if let videoDataM = self.arrVideosList.first(where: { $0.id == videoDataModel.id }) {
                            print(videoDataM.id)
                        }else{
                            self.arrVideosList.append(ModelVideoList(dictJSON: dictVideoData))
                        }
                    }
                    
                    //Increase pageing counter
                    if arrChannelVideolist.count > 0 {
                        
                        self.videoPageNumber = self.videoPageNumber + 1
                        self.isMoreButtonHidden = true
                    } else {
                        
                        self.isMoreButtonHidden = false
                    }
                    
                    //Reload video list
                    self.cvVideoList.reloadData()
                    
                } else {
                    
                    //appDelegateShared.showToastMessage(message: strerror as NSString)
                }
            }
        }
    }
}
//MARK: - IBAction
extension SidebarView {
    
    @objc func tappedOnLoadMore() {
        
        //Get Channel Video List
        self.getChannelVideoList()
    }
}
//MARK: - UICollectionViewDelegate methods
extension SidebarView:UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("INDEX : ",indexPath.row)
        
        //Video List
        if (cvVideoList == collectionView) {
            
            //Show Player View Popup
            self.showPlayerViewPopup(playerData: arrVideosList[indexPath.row], isAnimated: true)
        }
    }
}
//MARK: - UICollectionViewDataSource methods
extension SidebarView:UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Video List
        return arrVideosList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create Video Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideoList", for: indexPath) as! CellVideoList
        
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Video List
        if (cvVideoList == collectionView) {
            
            //Video List Cell
            if let cellVideo = cell as? CellVideoList {
                
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
                //cellVideo.lblVideoContent.font = UIFont(name: "Dosis-Light", size: cellVideo.lblVideoContent.font.pointSize)
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
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footerView.backgroundColor = UIColor.clear
            
            for view in footerView.subviews {
                view.removeFromSuperview()
            }
            
            if self.isMoreButtonHidden == true {
                
                let btnLoadMore = UIButton(frame: CGRect(x: 0, y: 8, width: 90, height: 27))
                btnLoadMore.clipsToBounds = true
                btnLoadMore.setTitle(load_button_text, for: .normal)
                btnLoadMore.setTitleColor(load_button_text_color, for: .normal)
                btnLoadMore.backgroundColor = load_button_background_color
                btnLoadMore.layer.borderColor = load_button_border_color.cgColor
                btnLoadMore.layer.borderWidth = load_button_border
                btnLoadMore.layer.cornerRadius = load_button_border_radius
                btnLoadMore.titleLabel?.textAlignment = .center
                btnLoadMore.titleLabel?.font = UIFont(name: "Dosis-Bold", size: 12)
                btnLoadMore.addTarget(self, action: #selector(tappedOnLoadMore), for: .touchUpInside)
                footerView.addSubview(btnLoadMore)
            }
            
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout methods
extension SidebarView:UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Video List Cell Size
        return CGSize(width: cellWidth, height: cellHeight)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if arrVideosList.count == 0 {
            
            return CGSize.zero
        } else {
            
            return CGSize(width: cvVideoList.frame.size.width, height: 43)
        }
    }
}
//MARK: - TVPlayerDelegate
extension SidebarView:TVPlayerDelegate {
    
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
//MARK: - Customization
extension SidebarView {
    
    //ReSidebar
    func resetSidebar() {
        
        //Title
        title = "LATEST VIDEOS"
        title_font_family = "Dosis-Bold"
        title_font_size = CGFloat(25.0)
        title_color = UIColor.init(red: 47.0/255.0, green: 57.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        title_text_align = .center
        title_text_padding = CGFloat(0.0)
        title_background = .clear
        
    }
    //Refresh Sidebar Data
    func refreshSidebarData() {
        
        lblHeaderTitle.text = title
    }
    //Reload List Data
    func reloadData(){
        self.cvVideoList.reloadData()
    }
}
