
import UIKit

class CellCarouselVideoList: UICollectionViewCell {

    //MARK: - IBOutlet
    @IBOutlet var viewContent: UIView!
    @IBOutlet var imgPlaceholder: UIImageView!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var viewImageOverlay: UIView!
    @IBOutlet var ViewPlay: UIView!
    @IBOutlet var imgPlay: UIImageView!
    @IBOutlet var lblVideoContent: UILabel!
    @IBOutlet var constraintLblVideoContentLeading: NSLayoutConstraint!
    @IBOutlet var constraintLblVideoContentTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
