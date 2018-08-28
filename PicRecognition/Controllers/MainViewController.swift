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

class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    
    let mobileNet = MobileNet()
//    var records = [Record]()
    var record: Record?
    var addButton: AddButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        
        if let record = record, let image = record.image {
            self.imageView.image =  image
            self.outputLabel.text = record.title
        }
        
        setUpAddButton()
    }
    
    func setUpAddButton() {
        addButton = AddButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        let imageOffset = (UIScreen.main.bounds.width - 275) / 2
        addButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: imageView.frame.minY)
        addButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        self.view.addSubview(addButton)
    }

    func recognize(image: UIImage) -> String? {
        guard let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image), let prediction = try? self.mobileNet.prediction(image: pixelBufferImage) else { return nil }
        return prediction.classLabel
    }

    @objc func openGallery() {
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
    
//    func cashRecord(title: String) {
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext)!
//        let record = NSManagedObject(entity: entity, insertInto: managedContext)
//        record.setValue(title, forKeyPath: "title")
//
//        do {
//            try managedContext.save()
//            records.append(record)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//
//    func fetchRecord() {
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
    
//    func saveImageData(_ data: Data, title: String) {
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedContext)!
//        let record = NSManagedObject(entity: entity, insertInto: managedContext)
//        record.setValue(data, forKeyPath: "imageData")
//        record.setValue(title, forKeyPath: "title")
//
//
//        do {
//            try managedContext.save()
//            records.append(record)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    
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

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            
            if let prediction = recognize(image: image) {
                
                let params = ROGoogleTranslateParams(source: "en",
                                                     target: "ru",
                                                     text:   prediction)

                let translator = ROGoogleTranslate()

                translator.translate(params: params, callback: { (result) in
                    print(result)
                    DispatchQueue.main.async {
                        self.outputLabel.text = result
                    }
                }, errorHandler: { error in
                    print(error)
                    self.outputLabel.text = prediction
                })
//                outputLabel.text = prediction
                if let imageData = getImageData(image: image) {
                    let record = Record(data: imageData, title: prediction)
                    CDPersistence.save(record: record)
//                    saveImageData(imageData, title: prediction)
                }
                //cashRecord(title: prediction)
                
                
                
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
//                    self.records = CDPersistence.fetchRecords()
////                    self.fetchRecord()
//                }
            } else {
                outputLabel.text = "Could not recognize the image"
            }
            dismiss(animated: true, completion: nil)
        }
    }
}
