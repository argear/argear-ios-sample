//
//  ARGBottomFunctionBaseCollectionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/31.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ARGBottomFunctionBaseCollectionView: UICollectionView {
    
    var iconNames = [String]()
    
    @objc dynamic var selectedIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        self.tag = ratio.rawValue
        self.reloadData()
    }
    
    func getIconName(index: Int, withLanguageCode: Bool) -> String {
        
        var iconName = iconNames[index]
        
        if self.tag == ARGMediaRatio._16x9.rawValue {
            iconName.append("White")
        } else {
            iconName.append("Black")
        }
        
        if let indexPath = self.selectedIndexPath {
            if index != indexPath.row {
                iconName.append("Off")
            }
        } else {
            iconName.append("Off")
        }
        
        if withLanguageCode {
            iconName.append("_".appendLanguageCode())
        }
        
        return iconName;
    }
}
