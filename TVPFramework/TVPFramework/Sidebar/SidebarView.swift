//
//  SidebarView.swift
//  TVPFramework
//
 
import UIKit
//import TVP

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
    var title: String = "" {
        didSet {
            lblHeaderTitle.text = title
        }
    }
    var title_font_family: String = "" {
        didSet {
            lblHeaderTitle.font = UIFont(name: title_font_family, size: lblHeaderTitle.font.pointSize)
        }
    }
    var title_font_size: CGFloat = CGFloat(10.0) {
        didSet {
            lblHeaderTitle.font = UIFont(name: lblHeaderTitle.font.fontName, size: title_font_size)
        }
    }
    var title_color: UIColor = UIColor.black {
        didSet {
            lblHeaderTitle.textColor = title_color
        }
    }
    var title_text_align: NSTextAlignment = .center {
        didSet {
            lblHeaderTitle.textAlignment = title_text_align
        }
    }
    var title_text_padding: CGFloat = CGFloat(0.0) {
        didSet {
            constraintHeaderTitleLeading.constant = title_text_padding
            constraintHeaderTitleTrailing.constant = title_text_padding
        }
    }
    var title_background: UIColor = UIColor.clear {
        didSet {
            lblHeaderTitle.backgroundColor = title_background
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
        cellWidth = (Double((frame.size.width - (39)) / 2.0))
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
            
            TVPApiClass.channelVideoList(strLoginID: Constants.loginID, strChhanelID:Constants.channelID, searchString: "", pageNumber: videoPageNumber,numberOfVideo: 10) { (arrChannelVideolist:NSArray,strError:String) in
                
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
                        self.arrVideosList.append(ModelVideoList(dictJSON: dictVideoData))
                        
                    }
                    
                    //Increase pageing counter
                    if arrChannelVideolist.count > 0 {
                        
                        self.videoPageNumber = self.videoPageNumber + 1
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
                cellVideo.imgPlay.image = self.getIconImage(imageName: "imgPlay")
                cellVideo.imgThumbnail.image = UIImage()
                cellVideo.imgThumbnail.isHidden = true
                if arrVideosList[indexPath.row].asset.thumbnailUrl.characters.count > 0 {
                    
                    let urlThumb = URL(string: arrVideosList[indexPath.row].asset.thumbnailUrl)
                    cellVideo.imgThumbnail.image?.loadFromURL(url: urlThumb! as NSURL, callback: { (image) in
                        
                        cellVideo.imgThumbnail.isHidden = false
                        cellVideo.imgThumbnail.image = image
                    })
                }
                cellVideo.lblVideoContent.font = UIFont(name: "Dosis-Light", size: cellVideo.lblVideoContent.font.pointSize)
                cellVideo.lblVideoContent.text = arrVideosList[indexPath.row].asset.description
            }
        }
    }
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footerView.backgroundColor = UIColor.clear
            
            let btnLoadMore = UIButton(frame: CGRect(x: 0, y: 8, width: 90, height: 27))
            btnLoadMore.clipsToBounds = true
            btnLoadMore.setTitle("LOAD MORE", for: .normal)
            btnLoadMore.titleLabel?.textAlignment = .center
            btnLoadMore.titleLabel?.font = UIFont(name: "Dosis-Bold", size: 12)
            btnLoadMore.setTitleColor(UIColor.white, for: .normal)
            btnLoadMore.backgroundColor = UIColor.init(red: 29.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            btnLoadMore.addTarget(self, action: #selector(tappedOnLoadMore), for: .touchUpInside)
            footerView.addSubview(btnLoadMore)
            
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
}
