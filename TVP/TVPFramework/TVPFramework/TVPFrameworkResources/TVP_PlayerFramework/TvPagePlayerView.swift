import UIKit
import MediaPlayer
import AVKit

//MARK: - Player Delegate
@objc public protocol TVPlayerDelegate {
    
    @objc optional func tvPlayerReady(flag: Bool)
    @objc optional func tvPlayerError(error: Error)
    @objc optional func tvPlayerMediaReady(flag:Bool)
    @objc optional func tvPlayerMediaError(error: Error)
    @objc optional func tvPlayerErrorForbidden(error: Error)
    @objc optional func tvPlayerErrorHTML5Forbidden(error: Error)
    @objc optional func tvPlayerMediaComplete(flag:Bool)
    @objc optional func tvPlayerCued(flag:Bool)
    @objc optional func tvPlayerMediaVideoended(flag:Bool)
    @objc optional func tvPlayerMediaVideoplaying(flag:Bool)
    @objc optional func tvPlayerMediaVideopaused(flag:Bool)
    @objc optional func tvPlayerMediaVideobuffering(flag:Bool)
    @objc optional func tvPlayerPlaybackQualityChange(flag:String)
    @objc optional func tvPlayerMediaProviderChange(flag:String)
    @objc optional func tvPlayerSeek(flag:String)
    @objc optional func tvPlayerVideoLoad(flag:Bool)
    @objc optional func tvPlayerVideoCued(flag:Bool)
}

enum TVPlayerState : Int {
    
    case tvPlayerUnstarted = -1
    case tvPlayerEnded = 0
    case tvPlayerPlaying = 1
    case tvPlayerPaused = 2
    case tvPlayerBuffering = 3
    case tvPlayerCued = 5
}

//MARK: - Player View
public class TVPagePlayerView: UIView {
    
    //TODO: Variable declaration
    var playerLayer: AVPlayerLayer! = AVPlayerLayer()
    public var player: AVPlayer? = AVPlayer()
    
    public var delegate:TVPlayerDelegate?
    
    var lastScale: CGFloat = 0.0
    var arrQualityID = [ModelVideoAssetSources]()
    var videoEnded: Bool = false
    var played : Bool = false
    var isMuted: Bool = false
    var isCued: Bool = false
    var isVideoPlayRepeatedely:Bool = true
    
    var totalTime : String!
    var dateFormatter : DateFormatter!
    var playerItem : AVPlayerItem!
    var playbackTimeObserver : Any!
    let qualityDropDown = DropDown()
    var arrQualityString = NSMutableArray()
    var qualityIndex = 0
    var isVideoSliderChange = false
    
    var analiticsTimer: Timer!
    var isVVanaliticsCall : Bool = false
    var userLoginID = ""
    var userChannelID = ""
    var userVideoID = ""
    let playerViewController = AVPlayerViewController()
    var isViewRemoved = false
    var isVideoReadyToPlay:Bool = false
    var isVideoOpenFullScreen:Bool = false
    
    //TODO: Outlet declaration
    @IBOutlet var constraintBottomPlayer: NSLayoutConstraint!
    @IBOutlet var ControllerbarView: UIView!
    @IBOutlet var videoViewConstraintsheight: NSLayoutConstraint!
    @IBOutlet var imgqualityHD: UIImageView!
    @IBOutlet var imgFullscreen: UIImageView!
    @IBOutlet var imgbtnQuality: UIImageView!
    @IBOutlet var imgVolumeSpeaker: UIImageView!
    @IBOutlet var imgPlayPause: UIImageView!
    @IBOutlet var viewMainPlayer: UIView!
    @IBOutlet var btn_play_paush: UIControl!
    @IBOutlet var videoSlider: UISlider!
    @IBOutlet var videoProgress: UIProgressView!
    @IBOutlet var lbl_Time: UILabel!
    @IBOutlet var lbl_Quality: UILabel!
    @IBOutlet var btn_Quality: UIControl!
    @IBOutlet var VollumeSlider: UISlider!
    @IBOutlet var btnVolume: UIControl!
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet var acti_Loderview: UIActivityIndicatorView!
    @IBOutlet var btn_FullScreen: UIControl!
    
    required public override init(frame: CGRect) {
        
        // 1. setup any properties here
        super.init(frame: frame)
        loadViewFromNib ()
        
        self.resumePlayer()
        
        acti_Loderview.startAnimating()
        
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TvPagePlayerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }
    //MARK: - Tapped Event
    @IBAction func btn_FullScreenClicked(_ sender: UIControl) {
        
        playerViewController.player = self.player
        playerViewController.showsPlaybackControls = true
        playerViewController.allowsPictureInPicturePlayback = true
        isVideoOpenFullScreen = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tappedOnDone),
                                               name: NSNotification.Name.kAVPlayerViewControllerDismissingNotification,
                                               object: nil
        )
        
        self.window?.rootViewController?.present(playerViewController, animated: true, completion: {
            
            if self.played == true {
                
                //play
                self.playerViewController.player!.play()
                
            } else {
                
                //pause
                self.playerViewController.player!.pause()
            }
        })
    }
    @objc func tappedOnDone() {
        
        isVideoOpenFullScreen = false
        
        if self.playerViewController.player?.rate == 0.0 {
            
            played = false
            
        } else {
            
            played = true
        }
        
        if played == true {
            
            //Play
            self.perform(#selector(play), with: nil, afterDelay: 0.1)
            
        } else {
            
            //Pause
            self.perform(#selector(pause), with: nil, afterDelay: 0.1)
        }
    }
    @IBAction func videoSliderChangeValue(_ sender: Any) {
        
        //video Slider Value Change
        let slider: UISlider? = (sender as? UISlider)
        isVideoSliderChange = true
        
        if slider?.value == 0.000000 {
            
            //slider value 0 then seek to 0
            player?.seek(to: kCMTimeZero, completionHandler: { (finished : Bool) in
                self.E_TvPlayerSeek()
                self.videoProgress.setProgress(0, animated: true)
            })
        }
        
        let changedTime: CMTime = CMTimeMakeWithSeconds(Float64((slider?.value)!), 1)
        
        player?.seek(to: changedTime, completionHandler: {(finished: Bool) -> Void in
            
            self.E_TvPlayerSeek()
            self.videoProgress.setProgress((slider?.value)!, animated: true)
        })
    }
    @IBAction func videoSliderChangeValueEnd(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isVideoSliderChange = false
        }
    }
    @IBAction func btnVolumeClick(_ sender: UIControl) {
        
        if !isMuted {
            
            //Mute
            self.mute()
            
        } else {
            
            //Unmute
            self.unmute()
        }
    }
    @IBAction func VolumeSliderValueChange(_ sender: UISlider) {
        
        if !(self.player != nil) {
            
        } else {
            
            //set player volume
            if sender.value < 0.01 {
                
                isMuted = true
                imgVolumeSpeaker.image = getIconimage(iconname: "mute")
                
            } else {
                
                isMuted = false
                imgVolumeSpeaker.image = getIconimage(iconname: "speaker")
                
            }
            self.volume(vol: sender.value * 100)
        }
    }
    @IBAction func btn_QualityClick(_ sender: UIControl) {
        
        //quality button click
        qualityDropDown.show()
    }
    func setupQualityDropDown(arr:[ModelVideoAssetSources] , urlType: String) {
        
        //Quality dropdown setup
        var strQualityFull : String = ""
        
        //check video Type
        if urlType == "youtube" {
            
            for dict in arr {
                
                if strQualityFull == "" {
                    
                    let strQualityID = dict.quality
                    let strQualityName = self.checkQuality(strQualityID: strQualityID)
                    strQualityFull = strQualityName
                    
                } else {
                    
                    let strQualityID = dict.quality
                    let strQualityName = self.checkQuality(strQualityID: strQualityID)
                    strQualityFull =   "\(strQualityFull),\(strQualityName)"
                }
            }
        } else if urlType == "mp4" {
            
            for dict in arr {
                
                if strQualityFull == "" {
                    
                    strQualityFull = dict.quality
                    
                } else {
                    
                    strQualityFull =   "\(strQualityFull),\(dict.quality)"
                }
            }
        }
        
        //set quality array
        var arrFullName = strQualityFull.components(separatedBy: ",")
        arrFullName.insert("Auto", at: arrFullName.count)
        arrQualityString = NSMutableArray.init(array: arrFullName)
        
        self.layoutIfNeeded()
        
        //set Quality Dropdown
        qualityDropDown.anchorView = btn_Quality //set  quality dropdown position
        qualityDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        qualityDropDown.direction = .any
        qualityDropDown.cellHeight = 40
        qualityDropDown.dataSource = arrFullName
        qualityDropDown.selectRow(at: arrFullName.count-1)
        imgqualityHD.isHidden = true
        
        //Action triggered on selection Dropdown
        qualityDropDown.selectionAction = { [unowned self] (index, item) in
            
            self.E_TvPlayerPlaybackQualityChange(Qname: item)
            
            if item == "144p" || item == "240p" || item == "360p" || item == "480p" || item == "Auto" {
                
                self.imgqualityHD.isHidden = true
                self.imgqualityHD.image = UIImage(named:"")
                
            } else {
                
                self.imgqualityHD.isHidden = false
                self.imgqualityHD.image = self.getIconimage(iconname: "qualityhd")
            }
            
            self.qualityIndex = index
            
            let dictSelectedData = NSMutableDictionary.init()
            dictSelectedData.setObject("\(index)", forKey: "index" as NSCopying)
            dictSelectedData.setObject("\(item)", forKey: "item" as NSCopying)
            
            self.perform(#selector(self.loadReplacePlayer(dictData:)), with: dictSelectedData, afterDelay: 0.5)  //Load selected Quality
        }
    }
    @objc func loadReplacePlayer(dictData:NSDictionary) {
        
        //set selected quality URL
        let i:Index =  Index(dictData.value(forKey: "index") as! String)!
        let item = dictData.value(forKey: "item") as! String
        
        if item == "Auto" {
            
            let internetIndex:Int = self.getAutoNetworkStreming()
            
            if item == "Auto" {
                
                var actualyQualityArray:NSArray = NSArray()
                
                if self.player?.accessibilityHint == "mp4" {
                    
                    actualyQualityArray = self.arrQualityID.map{$0.quality} as NSArray
                    
                } else {
                    
                    actualyQualityArray = self.arrQualityID.map{$0.qualityActual} as NSArray
                }
                
                if internetIndex == 0 {
                    
                    if actualyQualityArray.contains("360p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "360p")
                        
                    } else if actualyQualityArray.contains("240p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "240p")
                        
                    } else if actualyQualityArray.contains("144p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "144p")
                        
                    } else if actualyQualityArray.contains("480p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "480p")
                        
                    } else if actualyQualityArray.contains("720p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "720p")
                    }
                    
                } else {
                    
                    if actualyQualityArray.contains("240p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "240p")
                        
                    } else if actualyQualityArray.contains("144p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "144p")
                        
                    } else if actualyQualityArray.contains("360p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "360p")
                        
                    } else if actualyQualityArray.contains("480p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "480p")
                        
                    } else if actualyQualityArray.contains("720p") {
                        
                        self.qualityIndex = actualyQualityArray.index(of: "720p")
                    }
                }
            }
            //check player in loded url type
            if self.player?.accessibilityHint == "mp4" {
                
                let videoHD720URL:String = self.arrQualityID[self.qualityIndex].file
                let videoURL = NSURL(string: videoHD720URL )
                self.setTempPlayerValue(videoURL: videoURL! as URL)
                
            } else {
                
                let videoHD720URL:String = self.arrQualityID[self.qualityIndex].url
                let videoURL = NSURL(string: videoHD720URL )
                self.setTempPlayerValue(videoURL: videoURL! as URL)
            }
        } else {
            
            //check player in loded url type
            if self.player?.accessibilityHint == "mp4" {
                
                let videoHD720URL:String = self.arrQualityID[i].file
                let videoURL = NSURL(string: videoHD720URL )
                self.setTempPlayerValue(videoURL: videoURL! as URL)
                
            } else {
                self.qualityIndex = i
                let videoHD720URL:String = "\(self.arrQualityID[i].url))"
                let videoURL = NSURL(string: videoHD720URL )
                self.setTempPlayerValue(videoURL: videoURL! as URL)
            }
        }
    }
    @IBAction func btn_play_paush_click(_ sender: Any) {
        
        //play pause button click
        if !played {
            
            //play
            self.play()
            
        } else {
            
            //pause
            self.pause()
        }
        played = !played
    }
    func availableDuration() -> CMTime {
        
        if let range = self.player?.currentItem?.loadedTimeRanges.first {
            
            return CMTimeRangeGetEnd(range.timeRangeValue)
        }
        return kCMTimeZero
    }
    func customVideoSlider(duration: CMTime)  {
        
        //set video slider
        videoSlider.maximumValue = Float(CMTimeGetSeconds(duration))
    }
    
    func monitoringPlayback(_ playerItem: AVPlayerItem) {
        
        //updated value slider and current time label
        weak var weakSelf = self
        
        self.playbackTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: {(_ time: CMTime) -> Void in
            let currentSecond = self.player?.currentItem!.currentTime()
            let seconds:Float = Float(CMTimeGetSeconds(currentSecond!))
            
            if seconds > 0.0 && self.isVideoSliderChange == false {
                
                weakSelf?.videoSlider?.setValue(seconds, animated: true)
                let strFromSecond : String = self.stringFromSeconds(value: Double(seconds))
                weakSelf?.lbl_Time?.text = "\(strFromSecond)"
                
                if self.isViewRemoved == false {
                    
                    
                }
            }
        })
    }
    func stringFromSeconds (value: Double) -> String {
        
        let time = NSInteger(value)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours > 0 {
            
            return String(format: "%02ld:%02ld:%02ld", Int(hours), Int(minutes), Int(seconds))
            
        } else {
            
            return String(format: "%02ld:%02ld",  Int(minutes), Int(seconds))
            
        }
    }
    func getDateFormatter() -> DateFormatter {
        
        if !(dateFormatter != nil) {
            
            dateFormatter = DateFormatter()
        }
        return dateFormatter
    }
    
    func convertTime(second : CGFloat) -> String {
        
        let date : NSDate = NSDate(timeIntervalSince1970: TimeInterval(second))
        
        if second/3600 >= 1 {
            
            self.getDateFormatter().dateFormat = "HH:mm:ss"
            
        } else {
            
            self.getDateFormatter().dateFormat = "mm:ss"
        }
        let showTimeNew : String = self.getDateFormatter().string(from: date as Date)
        return showTimeNew
    }
    
    @objc func moviePlayDidEnd(noti : NSNotification) {
        
        //event call
        played = false
        isVVanaliticsCall = true
        stop()
        videoEnded = true
        self.E_TvPlayerMediaComplete()
    }
    override public class var layerClass : AnyClass {
        
        return AVPlayerLayer.self
    }
    // Replace item to player
    func setTempPlayerValue(videoURL : URL)  {
        
        let avpItem:AVPlayerItem  = AVPlayerItem.init(url: videoURL)
        
        if !(self.player != nil) {
            
            self.player = AVPlayer(playerItem: avpItem)
            self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            self.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            self.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
            
        } else {
            
            let currentSecond = self.player?.currentItem!.currentTime()
            self.player?.replaceCurrentItem(with: avpItem)
            self.player?.seek(to: currentSecond!)
            videoProgress.setProgress(Float(CMTimeGetSeconds(currentSecond!)), animated: true)
            
            NotificationCenter.default.addObserver(self,selector: #selector(self.moviePlayDidEnd(noti:)),name: .AVPlayerItemDidPlayToEndTime,object: avpItem)
        }
    }
    public func getDATAandALLCheck(videoList:ModelVideoList) {
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch let error as NSError {
            
            print("error: \(error.localizedDescription)")
            
        }
        
        userLoginID = videoList.loginId
        userVideoID = videoList.id
        userChannelID = videoList.entityIdParent
        
        imgFullscreen.image = getIconimage(iconname: "fullscreenIN")
        
        if videoList.asset.type.length > 0  {
            
            let urlType = videoList.asset.type
            //check video type youtube or vimeo
            var thumbImage = videoList.asset.thumbnailUrl
            if !thumbImage.hasPrefix("http") && thumbImage.characters.count > 0{
                thumbImage = "http:" + thumbImage
            }
            
            if urlType == "youtube" || urlType == "vimeo" {
                
                let urlthumb = URL(string: thumbImage)!
                
                imgPoster.image = getIconimage(iconname: "placeholder")
                imgPoster.image?.loadFromURL(url: urlthumb as NSURL, callback: { (image) in
                    
                    self.imgPoster.image = image
                })
                
                let videoID = videoList.asset.videoId
                SetvideoUrl(StrURL: videoID, strType: urlType, isplay: true)
                
            } else if urlType == "mp4" {
                
                //check video type mp4
                let urlThumb = URL(string: thumbImage)!
                
                imgPoster.image = getIconimage(iconname: "placeholder")
                imgPoster.image?.loadFromURL(url: urlThumb as NSURL, callback: { (image) in
                    
                    self.imgPoster.image = image
                })
                
                self.arrQualityID.removeAll()
                self.arrQualityID = videoList.asset.sources
                
                setupQualityDropDown(arr: arrQualityID, urlType: urlType)
                
                let internetIndex:Int = self.getAutoNetworkStreming()
                var actualyQualityArray:NSArray = NSArray()
                actualyQualityArray = self.arrQualityID.map{$0.quality} as NSArray
                
                if self.qualityIndex < self.arrQualityID.count && self.qualityIndex > 0{
                    
                } else {
                    
                    if internetIndex == 0 {
                        
                        if actualyQualityArray.contains("360p"){
                            
                            self.qualityIndex = actualyQualityArray.index(of: "360p")
                            
                        } else if actualyQualityArray.contains("240p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "240p")
                            
                        } else if actualyQualityArray.contains("144p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "144p")
                            
                        } else if actualyQualityArray.contains("480p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "480p")
                            
                        } else if actualyQualityArray.contains("720p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "720p")
                            
                        } else if actualyQualityArray.contains("1080p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "1080p")
                        }
                        
                    } else {
                        
                        if actualyQualityArray.contains("240p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "240p")
                            
                        } else if actualyQualityArray.contains("144p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "144p")
                            
                        } else if actualyQualityArray.contains("360p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "360p")
                            
                        } else if actualyQualityArray.contains("480p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "480p")
                            
                        } else if actualyQualityArray.contains("720p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "720p")
                            
                        } else if actualyQualityArray.contains("1080p") {
                            
                            self.qualityIndex = actualyQualityArray.index(of: "1080p")
                        }
                    }
                }
                let strQualityID = self.arrQualityID[self.qualityIndex].quality
                if strQualityID == "144p"||strQualityID == "240p"||strQualityID == "360p"||strQualityID == "480p" {
                    
                    self.imgqualityHD.isHidden = true
                    self.imgqualityHD.image = UIImage(named:"")
                    self.qualityIndex = 0
                    
                } else {
                    
                    self.imgqualityHD.isHidden = false
                    self.imgqualityHD.image = self.getIconimage(iconname: "qualityhd")
                    self.qualityIndex = 0
                }
                
                var DashorHlsURL:URL!
                var videoHD720URL:String = arrQualityID[self.qualityIndex].file
                if videoHD720URL.length > 0 && videoHD720URL.lowercased().hasPrefix("http") == false {
                    
                    if videoHD720URL.lowercased().hasPrefix("//") == false {
                        
                        videoHD720URL = "https://" + videoHD720URL
                    } else {
                        
                        videoHD720URL = "https:" + videoHD720URL
                    }
                }
                
                DashorHlsURL = NSURL(string: videoHD720URL )! as URL
                self.setplayervalue(videoURL:DashorHlsURL, Type: "mp4", isplay: true)
            }
        } else {
            
            self.showAlertWithMessage(message: "Video type not supported")
        }
    }
    private func deallocObservers() {
        
        if ((self.player?.currentItem?.removeObserver(self, forKeyPath: "status")) != nil) {
            
        }
        if ((self.player?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")) != nil) {
            
        }
        if ((self.player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")) != nil) {
            
        }
        if ((self.player?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")) != nil) {
            
        }
        if ((self.player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferFull")) != nil) {
            
        }
    }
    func setplayervalue(videoURL : URL , Type : String , isplay:Bool)  {
        
        videoEnded = false
        hideControls(isAnimated: true)
        self.playerItem = AVPlayerItem.init(url: videoURL.absoluteURL )
        acti_Loderview.isHidden = false
        acti_Loderview.startAnimating()
        self.player = AVPlayer(playerItem: self.playerItem)
        self.volume(vol: AVAudioSession.sharedInstance().outputVolume * 100)
        self.player?.accessibilityHint = Type
        self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
        self.btn_play_paush.isEnabled = false
        NotificationCenter.default.addObserver(self,selector: #selector(self.moviePlayDidEnd(noti:)),name: .AVPlayerItemDidPlayToEndTime,object: self.playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = viewMainPlayer.frame
        playerLayer.backgroundColor = UIColor.clear.cgColor
        self.E_TvPlayerReady()
        viewMainPlayer.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = AVLayerVideoGravity.resize
        imgFullscreen.image = getIconimage(iconname: "fullscreenIN")
        
        if isplay {
            
            isVVanaliticsCall = true
            played = true
            play()
        }
    }
    func SetvideoUrl(StrURL : String , strType : String , isplay : Bool)  {
        
        arrQualityID = [ModelVideoAssetSources]()
        if strType == "youtube" {
            
            TvPageExtractor.sharedInstance().extractVideo(forIdentifier: StrURL) { (dict:[AnyHashable : Any]?, error:Error?) in
                
                if dict != nil {
                    
                    let d:NSDictionary = dict! as NSDictionary
                    let mutableArray : NSMutableArray = NSMutableArray.init(capacity:d.allKeys.count )
                    
                    for (key,val) in d {
                        
                        let str:String = "\(key)"
                        let strQualityActual:String = self.checkQuality(strQualityID: str)
                        let dic1:NSDictionary = [
                            "quality" : str,
                            "url" : val,
                            "qualityActual" : strQualityActual,
                            ]
                        mutableArray.add(dic1)
                        
                        let qualityID = ModelVideoAssetSources.init(dictJSON: dic1)
                        self.arrQualityID.append(qualityID)
                    }
                    
                    let arrSorted = self.arrQualityID.sorted {$0.quality.localizedStandardCompare($1.quality) == .orderedDescending}
                    self.arrQualityID.removeAll()
                    self.arrQualityID = arrSorted
                    self.setupQualityDropDown(arr: self.arrQualityID, urlType: strType)
                    let internetIndex:Int = self.getAutoNetworkStreming()
                    
                    var actualyQualityArray:NSArray = NSArray()
                    actualyQualityArray = self.arrQualityID.map{$0.qualityActual} as NSArray
                    //Set default quality order
                    if self.qualityIndex < self.arrQualityID.count && self.qualityIndex > 0{
                        
                    } else {
                        
                        if internetIndex == 0 {
                            if actualyQualityArray.contains("360p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "360p")
                                
                            } else if actualyQualityArray.contains("240p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "240p")
                                
                            } else if actualyQualityArray.contains("144p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "144p")
                                
                            } else if actualyQualityArray.contains("480p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "480p")
                                
                            } else if actualyQualityArray.contains("720p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "720p")
                                
                            } else if actualyQualityArray.contains("1080p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "1080p")
                            }
                        } else {
                            
                            if actualyQualityArray.contains("240p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "240p")
                                
                            } else if actualyQualityArray.contains("144p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "144p")
                                
                            } else if actualyQualityArray.contains("360p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "360p")
                                
                            } else if actualyQualityArray.contains("480p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "480p")
                                
                            } else if actualyQualityArray.contains("720p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "720p")
                                
                            } else if actualyQualityArray.contains("1080p") {
                                
                                self.qualityIndex = actualyQualityArray.index(of: "1080p")
                                
                            }
                        }
                    }
                    let str_QualityID = self.arrQualityID[self.qualityIndex].quality
                    let strQualityName = self.checkQuality(strQualityID: str_QualityID)
                    
                    if strQualityName == "144p"||strQualityName == "240p"||strQualityName == "360p"||strQualityName == "480p" {
                        
                        self.imgqualityHD.image = UIImage(named:"")
                        
                    } else {
                        
                        self.imgqualityHD.image = self.getIconimage(iconname: "qualityhd")
                    }
                    
                    var videoHD720URL:String = "\(self.arrQualityID[self.qualityIndex].url)"
                    if videoHD720URL.length > 0 && videoHD720URL.lowercased().hasPrefix("http") == false {
                        
                        if videoHD720URL.lowercased().hasPrefix("//") == false {
                            
                            videoHD720URL = "https://" + videoHD720URL
                        } else {
                            
                            videoHD720URL = "https:" + videoHD720URL
                        }
                    }
                    let videoURL = NSURL(string: videoHD720URL )
                    self.setplayervalue(videoURL: videoURL! as URL, Type: strType, isplay: isplay)
                }else{
                    self.showAlertWithMessage(message: "Video not found")
                    
                }
            }
        } else if strType == "vimeo" {
            
            YTVimeoExtractor.shared().fetchVideo(withVimeoURL: StrURL, withReferer: nil, completionHandler: {(_ YTvideo: YTVimeoVideo?, _ error: Error?) in
                
                if YTvideo != nil {
                    
                    self.qualityIndex = 0
                    let highQualityURL = YTvideo?.highestQualityStreamURL()
                    self.setplayervalue(videoURL: highQualityURL!, Type: strType, isplay: isplay)
                }
            })
        }
    }
    
    func showAlertWithMessage(message:String) {
        acti_Loderview.isHidden = true
        acti_Loderview.stopAnimating()
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Convert Quality ID to Quality
    func checkQuality(strQualityID : String) -> String {
        
        var qualityTitle = ""
        
        if strQualityID == "5" {
            
            qualityTitle = "240p"
            
        } else if strQualityID == "18" {
            
            qualityTitle = "360p"
            
        } else if strQualityID == "17" {
            
            qualityTitle = "144p"
            
        } else if strQualityID == "22" {
            
            qualityTitle = "720p"
            
        } else if strQualityID == "36" {
            
            qualityTitle = "240p"
            
        } else if strQualityID == "43" {
            
            qualityTitle = "360p"
            
        } else if strQualityID == "160" {
            
            qualityTitle = "144p"
            
        } else if strQualityID == "133" {
            
            qualityTitle = "240p"
            
        } else if strQualityID == "134" {
            
            qualityTitle = "360p"
            
        } else if strQualityID == "135" {
            
            qualityTitle = "480p"
            
        } else if strQualityID == "136" {
            
            qualityTitle = "720p"
            
        } else if strQualityID == "137" {
            
            qualityTitle = "1080p"
            
        } else if strQualityID == "264" {
            
            qualityTitle = "1440p"
            
        } else if strQualityID == "266" {
            
            qualityTitle = "2160p"
            
        } else if strQualityID == "298" {
            
            qualityTitle = "720p"
            
        } else if strQualityID == "299" {
            
            qualityTitle = "1080p"
            
        } else if strQualityID == "278" {
            
            qualityTitle = "144p"
            
        } else if strQualityID == "242" {
            
            qualityTitle = "240p"
            
        } else if strQualityID == "243" {
            
            qualityTitle = "360p"
            
        } else if strQualityID == "244" {
            
            qualityTitle = "480p"
            
        } else if strQualityID == "247" {
            
            qualityTitle = "720p"
            
        } else if strQualityID == "248" {
            
            qualityTitle = "1080p"
            
        } else if strQualityID == "271" {
            
            qualityTitle = "1440p"
            
        } else if strQualityID == "313" {
            
            qualityTitle = "2060p"
            
        } else if strQualityID == "302" {
            
            qualityTitle = "720p"
            
        } else if strQualityID == "308" {
            
            qualityTitle = "1440p"
            
        } else if strQualityID == "303" {
            
            qualityTitle = "1080p"
            
        } else if strQualityID == "315" {
            
            qualityTitle = "2160p"
            
        }
        return qualityTitle
    }
    //MARK: - AVPlayer observeValue , State
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.isViewRemoved == false {
            
            let avpItem : AVPlayerItem = object as! AVPlayerItem
            
            if keyPath == "status" {
                
                if  avpItem.status == .readyToPlay {
                    
                    isVVanaliticsCall = true
                    isVideoReadyToPlay = true
                    self.Analytics_Channel_Impression(LoginID: userLoginID)
                    isCued = true
                    self.showControls(isAnimated: true)
                    //default Event call
                    E_TvPlayerMediaReady()
                    E_TvPlayerCued()
                    acti_Loderview.isHidden = true
                    acti_Loderview.stopAnimating()
                    btn_play_paush.isEnabled = true
                    let duration : CMTime = (avpItem.duration)
                    self.customVideoSlider(duration: duration)
                    self.monitoringPlayback((player?.currentItem)!)
                    
                } else if  avpItem.status == .failed {
                    
                    self.E_TvPlayerMediaError()
                    hideControls(isAnimated: true)
                    
                }
                
            } else if (keyPath == "loadedTimeRanges") {
                
                let timeInterval: CMTime = self.availableDuration()
                let duration: CMTime = player!.currentItem!.duration
                let totalDuration: Float = Float(CMTimeGetSeconds(duration))
                let progressValue: Float = Float(Float(CMTimeGetSeconds(timeInterval)) + Float(totalDuration))
                videoProgress.setProgress(progressValue, animated: false)
                
            } else if (keyPath == "playbackBufferEmpty") {
                
                acti_Loderview.isHidden = false
                self.bringSubview(toFront: acti_Loderview)
                acti_Loderview.startAnimating()
                E_TvPlayerMediaVideobuffering()
                
            } else if (keyPath == "playbackLikelyToKeepUp") {
                
                E_TvPlayerMediaVideobuffering()
                acti_Loderview.isHidden = true
                acti_Loderview.stopAnimating()
                
            } else if (keyPath == "playbackBufferFull"){
                
                E_TvPlayerMediaVideobuffering()
                acti_Loderview.isHidden = true
                acti_Loderview.stopAnimating()
            }
        } else {
            
            self.stopPlayer()
        }
    }
    //MARK: - Default
    public func show(frame:CGRect , view:UIView) {
        
        self.hideControls(isAnimated: false)
        
        self.frame = frame
        self.layoutIfNeeded()
        view.addSubview(self)
        
        self.videoSlider.setThumbImage(getIconimage(iconname: "circle@2x"), for: .normal)
        self.VollumeSlider.setThumbImage(getIconimage(iconname: "circle@2x"), for: .normal)
        
        videoViewConstraintsheight.constant = frame.size.height
        self.playerLayer.frame = CGRect(x: self.playerLayer.frame.origin.x, y: self.playerLayer.frame.origin.y, width: self.playerLayer.frame.size.width, height: self.videoViewConstraintsheight.constant)
        self.layoutIfNeeded()
        
        view.layoutIfNeeded()
        imgPlayPause.image = getIconimage(iconname: "play")
        imgVolumeSpeaker.image = getIconimage(iconname: "speaker")
        imgbtnQuality.image = getIconimage(iconname: "quality")
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        viewMainPlayer.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnVideoView(_:)))
        viewMainPlayer.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(self.volumeChanged(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    @objc func volumeChanged(notification: NSNotification) {
        
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        self.volume(vol: volume * 100)
    }
    @objc func tappedOnVideoView(_ sender: UITapGestureRecognizer) {
        
        if self.constraintBottomPlayer.constant < 0 {
            
            self.showControls(isAnimated: true)
            
        } else {
            
            self.hideControls(isAnimated: true)
        }
    }
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            lastScale = (gestureRecognizer.view!.layer.value(forKeyPath: "transform.scale")! as! CGFloat)
        }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let currentScale: CGFloat = (viewMainPlayer.layer.value(forKeyPath: "transform.scale")! as! CGFloat)
            let kMaxScale: CGFloat = 2.0
            let kMinScale: CGFloat = 0.5
            var newScale: CGFloat = 1 - (lastScale - gestureRecognizer.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = viewMainPlayer.transform.scaledBy(x: newScale, y: newScale)
            viewMainPlayer.transform = transform
            lastScale = gestureRecognizer.scale
        }
    }
    //MARK: - EVENTS
    public func  E_TvPlayerReady() {
        
        print("E_TvPlayerReady")
        if(player != nil) {
            
            delegate?.tvPlayerReady?(flag: true)
            
        } else {
            
            delegate?.tvPlayerReady?(flag: false)
        }
    }
    public func E_TvPlayerError() {
        
        print("E_TvPlayerError")
        
        if (player?.currentItem?.error != nil) {
            
        }
    }
    public func E_TvPlayerMediaReady()  {
        
        print("E_TvPlayerMediaReady")
        
        E_TvPlayerVideoLoad()
        if playerLayer.player?.status == .readyToPlay {
            
            delegate?.tvPlayerMediaReady?(flag: true)
            
        } else {
            
            delegate?.tvPlayerMediaReady?(flag: false)
        }
    }
    public  func E_TvPlayerMediaError()  {
        
        print("E_TvPlayerMediaError")
    }
    public func E_TvPlayerErrorForbidden() {
        
        print("E_TvPlayerErrorForbidden")
    }
    public func E_TvPlayerErrorHTML5Forbidden() {
        
        print("E_TvPlayerErrorHTML5Forbidden")
    }
    public func E_TvPlayerMediaComplete() {
        
        print("E_TvPlayerMediaComplete")
        delegate?.tvPlayerMediaComplete?(flag: videoEnded)
        
        if isVideoPlayRepeatedely == true {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
                //play
                self.played = true
                self.play()
            }
        }
    }
    public  func E_TvPlayerCued() {
        
        print("E_TvPlayerCued")
        delegate?.tvPlayerCued?(flag: isCued)
    }
    public func E_TvPlayerMediaVideoended() {
        
        print("E_TvPlayerMediaVideoended")
        delegate?.tvPlayerMediaVideoended?(flag: videoEnded)
    }
    public func E_TvPlayerMediaVideoplaying() {
        
        print("E_TvPlayerMediaVideoplaying")
        if player?.rate != 0 {
            
            delegate?.tvPlayerMediaVideoplaying?(flag: true)
            
        } else {
            
            delegate?.tvPlayerMediaVideoplaying?(flag: false)
            
        }
    }
    public func E_TvPlayerMediaVideopaused() {
        
        print("E_TvPlayerMediaVideopaused")
        if player?.rate == 0 {
            
            delegate?.tvPlayerMediaVideopaused?(flag: true)
            
        } else {
            
            delegate?.tvPlayerMediaVideopaused?(flag: false)
        }
    }
    public func E_TvPlayerMediaVideobuffering() {
        
        print("E_TvPlayerMediaVideobuffering")
        delegate?.tvPlayerMediaVideobuffering?(flag: (player?.currentItem?.isPlaybackBufferEmpty)!)
        
    }
    public func E_TvPlayerPlaybackQualityChange(Qname:String){
        
        print("E_TvPlayerPlaybackQualityChange")
        delegate?.tvPlayerPlaybackQualityChange?(flag:Qname )
        
    }
    public func E_TvPlayerMediaProviderChange() {
        
        print("E_TvPlayerMediaProviderChange")
        delegate?.tvPlayerMediaProviderChange?(flag:"CurrentProvider" )
        
    }
    public func E_TvPlayerSeek() {
        
        print("E_TvPlayerSeek")
        
        let currentSecond : CGFloat = CGFloat(playerItem.currentTime().value) / CGFloat(playerItem.currentTime().timescale)
        let timeString: String = self.convertTime(second: currentSecond)
        delegate?.tvPlayerSeek?(flag:timeString )
    }
    public func E_TvPlayerVideoLoad() {
        
        print("E_TvPlayerVideoLoad")
        if playerLayer.player?.status == .readyToPlay {
            
            delegate?.tvPlayerVideoLoad?(flag: true)
            
        } else {
            
            delegate?.tvPlayerVideoLoad?(flag: false)
            
        }
    }
    public func E_TvPlayerVideoCued() {
        
        print("E_TvPlayerVideoCued")
        delegate?.tvPlayerVideoCued?(flag: isCued)
        
    }
    //MARK: - Functions
    @objc func analiticsMethod() {
        
        let uuid = UUID().uuidString
        let cTime:String = "\(getCurrentTime())"
        let duation:String = "\(getDuration())"
        self.analyticsViewTime(loginID: userLoginID, channelID: userChannelID, videoID: userVideoID, sessionID: uuid, currentVideoTime: cTime, videoDuration: duation, viewTime: "3")
    }
    public func loadVideo(StrURL : String , strType : String)  {
        
        userLoginID = ""
        userVideoID = ""
        userChannelID = ""
        stop()
        SetvideoUrl(StrURL: StrURL, strType: strType, isplay: true)
    }
    public func cueVideo(StrURL : String , strType : String)  {
        
        stop()
        SetvideoUrl(StrURL: StrURL, strType: strType, isplay: false)
    }
    @objc func callVVAnaliticsMethod() {
        
        self.analyticsVideoView(loginID: userLoginID, channelID: userChannelID, VideoID: userVideoID)
    }
    @objc public func play()  {
        
        isCued = false
        if isVVanaliticsCall {
            
            isVVanaliticsCall = false
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(callVVAnaliticsMethod), userInfo: nil, repeats: false)
            
        }
        self.player?.play()
        E_TvPlayerCued()
        E_TvPlayerMediaVideoplaying()
        
        if (analiticsTimer == nil) {
            
            analiticsTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(analiticsMethod), userInfo: nil, repeats: true)
            
        }
        imgPlayPause.image = getIconimage(iconname: "pause")
        
    }
    
    @objc public func pause() {
        
        self.player?.pause()
        E_TvPlayerMediaVideopaused()
        imgPlayPause.image = getIconimage(iconname: "play")
        DispatchQueue.main.async {
            if (self.analiticsTimer != nil) {
                self.analiticsTimer.invalidate()
                self.analiticsTimer = nil
            }
        }
        
    }
    public func stop() {
        
        pause()
        videoProgress.setProgress(0.0, animated: true)
        seek(time: 0.0)
        
    }
    public func volume(vol : Float) {
        
        let volummmm = vol / 100
        self.VollumeSlider.value = volummmm
        
        if (self.player != nil) {
            
            self.player?.volume = volummmm
        }
        if volummmm <= 0 {
            
            imgVolumeSpeaker.image = getIconimage(iconname: "mute")
            
        } else {
            
            imgVolumeSpeaker.image = getIconimage(iconname: "speaker")
        }
    }
    public func mute() {
        
        isMuted = true
        self.volume(vol: 0)
        self.VollumeSlider.value = 0
        imgVolumeSpeaker.image = getIconimage(iconname: "mute")
    }
    public func unmute() {
        
        isMuted = false
        imgVolumeSpeaker.image = getIconimage(iconname: "speaker")
        self.volume(vol: AVAudioSession.sharedInstance().outputVolume * 100)
    }
    public func seek(time : Double) {
        
        let preferredTimeScale : Int32 = 1
        let timeing1:CMTime = CMTimeMakeWithSeconds(time, preferredTimeScale)
        player?.seek(to: timeing1)
    }
    public func setPoster(image : UIImage) {
        
        imgPoster.image = image
    }
    public func resize(width : Float, height : Float, X: Float,Y : Float, zoomRatio : Float) {
        
        btnVolume.isHidden = false
        btn_Quality.isHidden = false
        VollumeSlider.isHidden = false
        lbl_Time.isHidden = false
        btn_FullScreen.isHidden = false
        
        if width < 320 {
            
            fix_height_width()
        }
        self.frame = CGRect(x: CGFloat(X), y: CGFloat(Y), width:  CGFloat(width), height:  CGFloat(width))
        self.layoutIfNeeded()
        viewMainPlayer.frame = self.frame
        playerLayer.frame = self.frame
        let transform = viewMainPlayer.transform.scaledBy(x: CGFloat(zoomRatio), y: CGFloat(zoomRatio))
        viewMainPlayer.transform = transform
        playerLayer.videoGravity = AVLayerVideoGravity.resize
    }
    public func fix_height_width() {
        
        btnVolume.isHidden = true
        btn_Quality.isHidden = true
        VollumeSlider.isHidden = true
        lbl_Time.isHidden = true
        btn_FullScreen.isHidden = true
    }
    public func getVolume() -> Int {
        
        let vol : Int = Int((self.player?.volume)!) * 100
        return vol
    }
    
    public func getState() -> Int {
        
        if playerLayer.player?.status != .readyToPlay {
            
            return TVPlayerState.tvPlayerUnstarted.rawValue
            
        } else if videoEnded {
            
            return  TVPlayerState.tvPlayerEnded.rawValue
            
        } else if isCued {
            
            return  TVPlayerState.tvPlayerCued.rawValue
            
        } else if (player?.currentItem?.isPlaybackBufferEmpty)! {
            
            return TVPlayerState.tvPlayerBuffering.rawValue
            
        } else if self.player?.rate == 0.0 {
            
            return  TVPlayerState.tvPlayerPaused.rawValue
            
        } else {
            
            return  TVPlayerState.tvPlayerPlaying.rawValue
        }
    }
    public func getCurrentTime() -> Int {
        
        if let cmTime = self.player?.currentItem?.currentTime() {
            
            let time : Int = Int(CMTimeGetSeconds(cmTime))
            return time
            
        } else {
            
            return 0
        }
    }
    public func getDuration() -> Double {
        
        if let cmTime = self.player?.currentItem?.duration {
            
            let duration : Double = Double(CMTimeGetSeconds(cmTime))
            return duration
            
        } else {
            
            return 0.0
        }
    }
    public func getQuality() -> Int {
        
        return self.qualityIndex
    }
    public func setQuality(index: Int) {
        
        self.qualityIndex = index
    }
    
    func tempSetQuality(indexStr: String) {
        
        let index:Int = Int(indexStr)!
        
        if index < arrQualityString.count{
            self.qualityIndex = index
            
            if self.player?.accessibilityHint == "mp4" {
                
                let videoHD720URL:String = arrQualityID[index].file
                let videoURL = NSURL(string: videoHD720URL )
                self.setTempPlayerValue(videoURL: videoURL! as URL)
                
            } else {
                
                let videoHD720URL:String = arrQualityID[index].url
                let videoURL = NSURL(string: videoHD720URL )
                self.setTempPlayerValue(videoURL: videoURL! as URL)
                
            }
        }
    }
    public func getQualityLevels() -> NSMutableArray {
        //return quality array
        return arrQualityString
    }
    public func getHeight() -> Float {
        
        let height : Float = Float(self.frame.size.height)
        return height
    }
    public func getWidth() -> Float {
        
        let width : Float = Float(self.frame.size.width)
        return width
    }
    public func disableControls()  {
        
        btnVolume.isEnabled = false
        btn_Quality.isEnabled = false
        videoSlider.isEnabled = false
        VollumeSlider.isEnabled = false
        btn_Quality.isEnabled = false
        btn_FullScreen.isEnabled = false
    }
    public  func enableControls()  {
        
        btnVolume.isEnabled = true
        btn_Quality.isEnabled = true
        videoSlider.isEnabled = true
        VollumeSlider.isEnabled = true
        btn_Quality.isEnabled = true
        btn_FullScreen.isEnabled = true
    }
    public func hideControls(isAnimated:Bool) {
        
        if self.constraintBottomPlayer.constant == 0 {
            
            if isAnimated == true {
                
                self.constraintBottomPlayer.constant = -55
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    self.layoutIfNeeded()
                    
                }, completion: {_ in
                    
                })
            } else {
                
                self.constraintBottomPlayer.constant = -55
                self.layoutIfNeeded()
            }
        }
    }
    public func showControls(isAnimated:Bool) {
        
        if self.constraintBottomPlayer.constant != 0 && isVideoReadyToPlay == true {
            
            if isAnimated == true {
                
                self.constraintBottomPlayer.constant = 0
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    
                    self.layoutIfNeeded()
                    
                }, completion: {_ in
                    
                })
                
            } else {
                
                self.constraintBottomPlayer.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
    //MARK:- show Toast Message
    func getIconimage(iconname:String) -> UIImage {
        
        let  bundle = Bundle(url: Bundle.main.url(forResource: "TVPResources", withExtension: "bundle")!)
        var  imagePath: String? = bundle?.path(forResource: iconname, ofType: "png")
        var  image = UIImage()
        if imagePath != nil {
            
            image = UIImage(contentsOfFile: imagePath!)!
            
        } else {
            
            imagePath = bundle?.path(forResource: "placeholder", ofType: "png")
            image = UIImage(contentsOfFile: imagePath!)!
        }
        
        return image
    }
    //MARK: -  Analytics
    func Analytics_Channel_Impression(LoginID:String){
        
        if LoginID != "" {
            
            let strURL = ("https://api.tvpage.com/v1/__tvpa.gif?li=\(LoginID)&X-login-id=\(LoginID)&rt=ci")
            let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 180.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    
                } else {
                    
                    _ = response as? HTTPURLResponse
                }
            })
            dataTask.resume()
        }
    }
    func analyticsVideoView(loginID:String,channelID:String,VideoID:String) {
        
        if loginID != "" {
            
            let strURL = ("https://api.tvpage.com/v1/__tvpa.gif?li=\(loginID)&X-login-id=\(loginID)&pg=\(channelID)&vd=\(VideoID)&rt=vv")
            let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 180.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    
                } else {
                    
                    _ = response as? HTTPURLResponse
                }
            })
            dataTask.resume()
        }
    }
    func analyticsViewTime(loginID:String,channelID:String,videoID:String,sessionID:String,currentVideoTime:String,videoDuration:String,viewTime:String) {
        
        if loginID != "" {
            
            // https://api.tvpage.com/v1/__tvpa.gif?li=1758381&X-login-id=1758381&pg=&vd=&vvs=&vct=&vdr=&vt=
            let strURL = ("https://api.tvpage.com/v1/__tvpa.gif?li=\(loginID)&X-login-id=\(loginID)&pg=\(channelID)&vd=\(videoID)&vvs=\(sessionID)&vct=\(currentVideoTime)&vdr=\(videoDuration)&vt=\(viewTime)&rt=vt")
            let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 180.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    
                } else {
                    
                    _ = response as? HTTPURLResponse
                }
            })
            dataTask.resume()
        }
    }
    public func analyticsProductImpression(loginID:String,channelID:String,videoID:String,productID:String, completion : ((String)->())?){
        
        if loginID != "" {
            
            let strURL = ("https://api.tvpage.com/v1/__tvpa.gif?li=\(loginID)&X-login-id=\(loginID)&pg=\(channelID)&vd=\(videoID)&ct=\(productID)&rt=pi")
            let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 180.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                var errorStr = ""
                if (error != nil) {
                    
                    errorStr = (error?.localizedDescription)!
                    if completion != nil {
                        
                        let isVideoPlayerOpen = UserDefaults.standard.object(forKey: "isVideoPlayerOpen") as! String
                        UserDefaults.standard.synchronize()
                        
                        if isVideoPlayerOpen == "YES" {
                            
                            completion!(errorStr)
                        } else {
                            
                        }
                    }
                } else {
                    
                    _ = response as? HTTPURLResponse
                    if completion != nil {
                        
                        let isVideoPlayerOpen = UserDefaults.standard.object(forKey: "isVideoPlayerOpen") as! String
                        UserDefaults.standard.synchronize()
                        
                        if isVideoPlayerOpen == "YES" {
                            
                            completion!(errorStr)
                            
                        } else {
                            
                        }
                    }
                }
            })
            dataTask.resume()
        }
    }
    public func analyticsProductClick(loginID:String,channelID:String,videoID:String,productID:String, completion : ((String)->())?) {
        
        self.played = false
        if loginID != "" {
            
            let strURL = ("https://api.tvpage.com/v1/__tvpa.gif?li=\(loginID)&X-login-id=\(loginID)&pg=\(channelID)&vd=\(videoID)&ct=\(productID)&rt=pk")
            
            let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 180.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                var errorStr = ""
                
                if (error != nil) {
                    
                    errorStr = (error?.localizedDescription)!
                    if completion != nil {
                        
                        completion!(errorStr)
                        
                    }
                } else {
                    
                    _ = response as? HTTPURLResponse
                    if completion != nil {
                        
                        completion!(errorStr)
                    }
                }
            })
            dataTask.resume()
        }
    }
    func getAutoNetworkStreming() -> Int {
        
        let strNetworkType = HelperObjC.getNewtworkType()
        
        var autoNetworkStreming = 0
        
        if self.arrQualityID.count > 0 {
            
            if strNetworkType == "NoWifiOrCellular" || strNetworkType == "2G" || strNetworkType == "" {
                
                autoNetworkStreming = self.arrQualityID.count - 1
                
            } else if strNetworkType == "3G" {
                
                if self.arrQualityID.count > 1 {
                    
                    autoNetworkStreming = 1
                    
                } else {
                    
                    autoNetworkStreming = 0
                }
                
            } else if strNetworkType == "4G" || strNetworkType == "Wifi" || strNetworkType == "LTE" {
                
                autoNetworkStreming = 0
            }
        }
        
        return autoNetworkStreming
    }
    //MARK: - Application enter background / foreground
    @objc func applicationDidEnterBackground() {
        
        self.pause()
    }
    @objc func applicationWillEnterForeground() {
        
        if played == true {
            //Play
            self.play()
            
        } else {
            //Pause
            self.pause()
        }
    }
    override public func removeFromSuperview() {
        
        self.stopPlayer()
    }
    public func stopPlayer() {
        
        if isVideoOpenFullScreen == false {
            
            // Stop listening notification
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil);
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil);
            
            isViewRemoved = true
            UserDefaults.standard.setValue("NO", forKey: "isVideoPlayerOpen")
            UserDefaults.standard.synchronize()
            self.pause()
            self.played = false
        }
    }
    public func resumePlayer() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(TVPagePlayerView.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TVPagePlayerView.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        isViewRemoved = false
        UserDefaults.standard.setValue("YES", forKey: "isVideoPlayerOpen")
        UserDefaults.standard.synchronize()
    }
}

