//
//  ProfileViewController.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfileViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - Variables
    var isEditable = false
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    let pickerController = UIImagePickerController()
    var avatar = ""
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var headerUserName: UILabel!
    
    @IBOutlet weak var fName: MBUITextField!{
        didSet {
            fName.setIcon(#imageLiteral(resourceName: "full-name"), width: 20, height: 20)
        }
    }
    
    @IBOutlet weak var email: MBUITextField!{
        didSet {
            email.setIcon(#imageLiteral(resourceName: "email-address"), width: 20, height: 20)
            email.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var number: MBUITextField!{
        didSet {
            number.setIcon(#imageLiteral(resourceName: "phone-no"), width: 20, height: 20)
            number.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var gender: MBUITextField!{
        didSet {
            gender.setIcon(#imageLiteral(resourceName: "female"), width: 20, height: 20)
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBtn: MBButton!
    @IBOutlet weak var editIcon: UIImageView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "", secondTitle: "Profile")
        navLabel.attributedText = navTitle
        self.tabBarController?.navigationItem.titleView = navLabel
        self.tabBarController?.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: nil)
        
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = #colorLiteral(red: 0.8481271863, green: 0.1670740545, blue: 0.5549028516, alpha: 1)
        profileImageView.layer.masksToBounds = true
        editIcon.isHidden = true
        let selectImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageViewTapped(sender:)))
        profileImageView.addGestureRecognizer(selectImageViewGesture)
        if Utility.isKeyPresentInUserDefaults(key: kToken){
            self.getUserProfileApi()
        }
        fName.delegate = self
    }
    
    //MARK: - IBActions Methods
    
    @IBAction func editProfileTapped(_ sender: Any) {
        if Utility.isKeyPresentInUserDefaults(key: kToken){
            if isEditable == false{
                profileImageView.isUserInteractionEnabled = true
                fName.isUserInteractionEnabled = true
                email.isUserInteractionEnabled = true
                editIcon.isHidden = false
                profileBtn.setTitle("Save", for: .normal)
                isEditable = true
            }
            else {
                self.doUpdateMyProfile()
            }
        }
        else{
            NSError.showErrorWithMessage(message: "Please login first to edit profile", viewController: self, type: .error, isNavigation: true)
        }
        
        
    }
    
    //MARK: - Private Methods
    
    func getUserProfileApi() {
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getUserProfile { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    self.doSeProfileFields()
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func doUpdateMyProfile(){
        if fName.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Name Field", viewController: self, type: .error)
            return
        }
        else{
            if fName.text!.count < 4 {
                NSError.showErrorWithMessage(message: "Full name input length must be greater than r equal to 4 characters", viewController: self, type: .error)
                return
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: fName.text!, options: [], range: NSMakeRange(0, fName.text!.count)) != nil {
                    NSError.showErrorWithMessage(message: "Full name must contain only letters!", viewController: self, type: .error)
                    return
                }
            }
            catch {
                
            }
            
        }
        if email.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Password Field", viewController: self, type: .error)
            return
        }
        Utility.showLoading(viewController: self)
        print("on updating pic",self.avatar)
        APIClient.sharedClient.updateUserProfile(name: fName.text!, email: email.text!, avatar: self.avatar) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    NSError.showErrorWithMessage(message: "Profile updated successfully", viewController: self, type: .success , isNavigation: true)
                    self.dataSource = data
                    self.disablesFields()
                    self.profileBtn.setTitle("Edit Profile", for: .normal)
                    self.editIcon.isHidden = true
                    self.isEditable = false
                    UserDefaults.standard.set(self.dataSource.fullName, forKey: kUserFullName)
                    self.getUserProfileApi()
                }
            }
        }
    }
    
    func doSeProfileFields(){
        //        profileImageView.image =
        let imageUrl = self.dataSource.avatar
        self.avatar = self.dataSource.avatar
        print("load profile pic",self.avatar)
        if self.avatar != "" {
            let imageurl = imageUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            print("Complete URL", "\(kImageDownloadBaseUrl)storage/\(imageurl)")
            if let url = URL(string: "\(kImageDownloadProfileBaseUrl)storage/\(imageurl)") {
                print("url", url)
                profileImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        headerUserName.text = self.dataSource.fullName
        fName.text = self.dataSource.fullName
        gender.text = self.dataSource.gender
        number.text = self.dataSource.phone
        email.text = self.dataSource.email
        self.disablesFields()
    }
    
    func disablesFields(){
        profileImageView.isUserInteractionEnabled = false
        fName.isUserInteractionEnabled = false
        gender.isUserInteractionEnabled = false
        gender.isEnabled = false
        number.isUserInteractionEnabled = false
        number.isEnabled = false
        email.isUserInteractionEnabled = false
    }
    
    @objc func selectImageViewTapped(sender: UITapGestureRecognizer){
        
        if Utility.isKeyPresentInUserDefaults(key: kToken){
            let alert = UIAlertController.init(title: "Select your preferred image source",message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
                self.pickerController.delegate = self
                self.pickerController.allowsEditing = false
                self.pickerController.sourceType = .camera
                self.present(self.pickerController, animated: true, completion: nil)
                
            }
            
            let gelleryAction = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default) { (action) in
                self.pickerController.delegate = self
                self.pickerController.allowsEditing = false
                self.pickerController.sourceType = .photoLibrary
                self.present(self.pickerController, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            
            alert.addAction(cameraAction)
            alert.addAction(gelleryAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image data")
            self.profileImageView.image = image
            pickerController.dismiss(animated: true, completion: nil)
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.uploadImage(image: image) { (success, response) in
                Utility.hideLoading(viewController: self)
                if success {
                    NSError.showErrorWithMessage(message: "Image uploaded successfully", viewController: self, type: .success, isNavigation: true)
                    if let data = Mapper<SignUpUser>().map(JSONObject: response!["data"]!){
                        self.avatar = data.avatar
                        UserDefaults.standard.set(self.avatar, forKey: kUserAvatar)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker canceled")
        pickerController.dismiss(animated: true, completion: nil)
    }
}
