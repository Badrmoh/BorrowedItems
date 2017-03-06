//
//  CalenderBox.swift
//  BorrowedItems
//
//  Created by Badr  on 22/01/2017.
//  Copyright © 2017 Badr. All rights reserved.
//

import UIKit
@IBDesignable
class CalenderBox: UIView {

    
    private var materialkey = false
    
    @IBInspectable var colorSelection : UIColor = .black {
        didSet{
            updateAppearance()
        }
    }
    @IBInspectable var MaterialDesign: Bool {
        
        get{
            return materialkey
        }
        
        set{
            materialkey = newValue
            
            if materialkey{
                updateAppearance()
            } else {
                self.layer.cornerRadius = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowColor = nil
            }
        }
    }
    
    private func updateAppearance() {
        self.backgroundColor = colorSelection
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 9.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 7.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
}



