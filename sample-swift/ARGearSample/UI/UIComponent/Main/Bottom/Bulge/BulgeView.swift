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
        
        var isStartBulge = true
        if let selectedBulge = self.bulgeCollectionView.selectedIndexPath {
            if selectedBulge.row == 0 {
                isStartBulge = false
            } else {
                BulgeManager.shared.setFunMode(ARGContentItemBulge(rawValue: selectedBulge.row)!)
            }
        }
        
        if isStartBulge {
            BulgeManager.shared.on()
        }
    }
    
    override func close() {
        super.close()
        
        BulgeManager.shared.off()
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
                        BulgeManager.shared.on()
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
