//
//  DisplayRestaurantsCollectionViewFlowLayout.swift
//  Project6solutions
//
//  Created by Natasha Armbrust on 11/6/17.
//  Copyright © 2017 Natasha Armbrust. All rights reserved.
//

import UIKit

class PostCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let cellWidth: CGFloat = 300
    let cellHeight: CGFloat = 160
    
    override func prepare() {
        super.prepare()
//        let edgeInset = (UIScreen.main.bounds.width - 2 * cellWidth) / 3
        let edgeInset = (UIScreen.main.bounds.width - cellWidth) / 2
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        minimumLineSpacing = edgeInset/2
        minimumInteritemSpacing = edgeInset
        sectionInset = UIEdgeInsets(top: edgeInset/4, left: edgeInset, bottom: 0, right: edgeInset)
    }
}

