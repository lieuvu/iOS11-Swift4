//
//  ViewController.swift
//  SeeFood
//
//  Created by Lieu Vu on 2/6/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    // MARK: Outlets
    // **********************************************************************
    
    /// The image view
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Constants
    // **********************************************************************
    
    /// Contant
    enum Constant {
        /// The description of a matching item.
        static let matchingItem = "hotdog"
    }
    
    // MARK: Properties
    // **********************************************************************
    
    /// The image picker.
    private let imagePicker = UIImagePickerController()
    
    // MARk: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    // MARK: Actions
    // **********************************************************************
    
    /// Tap the camera button.
    ///
    /// - Parameters:
    ///     - sender: The camera button.
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}


// MARK: - ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: UIImagePickerControllerDelegage
    // **********************************************************************
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Image not recognized!")
        }
        
        guard let ciImage = CIImage(image: userPickedImage) else {
            fatalError("The image could not be converted to CIImage!")
        }
        
        detect(image: ciImage)
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = userPickedImage
    }
    
    // MARK: Helper
    // **********************************************************************
    
    /// Detect the image with the CoreML model Incepttionv3 and display the
    // navigation title if it is the matching item.
    ///
    /// - Parameters:
    ///     - image: The image to detect.
    private func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("CoreML model can not be loaded!")
        }
        
        let request = VNCoreMLRequest(model: model) {
            request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image!")
            }
            
            if let firstResult = results.first, firstResult.identifier.lowercased().contains(Constant.matchingItem) {
                print(firstResult.identifier.self)
                self.navigationItem.title = "Hotdog!"
            } else {
                self.navigationItem.title = "Not A Hotdog!"
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
}
