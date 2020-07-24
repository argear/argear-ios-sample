//
//  FilterCollectionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class FilterCollectionView: ARGBottomFunctionBaseCollectionView {
    
    let kFilterCellNibName = "FilterCollectionViewCell"
    let kFilterCellIdentifier = "filtercell"
    
    var filters: [Item]? {
        didSet {
            guard let _ = filters else {
                return
            }
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: kFilterCellNibName, bundle: nil), forCellWithReuseIdentifier: kFilterCellIdentifier)
    }

}

extension FilterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            if selectedIndexPath == indexPath {
                return
            }
        }
        
        if indexPath.row == 0 {
            FilterManager.shared.clearFilter()
            return
        }
        
        if let filters = filters {
            let filter = filters[indexPath.row - 1]
            
            FilterManager.shared.setFilter(filter, successBlock: { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.selectedIndexPath = indexPath
                    self.reloadData()
                }
            }) {
            }
        }
    }
}

extension FilterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filters = self.filters {
            return filters.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: kFilterCellIdentifier, for: indexPath) as! FilterCollectionViewCell
        
        if indexPath.row == 0 {
            filterCell.disableButtonCell(ratio: ARGMediaRatio(rawValue: self.tag)!)
            return filterCell
        }
        
        filterCell.unchecked()
        if indexPath == self.selectedIndexPath {
            filterCell.checked()
        }
        
        if let filters = self.filters {
            filterCell.setFilter(filters[indexPath.row - 1])
            filterCell.setRatio(ARGMediaRatio(rawValue: self.tag)!)
        }
        return filterCell
    }
}
