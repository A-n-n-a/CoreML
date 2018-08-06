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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var records: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchRecords()

    }
    
    func fetchRecords() {
        activityIndicator.startAnimating()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        do {
            self.records = try managedContext.fetch(fetchRequest)
            activityIndicator.stopAnimating()
            self.tableView.reloadData()
        } catch let error as NSError {
            activityIndicator.stopAnimating()
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        let record = records[indexPath.row]
        cell.record = record
        return cell
    }
}

