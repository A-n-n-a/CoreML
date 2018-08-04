//
//  HistoryCell.swift
//  PicRecognition
//
//  Created by Anna on 8/4/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var record: HistoryRecord! {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        picture.image = record.picture
        title.text = record.title
    }
}
