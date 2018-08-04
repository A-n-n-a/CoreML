//
//  Record.swift
//  PicRecognition
//
//  Created by Anna on 8/4/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

class HistoryRecord {
    
    var picture: UIImage
    var title: String
    
    init(picture: UIImage, title: String) {
        self.picture = picture
        self.title = title
    }
}
