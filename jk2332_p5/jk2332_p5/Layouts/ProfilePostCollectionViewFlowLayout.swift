//
//  FilterCollectionViewFlowLayout.swift
//  Project6solutions
//
//  Created by Natasha Armbrust on 11/6/17.
//  Copyright © 2017 Natasha Armbrust. All rights reserved.
//

import UIKit

class ProfilePostCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let cellWidth: CGFloat = 140
    let cellHeight: CGFloat = 140
    
    override func prepare() {
        super.prepare()
//        let edgeInset = (UIScreen.main.bounds.width - 2 * cellWidth) / 3
        let edgeInset:CGFloat = 20
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        minimumLineSpacing = edgeInset/2
        minimumInteritemSpacing = edgeInset
//        sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        sectionInset = UIEdgeInsets(top: 0, left: edgeInset, bottom: 0, right: edgeInset)
        scrollDirection = .horizontal
    }
}

