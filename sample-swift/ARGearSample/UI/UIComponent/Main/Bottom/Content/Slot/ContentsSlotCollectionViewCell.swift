//
//  ContentsSlotCollectionViewCell.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/06.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

class ContentsSlotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsImage: UIImageView!
    @IBOutlet weak var contentsCheckImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func checked() {
        self.contentsCheckImage.isHidden = false
    }
    
    func unchecked() {
        self.contentsCheckImage.isHidden = true
    }
    
    func setContent(_ content: Item) {
        guard
            let thumbnailUrl = content.thumbnail
            else {
                return
        }

        self.contentsImage.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: nil, options: [.refreshCached], completed: nil)
    }
}
