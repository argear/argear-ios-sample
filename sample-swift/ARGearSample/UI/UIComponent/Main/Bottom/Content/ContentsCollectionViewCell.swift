//
//  ContentsCollectionViewCell.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/31.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ContentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsSlotCollectionView: ContentsSlotCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
    }
    
    func setContents(_ contents: Category) {
        self.contentsSlotCollectionView.isHidden = false
        
        self.contentsSlotCollectionView.contents = Array(contents.items)
    }
}
