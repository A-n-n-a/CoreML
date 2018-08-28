//
//  CDPersistence.swift
//  Articles
//
//  Created by Anna on 8/16/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class CDPersistence {
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PicRecognition")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CDPersistence.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func save(record: Record) {
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = CDPersistence.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDRecord", in: context)!
        let cdRecord = NSManagedObject(entity: entity, insertInto: context)
        
        cdRecord.setValue(record.data, forKeyPath: "imageData")
        cdRecord.setValue(record.title, forKeyPath: "title")
        
        
        if let image = record.image {
            Cache.cacheImage(image, key: record.title)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
     static func fetchRecords() -> [Record] {
        var records = [Record]()
        let context = CDPersistence.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDRecord")
        
        do {
            let cdRecords = try context.fetch(fetchRequest)
            for cdRecord in cdRecords {
                if let record = CDPersistence.mapManagedObject(cdRecord) {
                    records.append(record)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return records
    }
    
    static func deleteAllRecords() {
        
        let context = CDPersistence.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDRecord")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    static func deleteRecordWith(title: String) {
        let context = CDPersistence.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDRecord")
        
        do {
            let cdRecords = try context.fetch(fetchRequest)
            for cdRecord in cdRecords {
                guard let recordTitle = cdRecord.value(forKey: "title") as? String else { return }
                if title == recordTitle {
                    context.delete(cdRecord)
                }
            }
            try context.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func mapManagedObject(_ managedObject: NSManagedObject) -> Record? {
        if  let data = managedObject.value(forKey: "imageData") as? Data,
            let title = managedObject.value(forKey: "title") as? String {
            let record = Record(data: data, title: title)
            return record
        }
        return nil
    }
}
