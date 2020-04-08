//
//  ContentView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/21.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ContentView: ARGBottomFunctionBaseView {
    
    let kContentViewClearButtonName = "icDisabled"
    
    @IBOutlet weak var contentTitleListScrollView: ContentTitleListScrollView!
    @IBOutlet weak var contentsCollectionView: ContentsCollectionView!
    @IBOutlet weak var clearButton: UIButton!
    
    private var observers = [NSKeyValueObservation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentsCollectionView.selectedIndexPath = IndexPath(row: 0, section: 0)
        
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    override func setRatio(_ ratio: ARGMediaRatio) {
        super.setRatio(ratio)
        
        self.setButtons(ratio: ratio)
        self.contentTitleListScrollView.setRatio(ratio)
        self.contentsCollectionView.setRatio(ratio)
    }
    
    override func open() {
        super.open()
        
        BulgeManager.shared.off()
        
        contentsCollectionView.reload()
    }
    
    func setButtons(ratio: ARGMediaRatio) {
        var clearButtonImageName = kContentViewClearButtonName
        if self.tag == ARGMediaRatio._16x9.rawValue {
            clearButtonImageName.append("White")
        } else {
            clearButtonImageName.append("Black")
        }
        clearButtonImageName.append("Off")
        
        self.clearButton.setImage(UIImage(named: clearButtonImageName), for: .normal)
    }
    
    func addObservers() {
        self.observers.append(
            self.contentTitleListScrollView.observe(\.selectedIndex, options: .new) { [weak self] _, change in
                guard let self = self else { return }

                if let index = change.newValue {
                    self.contentsCollectionView.changeIndex(IndexPath(row: index, section: 0))
                }
            }
        )
        
        self.observers.append(
            self.contentsCollectionView.observe(\.selectedIndexPath, options: .new) { [weak self] _, change in
                guard let self = self else { return }

                if let indexPath = change.newValue as? IndexPath {
                    self.contentTitleListScrollView.changeIndex(indexPath.row)
                }
            }
        )
    }
    
    func removeObservers() {
        self.observers.removeAll()
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        self.contentsCollectionView.clearContent()
        ContentManager.shared.clearContent()
    }
}
