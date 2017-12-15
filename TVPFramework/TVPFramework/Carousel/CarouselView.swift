//
//  CarouselView.swift
//  TVPagePhase2
//

import UIKit

//MARK: - Constant Declaration
let baseURLCarousel = "https://app.tvpage.com/api/"

public class CarouselView: UIView {
    
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
        let nibSidebarView = UINib(nibName: "CarouselView", bundle: bundle)
        let viewCarousel = nibSidebarView.instantiate(withOwner: self, options: nil)[0] as! UIView
        viewCarousel.frame = bounds
        viewCarousel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(viewCarousel);
        
        for view in self.cvVideoList.subviews {
            
            if view is UIImageView {
                
                let imageView = view as? UIImageView
                imageView?.isHidden = false
                imageView?.layer.removeAllAnimations()
                imageView?.alpha = 1.0
            }
        }
        lblHeaderTitle.font = UIFont(name: "Dosis-Bold", size: lblHeaderTitle.font.pointSize)
        
        
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
        let cellIdentifier = "CellCarouselVideoList"
        
        let bundle = Bundle(for: type(of: self))
        cvVideoList.register(UINib(nibName:"CellCarouselVideoList", bundle: bundle), forCellWithReuseIdentifier: cellIdentifier)
        cvVideoList.delegate = self
        cvVideoList.dataSource = self
        cvVideoList.contentInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        cvVideoList.register(VideoListFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        //Header View
        imgHeaderUnderLine.image = self.getIconImage(imageName: "imgHeaderUnderLine")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.lblHeaderTitle.font = UIFont(name: "Dosis-Bold", size: 25.0)
        }
        
        
        //Cell Size
        cellWidth = (Double((frame.size.width) / 1.5))
        cellHeight = (cellWidth * 0.73)
        
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
extension CarouselView {
    
    //MARK: - Get Channel Video List
    private func getChannelVideoList() {
        
        //Check for stop continiously calling API
        if isChannelVideoListAPICalling == false {
            isChannelVideoListAPICalling = true
            
            if videoPageNumber == 0 {
                //Show progress hud
                //appDelegateShared.showHud()
            }
            
            print("PAGE NO : \(videoPageNumber)")
            
            TVPApiClass.channelVideoList(strLoginID: Constants.loginID, strChhanelID:Constants.channelID, searchString: "", pageNumber: videoPageNumber,numberOfVideo: 10) { (arrChannelVideolist:NSArray,strError:String) in
                
                print(strError)
                self.isChannelVideoListAPICalling = false
                
                //Hide progress hud
                //appDelegateShared.dismissHud()
                
                if strError == "" {
                    
                    //Set video data
                    for videoData in arrChannelVideolist {
                        
                        //appDelegateShared.arrVideoList.add(videoData)
                        
                        let dictVideoData = videoData as! NSDictionary
                        self.arrVideosList.append(ModelVideoList(dictJSON: dictVideoData))
                        
                    }
                    
                    //Increase pageing counter
                    if arrChannelVideolist.count > 0 {
                        
                        self.videoPageNumber = self.videoPageNumber + 1
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
extension CarouselView:UICollectionViewDelegate {
    
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
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //For latest video scroll indicator visible
        for view in self.cvVideoList.subviews {
            
            if view is UIImageView {
                
                let imageView = view as? UIImageView
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    
                    imageView?.isHidden = false
                    imageView?.layer.removeAllAnimations()
                    imageView?.alpha = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    
                    imageView?.isHidden = false
                    imageView?.layer.removeAllAnimations()
                    imageView?.alpha = 1.0
                }
            }
        }
    }
}
//MARK: - UICollectionViewDataSource methods
extension CarouselView:UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Video List
        return arrVideosList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrVideosList.count - 1 == indexPath.row {
            self.getChannelVideoList()
        }
        //Create Video Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCarouselVideoList", for: indexPath) as! CellCarouselVideoList
        
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Video List
        if (cvVideoList == collectionView) {
            
            //Video List Cell
            if let cellVideo = cell as? CellCarouselVideoList {
                
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
    
}
//MARK: - UICollectionViewDelegateFlowLayout methods
extension CarouselView:UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Video List Cell Size
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
//MARK: - Customization
extension CarouselView {
    
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

