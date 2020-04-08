//
//  BulgeView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/21.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class BulgeView: ARGBottomFunctionBaseView {
    
    @IBOutlet weak var bulgeCollectionView: BulgeCollectionView!
    
    private var observers = [NSKeyValueObservation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    override func open() {
        super.open()
        
        ContentManager.shared.clearContent()
        
        if BulgeManager.shared.mode == .NONE {
            bulgeCollectionView.selectedIndexPath = IndexPath(row: 0, section: 0)
        }
        bulgeCollectionView.reload()
    }
    
    override func close() {
        super.close()
    }
    
    override func setRatio(_ ratio: ARGMediaRatio) {
        super.setRatio(ratio)

        self.bulgeCollectionView.setRatio(ratio)
    }
    
    func addObservers() {
        self.observers.append(
            self.bulgeCollectionView.observe(\.selectedIndexPath, options: .new) { _, change in

                if let indexPath = change.newValue as? IndexPath {
                    if indexPath.row == 0 {
                        BulgeManager.shared.off()
                    } else {
                        BulgeManager.shared.setFunMode(ARGContentItemBulge(rawValue: indexPath.row)!)
                    }
                }
            }
        )
    }
    
    func removeObservers() {
        self.observers.removeAll()
    }
}
