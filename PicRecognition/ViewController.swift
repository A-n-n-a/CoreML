//
//  ViewController.swift
//  PlantsRecognition
//
//  Created by Anna on 5/20/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    
    let mobileNet = MobileNet()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func recognize(image: UIImage) -> String? {
        guard let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image), let prediction = try? self.mobileNet.prediction(image: pixelBufferImage) else { return nil }
        return prediction.classLabel
    }

    @IBAction func openGallery(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
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
            } else {
                outputLabel.text = "Could not recognize the image"
            }
            dismiss(animated: true, completion: nil)
        }
    }
}
