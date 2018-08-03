//
//  ViewController.swift
//  PlantsRecognition
//
//  Created by Anna on 5/20/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreML
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    
    let mobileNet = MobileNet()
    var records: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func recognize(image: UIImage) -> String? {
        guard let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image), let prediction = try? self.mobileNet.prediction(image: pixelBufferImage) else { return nil }
        return prediction.classLabel
    }

    @IBAction func openGallery(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let alertController = UIAlertController.init(title: nil, message: "Device has no camera", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = false
            present(picker, animated: true, completion: nil)
        }
    }
    
    func cashRecord(title: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext)!
        let record = NSManagedObject(entity: entity, insertInto: managedContext)
        record.setValue(title, forKeyPath: "title")
        
        do {
            try managedContext.save()
            records.append(record)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchRecord() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        
        do {
            records = try managedContext.fetch(fetchRequest)
            print(records)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveImageData(_ data: Data, title: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext)!
        let record = NSManagedObject(entity: entity, insertInto: managedContext)
        record.setValue(data, forKeyPath: "imageData")
        record.setValue(title, forKeyPath: "title")
        
        
        do {
            try managedContext.save()
            records.append(record)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    func fetchImageData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
//        
//        do {
//            records = try managedContext.fetch(fetchRequest)
//            print(records)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    
    func getImageData(image: UIImage) -> Data? {
        let imageData = UIImagePNGRepresentation(image)
        return imageData
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            
            if let prediction = recognize(image: image) {
                outputLabel.text = prediction
                if let imageData = getImageData(image: image) {
                    saveImageData(imageData, title: prediction)
                }
                //cashRecord(title: prediction)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.fetchRecord()
                }
            } else {
                outputLabel.text = "Could not recognize the image"
            }
            dismiss(animated: true, completion: nil)
        }
    }
}
