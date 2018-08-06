//
//  HistoryCell.swift
//  PicRecognition
//
//  Created by Anna on 8/4/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class HistoryCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var record: NSManagedObject! {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        if let record = record, let data = record.value(forKey: "imageData") as? Data {
            picture.image = UIImage(data: data)
            title.text = record.value(forKey: "title") as? String
        }
    }
}
