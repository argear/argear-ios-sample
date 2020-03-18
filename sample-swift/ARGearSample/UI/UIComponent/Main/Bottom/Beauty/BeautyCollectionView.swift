//
//  BeautyCollectionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class BeautyCollectionView: ARGBottomFunctionBaseCollectionView {

    let kBeautyCellNibName = "BeautyCollectionViewCell"
    let kBeautyCellIdentifier = "beautycell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconNames = [
            "icVline",
            "icFacewidth",
            "icFacelength",
            "icChinlength",
            "icEyesize",
            "icEyewidth",
            "icNosenarrow",
            "icAla",
            "icNoselength",
            "icMouthsize",
            "icEyeback",
            "icEyeangle",
            "icLips",
            "icSkin",
            "icDarkcircle",
            "icWrinkle"
        ]
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: kBeautyCellNibName, bundle: nil), forCellWithReuseIdentifier: kBeautyCellIdentifier)
    }
}

extension BeautyCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            if selectedIndexPath == indexPath {
                return
            }
        }
        
        self.selectedIndexPath = indexPath
        self.reloadData()
    }
}

extension BeautyCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let beautyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kBeautyCellIdentifier, for: indexPath) as! BeautyCollectionViewCell
        
        beautyCell.beautyImage.image = UIImage(named: self.getIconName(index: indexPath.row, withLanguageCode: true))
        
        return beautyCell
    }
}
