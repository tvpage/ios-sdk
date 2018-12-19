

import UIKit

class ProductDetailVC: MTViewController {
    
    @IBOutlet var imgShop: UIImageView!
    @IBOutlet var imgSearch: UIImageView!
    @IBOutlet var imgHeaderLogo: UIImageView!
    @IBOutlet var imgMenu: UIImageView!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var WebViewobj: UIWebView!
    @IBOutlet var btnBack: UIControl!
    var detailUrl:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebViewobj.loadRequest(URLRequest(url: URL(string: detailUrl)!))
        
        //Set Default Images
        setImages()
        
        //Change statusbar color
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        
    }
    func setImages(){
        imgMenu.image = self.getIconimage(iconname: "imgMenuMaterial")
        imgHeaderLogo.image = self.getIconimage(iconname: "imgHeaderLogo")
        imgSearch.image = self.getIconimage(iconname: "imgHeaderSearch")
        imgShop.image = self.getIconimage(iconname: "imgHeaderShop")
        imgBack.image = self.getIconimage(iconname: "leftArrow")
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
}

