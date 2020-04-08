//
//  ContentsCollectionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/31.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ContentsCollectionView: ARGBottomFunctionBaseCollectionView {
    
    let kContentsCellNibName = "ContentsCollectionViewCell"
    let kContentsCellIdentifier = "contentscell"
    
    var contents: [Category]? {
        didSet {
            guard let _ = contents else {
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
        
        self.register(UINib(nibName: kContentsCellNibName, bundle: nil), forCellWithReuseIdentifier: kContentsCellIdentifier)
    }
    
    override func setRatio(_ ratio: ARGMediaRatio) {
        self.tag = ratio.rawValue
    }
    
    func reload() {
        self.reloadData()
    }
    
    func clearContent() {
        if
            let indexPath = self.selectedIndexPath,
            let contentsCell: ContentsCollectionViewCell = self.cellForItem(at: indexPath) as? ContentsCollectionViewCell {
            contentsCell.contentsSlotCollectionView.clearContent()
        }
    }
    
    func scrollToIndex() {
        guard let indexPath = self.selectedIndexPath
            else { return }
        
        self.setContentOffset(CGPoint(x: self.frame.width * CGFloat(indexPath.row), y: 0), animated: true)
    }
    
    func changeIndex(_ indexPath: IndexPath) {
        if self.selectedIndexPath == indexPath {
            return
        }
        self.selectedIndexPath = indexPath
        
        self.scrollToIndex()
    }
}

extension ContentsCollectionView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let expectedOffset = targetContentOffset.pointee.x
        let pageIndex = Int(expectedOffset/self.frame.width)
        
        self.selectedIndexPath = IndexPath(row: pageIndex, section: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let contentsCell = cell as? ContentsCollectionViewCell {
            contentsCell.contentsSlotCollectionView.reload()
        }
    }
}

extension ContentsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let contents = self.contents {
            return contents.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentsCellIdentifier, for: indexPath) as! ContentsCollectionViewCell
        
        if let contents = self.contents {
            contentCell.setContents(contents[indexPath.row])
        }
        return contentCell
    }
}

extension ContentsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
}
