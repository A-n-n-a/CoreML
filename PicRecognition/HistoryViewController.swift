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
        
        self.tableView.register(UINib(nibName: "HistoryCell", bundle: Bundle.main), forCellReuseIdentifier: "HistoryCell")
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        self.tableView.backgroundColor = UIColor.clear
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
    
    func resetAllRecords() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch {
            print ("There was an error")
        }
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        let record = records[indexPath.section]
        cell.record = record
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(records[indexPath.row])
            records.remove(at: indexPath.row)
            do {
                try managedContext.save()
            } catch {
                print("error")
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

