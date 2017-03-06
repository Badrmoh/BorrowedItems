//
//  RatingStars.swift
//  BorrowedItems
//
//  Created by Badr  on 22/01/2017.
//  Copyright © 2017 Badr. All rights reserved.
//

import UIKit
@IBDesignable
class RatingStars: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setButtons()
    }
    
    var starButtons = [UIButton]()
    var rating: Int = 0 {
        didSet{
            updateButtonAppearance()
        }
    }
    @IBInspectable var size:CGSize = CGSize(width: 25.0, height: 25.0){
        didSet{
            setButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setButtons()
        }
    }
    
    private func setButtons() {
        
        //Clear buttons
        for button in starButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
            
        }
        starButtons.removeAll()
        
        //Load buttons images
        let bundle = Bundle(for: type(of:self))
        let selectedStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)

        
        //Create new buttons
        for _ in 0..<starCount {
            
            let button = UIButton()
            
            //Assign buttons images
            button.setImage(selectedStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(emptyStar, for: .normal)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //set buttons size and scale
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            
            
            
            
            //add action
            button.addTarget(self, action: #selector(RatingStars.starPressed(button:)), for: .touchUpInside)
            
            starButtons.append(button)
            
            addArrangedSubview(button)
        }
        updateButtonAppearance()
    }
    
    func starPressed(button: UIButton){
        guard let index = starButtons.index(of: button) else {
            fatalError("Button is out of range")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    func updateButtonAppearance() {
        for (index, button) in starButtons.enumerated() {
            
            button.isSelected = index < rating
        }
    }
    
    private func clearButtons(){
        self.removeFromSuperview()
    }

}
