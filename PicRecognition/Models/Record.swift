//
//  HistoryRecord.swift
//  PicRecognition
//
//  Created by Anna on 8/28/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

struct Record {
    
    var data: Data
    var title: String
    
    var image: UIImage? {
        return UIImage(data: data)
    }
    
    init(data: Data, title: String) {
        self.data = data
        self.title = title
    }
}
