

import UIKit

//MARK: - UIViewController
class HomeVC: UIViewController {

    //TODO: - Variable Declaration
    
    //TODO: - Outlet Declaration
    
    //TODO: - View Controller Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK: - Common Methods
extension HomeVC {
 
    //Redirect To Widget Screen
    func redirectToWidgetScreen(type:WidgetType) {
        
        let sideMenu:SideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        sideMenu.widgetType = type
        self.navigationController?.pushViewController(sideMenu, animated: true)
    }
}
//MARK: - IBAction
extension HomeVC {
    
    @IBAction func tappedOnSidebar(_ sender: Any) {
        
        //Redirect To Widget Screen
        self.redirectToWidgetScreen(type: .sidebar)
    }
    @IBAction func tappedOnSolo(_ sender: Any) {
        
        //Redirect To Widget Screen
        self.redirectToWidgetScreen(type: .solo)
    }
    @IBAction func tappedOnCarousel(_ sender: Any) {
        
        //Redirect To Widget Screen
        self.redirectToWidgetScreen(type: .carousel)
    }
    @IBAction func tapedOnVideoGallery(_ sender: Any) {
        
        //Redirect To Video Gallery Screen
        self.redirectToWidgetScreen(type: .videoGallery)
    }
}
//MARK: Widget Type
enum WidgetType {
    
    case sidebar
    case solo
    case carousel
    case videoGallery
    case none
}
