//
//  FilterCollectionViewCell.swift
//  Project6solutions
//
//  Created by Natasha Armbrust on 11/6/17.
//  Copyright © 2017 Natasha Armbrust. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    var filterLabel: UILabel!
    var unselectedColor: UIColor = .white
    var selectedColor: UIColor = UIColor(red: 0.341, green: 0.612, blue: 0.529, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        filterLabel = UILabel(frame: bounds)
        filterLabel.textAlignment = .center
        filterLabel.font = .systemFont(ofSize: 14)
        filterLabel.textColor = .white
        layer.cornerRadius = 5
        layer.borderColor = selectedColor.cgColor
        layer.borderWidth = 1.0;
        backgroundColor = UIColor(red: 0.341, green: 0.612, blue: 0.529, alpha: 1)
        contentView.addSubview(filterLabel)
        isSelected = false
    }
    
    func setup(for tag: Tag) {
        filterLabel.text = tag.tagName
    }
    
    //when a cell is selected, we change the background / text color here to reflect the selected
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            if isSelected {
                backgroundColor = selectedColor
                filterLabel.textColor = unselectedColor
            } else {
                backgroundColor = unselectedColor
                filterLabel.textColor = selectedColor
            }
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


