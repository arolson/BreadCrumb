//
//  ImageViewController.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/11/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit


class ImageViewController: CoreDataViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    var pin: Pin?
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhoto()
        title = "Snapshot"
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpView(message: "No Image To Display.")
    }
    func setUpView(message: String)
    {
        self.errorLabel.text = message
    }
    @IBAction func cameraAction(_ sender: UIButton)
    {
        let photos = fetchPhotos(pin: pin!)
        if !photos.isEmpty{
            context.delete(photos[0])
            photoImageView.image = nil
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePickerControllerView(sourceType: .camera)
        }
        else
        {
            displayErrorAlert(message: "The camera is unavailable.")
        }
        
    }
    func setPhoto()
    {
        let photos = fetchPhotos(pin: pin!)
        if (photos.isEmpty)
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePickerControllerView(sourceType: .camera)
            }
            else
            {
                displayErrorAlert(message: "The camera is unavailable.")
            }
        }
        else
        {
            if let imageData = photos[0].imageData as? Data
            {
                let image = UIImage(data: imageData)
                photoImageView.image = image
                setUpView(message: "")
            }
            else
            {
                print("Could not convert Image Data.")
            }
            
            print("The image is available.")
            
        }
    }
    func imagePickerControllerView(sourceType: UIImagePickerControllerSourceType)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        performUIUpdatesOnMain {
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if let data: NSData = UIImageJPEGRepresentation(image,0.9) as NSData?{
                
                createPhoto(data: data)
                {
                    data in
                    self.save()
                    performUIUpdatesOnMain {
                        let image = UIImage(data: data)
                        self.photoImageView.image = image
                        self.setUpView(message: "")
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func createPhoto(data: NSData, handler: @escaping (_ data: Data)->Void)
    {
        performInBackGround {
            let photo = Photo(id: "0", context:self.context)
            photo.imageData = data
            photo.pin = self.pin
            print("New Photo: \(photo)")
            handler(data as Data)
        }
    }

}
