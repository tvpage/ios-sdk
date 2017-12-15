//
//  CellVideoList.swift
//  TVPagePhase2
//

import UIKit

class CellVideoList: UICollectionViewCell {

    //MARK: - IBOutlet
    @IBOutlet var viewContent: UIView!
    @IBOutlet var imgPlaceholder: UIImageView!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var imgPlay: UIImageView!
    @IBOutlet var lblVideoContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

