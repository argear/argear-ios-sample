//
//  ContentsSlotCollectionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/06.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

class ContentsSlotCollectionView: UICollectionView {
    
    let kContentsSlotCellNibName = "ContentsSlotCollectionViewCell"
    let kContentsSlotCellIdentifier = "contentsslotcell"

    @objc dynamic var selectedIndexPath: IndexPath?
    
    var contents: [Item]? {
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
        
        self.register(UINib(nibName: kContentsSlotCellNibName, bundle: nil), forCellWithReuseIdentifier: kContentsSlotCellIdentifier)
    }
    
    func clearContent() {
        self.selectedIndexPath = nil
        self.reload()
    }
    
    func reload() {
        self.reloadData()
    }
}

extension ContentsSlotCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let contents = self.contents {
            let content = contents[indexPath.row]
            
            if contents[indexPath.row].uuid == ContentManager.shared.selectedContentId {
                return
            }
            
            ContentManager.shared.setContent(content, successBlock: { [weak self] in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.selectedIndexPath = indexPath
                    self.reload()
                }
            }) {
            }
        }
    }
}

extension ContentsSlotCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let contents = self.contents {
            return contents.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contentsCell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentsSlotCellIdentifier, for: indexPath) as! ContentsSlotCollectionViewCell
        
        contentsCell.unchecked()
        
        if let contents = self.contents {
            contentsCell.setContent(contents[indexPath.row])
            
            if contents[indexPath.row].uuid == ContentManager.shared.selectedContentId {
                contentsCell.checked()
            }
        }
        return contentsCell
    }
}
