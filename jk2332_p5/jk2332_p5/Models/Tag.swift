//
//  Restaurant.swift
//  jk2332_p5
//
//  Created by 김지원 on 4/14/19.
//  Copyright © 2019 김지원. All rights reserved.
//

import Foundation
import UIKit

struct Tag: Codable{
    
    var tagName: String
    var choosen : Bool

    
    init(name: String){
        tagName = name
        choosen = false
    }
}

