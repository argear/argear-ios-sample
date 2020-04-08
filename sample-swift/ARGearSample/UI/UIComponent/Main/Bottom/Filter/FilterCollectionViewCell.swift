//
//  FilterCollectionViewCell.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear
import SDWebImage

class FilterCollectionViewCell: UICollectionViewCell {
    
    let FILTER_CHECKED_FULLRATIO_COLOR = UIColor.white
    let FILTER_UNCHECKED_FULLRATIO_COLOR = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    let FILTER_CHECKED_COLOR = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    let FILTER_UNCHECKED_COLOR = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var filterCheckImage: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        var textColor = UIColor.clear
        var shadowColor = UIColor.clear
        
        if ratio == ._16x9 {
            textColor = filterCheckImage.isHidden ? FILTER_UNCHECKED_FULLRATIO_COLOR : FILTER_CHECKED_FULLRATIO_COLOR
            shadowColor = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)
        } else {
            textColor = filterCheckImage.isHidden ? FILTER_UNCHECKED_COLOR : FILTER_CHECKED_COLOR
        }
        
        self.filterNameLabel.textColor = textColor
        
        self.filterNameLabel.layer.shadowOffset = CGSize.zero
        self.filterNameLabel.layer.shadowRadius = 1.0
        self.filterNameLabel.layer.shadowOpacity = 0.5
        self.filterNameLabel.layer.masksToBounds = false
        self.filterNameLabel.layer.shouldRasterize = true
        self.filterNameLabel.layer.shadowColor = shadowColor.cgColor
    }
    
    func checked() {
        self.filterCheckImage.isHidden = false
        filterNameLabel.isHidden = false
    }
    
    func unchecked() {
        self.filterCheckImage.isHidden = true
        filterNameLabel.isHidden = false
    }
    
    func disableButtonCell(ratio: ARGMediaRatio) {
        filterCheckImage.isHidden = true
        filterNameLabel.isHidden = true
        
        var iconName = "icDisabledBlackOff"
        if ratio == ._16x9 {
            iconName = "icDisabledWhiteOff"
        }
        
        filterImage.image = UIImage(named: iconName)
    }
    
    func setFilter(_ filter: Item) {
        guard
            let title = filter.title,
            let thumbnailUrl = filter.thumbnail
            else {
                return
        }
        
        self.filterNameLabel.text = title
        self.filterImage.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: nil, options: [.refreshCached], completed: nil)
    }
}
