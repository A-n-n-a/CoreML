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
    
    fileprivate let languageID = Bundle.main.preferredLocalizations.first
    
    var record: Record! {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        
        if let record = record, let image = record.image {
            self.title.text = record.title
            
            if let cachedImage = Cache.fetchCache(path: record.title) {
                self.picture.image = cachedImage
            } else {
                self.picture.image = image
            }
            //title.text = record.value(forKey: "title") as? String
//            let params = ROGoogleTranslateParams(source: "en",
//                                                 target: "ru",
//                                                 text:   text)
//
//            let translator = ROGoogleTranslate()
//
//            translator.translate(params: params) { (result) in
//                DispatchQueue.main.async {
//                    self.title.text = result
//                }
//            }
        }
    }
}
