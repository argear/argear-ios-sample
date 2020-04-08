//
//  BulgeCollectionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/31.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class BulgeCollectionView: ARGBottomFunctionBaseCollectionView {
    
    let kBulgeCellNibName = "BulgeCollectionViewCell"
    let kBulgeCellIdentifier = "bulgecell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconNames = [
            "icDisabled",
            "icFun1",
            "icFun2",
            "icFun3",
            "icFun4",
            "icFun5",
            "icFun6"
        ]
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: kBulgeCellNibName, bundle: nil), forCellWithReuseIdentifier: kBulgeCellIdentifier)
        
        self.selectedIndexPath = IndexPath(row: 0, section: 0)
    }
    
    func reload() {
        self.reloadData()
    }
}

extension BulgeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            if selectedIndexPath == indexPath {
                return
            }
        }
        
        self.selectedIndexPath = indexPath
        self.reload()
    }
}

extension BulgeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bulgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: kBulgeCellIdentifier, for: indexPath) as! BulgeCollectionViewCell
        
        bulgeCell.bulgeImage.image = UIImage(named: self.getIconName(index: indexPath.row, withLanguageCode: false))
        
        return bulgeCell
    }
}
