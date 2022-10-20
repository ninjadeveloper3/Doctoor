//
//  PerscriptionViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class PerscriptionViewController: UIViewController {

    //MARK: - Variables
    
    var isHome = true
    
    var prescFor = "manual"
    
    let pickerController = UIImagePickerController()
    
    var context = CIContext(options: nil)

    var isConfirmationOrder = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var selectImageView: HMView!
    
    @IBOutlet weak var galleryImageView: UIImageView!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var whatsappImageView: UIImageView!
    
    @IBOutlet weak var bgPerscriptionImage: UIImageView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Upload ", secondTitle: "Prescription")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        if isHome {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        }
        
        let cameraImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(cameraImageViewTapped(sender:)))
        cameraImageView.addGestureRecognizer(cameraImageViewGesture)
        
        let galleryImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(galleryImageViewTapped(sender:)))
        galleryImageView.addGestureRecognizer(galleryImageViewGesture)
        
        let whatsappImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(whatsappImageViewTapped(sender:)))
        whatsappImageView.addGestureRecognizer(whatsappImageViewGesture)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: bgPerscriptionImage.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(2, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        bgPerscriptionImage.image = processedImage
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        if isHome {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func whatsappImageViewTapped(sender: UITapGestureRecognizer) {
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false

        let urlWhats = "https://api.whatsapp.com/send?phone=923090850760"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                    
                } else {
                    NSError.showErrorWithMessage(message: "Please Install WhatsApp in your iPhone", viewController: self, type: .info, isNavigation: true)
                }
            }
        }
    }
    
    @objc func cameraImageViewTapped(sender: UITapGestureRecognizer) {
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.sourceType = .camera
        self.present(self.pickerController, animated: true, completion: nil)
    }
    
    @objc func galleryImageViewTapped(sender: UITapGestureRecognizer) {
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.sourceType = .photoLibrary
        self.present(self.pickerController, animated: true, completion: nil)
    }
}

extension PerscriptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let detailPerscriptionViewController = DetailPerscriptionViewController()
            detailPerscriptionViewController.isConfirmationOrder = isConfirmationOrder
            detailPerscriptionViewController.perscriptionImage = image
            detailPerscriptionViewController.prescFor = self.prescFor
            detailPerscriptionViewController.addCustomBackButton()
            pickerController.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(detailPerscriptionViewController, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
}
