//
//  CellProduct.swift
//  TVPagePhase2
//

import UIKit

class CellProduct: UICollectionViewCell {

    //MARK: - IBOutlet Declaration
    @IBOutlet var viewContainer: UIView!
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
