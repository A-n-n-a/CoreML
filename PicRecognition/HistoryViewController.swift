//
//  HistoryViewController.swift
//  PicRecognition
//
//  Created by Anna on 8/4/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var records: [NSManagedObject] = []
    var historyRrecords: [HistoryRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRecord()
    }
    
    func fetchRecord() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        
        do {
            records = try managedContext.fetch(fetchRequest)
            print(records)
            for record in records {
                if let historyRecord = Record.mapRecord(managedObject: record) {
                    historyRrecords.append(historyRecord)
                }
            }
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyRrecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        cell.record = historyRrecords[indexPath.row]
        return cell
    }
    
    
    
    
}
