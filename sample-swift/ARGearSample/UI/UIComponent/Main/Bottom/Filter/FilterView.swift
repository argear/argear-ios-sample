//
//  FilterView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/21.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class FilterView: ARGBottomFunctionBaseView {
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var filterCollectionView: FilterCollectionView!
    
    private var observers = [NSKeyValueObservation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let sliderThumb = UIImage(named: "bttnControl.png")
        self.slider.setThumbImage(sliderThumb, for: .normal)
        self.slider.setThumbImage(sliderThumb, for: .highlighted)
        
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    override func setRatio(_ ratio: ARGMediaRatio) {
        super.setRatio(ratio)
        
        self.filterCollectionView.setRatio(ratio)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        FilterManager.shared.setFilterLevel(sender.value)
    }
    
    func addObservers() {
        self.observers.append(
            self.filterCollectionView.observe(\.selectedIndexPath, options: .new) { [weak self] _, change in
                guard let self = self else { return }
                
                self.slider.value = 1.0
            }
        )
    }
    
    func removeObservers() {
        self.observers.removeAll()
    }
}
