
import UIKit

class CellProduct: UICollectionViewCell {

    //MARK: - IBOutlet Declaration
    @IBOutlet var viewMainContainer: UIView!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var viewContainerTop: NSLayoutConstraint!
    @IBOutlet var viewContainerBottom: NSLayoutConstraint!
    @IBOutlet var viewContainerLeading: NSLayoutConstraint!
    @IBOutlet var viewContainerTrailing: NSLayoutConstraint!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var imgPlaceholder: UIImageView!
    @IBOutlet var imgProducts: UIImageView!
    @IBOutlet var viewRateBG: UIView!
    @IBOutlet var viewRatings: RateView!
    @IBOutlet var lblRatings: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var btnViewDetails: UIControl!
    @IBOutlet var lblViewDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
