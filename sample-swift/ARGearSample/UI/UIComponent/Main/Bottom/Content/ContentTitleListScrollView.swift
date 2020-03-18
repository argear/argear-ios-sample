//
//  ContentTitleListScrollView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/31.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ContentTitleListScrollView: UIScrollView , UIScrollViewDelegate{
    
    let STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_DISABLE_BUTTON_TEXTCOLOR = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    let STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_ENABLE_BUTTON_TEXTCOLOR = UIColor.white
    
    let STICKER_TITLE_LIST_SCROLLVIEW_DISABLE_BUTTON_TEXTCOLOR = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    let STICKER_TITLE_LIST_SCROLLVIEW_ENABLE_BUTTON_TEXTCOLOR = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    let STICKER_TITLE_LIST_SCROLLVIEW_SHADOW_COLOR = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    var contents: [Category]? {
        didSet {
            guard let contents = contents else {
                return
            }
            
            var titles = [String]()
            for content in contents {
                if let title = content.title {
                    titles.append(title)
                }
            }
            self.titles = titles
        }
    }
    
    var titles: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.setTitleButtons()
                self.setTitleColor()
            }
        }
    }
    var titleButtons = [UIButton]()
    
    @objc dynamic var selectedIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        self.tag = ratio.rawValue
        self.setTitleColor()
    }
    
    func setTitleButtons() {
        guard let titles = self.titles
            else { return }
        
        for button in titleButtons {
            button.removeFromSuperview()
        }
        
        titleButtons.removeAll()
        
        var pointX: CGFloat = 0
        for (index, title) in titles.enumerated() {
            let font = UIFont(name: "NotoSansKR-Regular", size: 13.0)
            let button = UIButton(type: .custom)
            button.backgroundColor = UIColor.clear
            button.titleLabel?.font = font
            button.setTitleColor(STICKER_TITLE_LIST_SCROLLVIEW_DISABLE_BUTTON_TEXTCOLOR, for: .normal)
            button.setTitle(title, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            button.sizeToFit()
            button.frame = CGRect(x: pointX, y: 0, width: button.frame.width + 27, height: 54)
            button.tag = index
            button.addTarget(self, action: #selector(titleButtonAction(_:)), for: .touchUpInside)
            
            self.contentView.addSubview(button)
            pointX += button.frame.width
            
            self.titleButtons.append(button)
        }
        self.contentViewWidth.constant = pointX
    }
    
    func setTitleColor() {
        for (index, button) in titleButtons.enumerated() {
            var disableColor = UIColor.clear
            var enableColor = UIColor.clear
            var shadowColor = UIColor.clear
            
            if self.tag == ARGMediaRatio._16x9.rawValue {
                disableColor = STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_DISABLE_BUTTON_TEXTCOLOR
                enableColor = STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_ENABLE_BUTTON_TEXTCOLOR
                shadowColor = STICKER_TITLE_LIST_SCROLLVIEW_SHADOW_COLOR
            } else {
                disableColor = STICKER_TITLE_LIST_SCROLLVIEW_DISABLE_BUTTON_TEXTCOLOR
                enableColor = STICKER_TITLE_LIST_SCROLLVIEW_ENABLE_BUTTON_TEXTCOLOR
            }
            
            var font = UIFont(name: "NotoSansKR-Regular", size: 13.0)
            button.setTitleColor(disableColor, for: .normal)
            if index == selectedIndex {
                font = UIFont(name: "NotoSansKR-Bold", size: 13.0)
                button.setTitleColor(enableColor, for: .normal)
            }
            button.titleLabel?.font = font
            
            button.titleLabel?.layer.shadowOffset = CGSize.zero
            button.titleLabel?.layer.shadowRadius = 1.0
            button.titleLabel?.layer.shadowOpacity = 0.5
            button.titleLabel?.layer.masksToBounds = false
            button.titleLabel?.layer.shouldRasterize = true
            button.titleLabel?.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    func scrollToIndex() {
        let button = titleButtons[selectedIndex]
        
        var offsetX = button.frame.origin.x - self.frame.size.width/2 + button.frame.size.width/2
        let right = self.contentSize.width - (button.frame.origin.x + button.frame.size.width)
        let left = button.frame.origin.x - button.frame.size.width/2

        if (left < self.frame.size.width/2 - button.frame.size.width/2) {
            offsetX = 0
        } else if (right < (self.frame.size.width/2 - button.frame.size.width/2)) {
            offsetX = self.contentSize.width - self.frame.width
        }
        
        self.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    @objc
    func titleButtonAction(_ sender: UIButton) {
        self.changeIndex(sender.tag)
    }
    
    func changeIndex(_ index: Int) {
        if self.selectedIndex == index {
            return
        }
        self.selectedIndex = index
        
        self.setTitleColor()
        self.scrollToIndex()
    }
}
