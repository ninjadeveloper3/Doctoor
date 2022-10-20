//
//  MedicalDetailsViewController.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class MedicalDetailsViewController: UIViewController {
    
    //MARK: - Variables
    
    let medicineCell = MedicineTableViewCell.instanceFromNib()
    
    let compositionCell = UseCompositionTableViewCell.instanceFromNib()
    
    let medicineHeader = MedicineHeaderTableViewCell.instanceFromNib()
    
    let warningsCell = WarningsTableViewCell.instanceFromNib()
    
    var medicineInTake = false
    
    var isWarning = false
    
    var filterButton = UIButton()
    
    var dataSource = Mapper<MedicineItem>().map(JSON: [:])!
    
    var isHome = false
    
    var isMisMedicine = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var medicalDetailsTableView: UITableView!
    
    @IBOutlet weak var addToCartView: UIView!
    
    @IBOutlet weak var addToCartLabel: UILabel!
    
    @IBOutlet weak var shoppingView: UIView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        medicineCell.quantity.text = "1"
        medicineCell.priceLabel.text = "\(dataSource.price)"
        if dataSource.isPrescriptionRequired == 1 {
            medicineCell.perscriptionLabel.text = "Prescription is required"
        }
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        medicineCell.selectedQty = 1
        medicalDetailsTableView.separatorStyle = .none
        
        //check item in the cart
        if Utility.getCartItems().count > 0 {
            for items in Utility.getCartItems() {
                if (items.productId == dataSource.id && items.productType == ProductType.Medicine.rawValue) {
                    addToCartLabel.text = "Remove from the cart"
                }
            }
        }
        else{
            addToCartLabel.text = "Add to cart"
        }
        
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        medicalDetailsTableView.separatorStyle = .none
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Medicine ", secondTitle: "Details")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
        let addtoCartGesture = UITapGestureRecognizer(target: self, action: #selector(addtoCartViewTapped(sender:)))
        addToCartView.addGestureRecognizer(addtoCartGesture)
        
        let shoppingGesture = UITapGestureRecognizer(target: self, action: #selector(shoppingViewTapped(sender:)))
        shoppingView.addGestureRecognizer(shoppingGesture)
        
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource.medicineImage)") {
            medicineCell.medicineImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        
        medicineCell.delegate = self
        medicineCell.medicineTitleLabel.text = dataSource.medicineName
        if dataSource.unit != "" {
            medicineCell.unit.text = dataSource.unit
            
        } else {
            medicineCell.unit.text = ""
        }
        
        medicineCell.compositionLabel.text = dataSource.composition
        medicineCell.priceLabel.text = "\(dataSource.price)"
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        
        if isHome {
            self.dismiss(animated: true, completion: nil)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    @objc func addtoCartViewTapped(sender: UITapGestureRecognizer){
        
        for items in Utility.getCartItems() {
            if (items.productId == dataSource.id && items.productType == ProductType.Medicine.rawValue) {
                if isMisMedicine {
                    Utility.removeInCart(productId: items.productId, productType: .Miscellenaous)
                } else {
                    Utility.removeInCart(productId: items.productId, productType: .Medicine)
                }
                
                filterButton.addBadge(number: Utility.getCartItems().count)
                addToCartLabel.text = "Add to cart"
                return
            }
        }
        
        let totalQuantity = medicineCell.selectedQty
        let totalPrice =  medicineCell.singleItemPrice
        if isMisMedicine {
            Utility.addUpdateInCart(productId: dataSource.id, quantity: totalQuantity, productType: .Miscellenaous, title: dataSource.medicineName, price: Double(totalPrice), description: "" , isPrep: dataSource.isPrescriptionRequired)
            
            
        } else {
            Utility.addUpdateInCart(productId: dataSource.id, quantity: totalQuantity, productType: .Medicine, title: dataSource.medicineName, price: Double(totalPrice), description: "" , isPrep: dataSource.isPrescriptionRequired)
        }
        filterButton.addBadge(number: Utility.getCartItems().count)
        addToCartLabel.text = "Remove from the cart"
    }
    
    @objc func shoppingViewTapped(sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addTapped(sender: UIBarButtonItem){
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        let confirmViewController = ConfirmSelectionViewController()
        confirmViewController.isHome = true
        navigationController.viewControllers = [confirmViewController]
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension MedicalDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.primaryUse == "" && dataSource.warnings.count == 0 {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            medicineCell.singleItemPrice = dataSource.price
            return medicineCell
            
        } else if indexPath.row == 1 {
            medicineHeader.delegat = self
            return medicineHeader
        }
        warningsCell.delegate = self
        return warningsCell
    }
}

extension MedicalDetailsViewController : MedicineTableViewCellDelegate {
    
    func didIncrementQuantity(cell: MedicineTableViewCell) {
    }
    
    func didDecrementQuantity(cell: MedicineTableViewCell) {
    }
}

extension MedicalDetailsViewController : MedicineHeaderTableViewCellDelegate {
    
    func didTappedExpandButton() {
        
        if medicineInTake == false {
            medicineInTake = true
            
            medicineHeader.descriptionLabel.text = dataSource.primaryUse
            if dataSource.howToTake == "" {
                medicineHeader.descriptionLabel.text = "No Indication"
            }
            medicineHeader.expandImageView.image = #imageLiteral(resourceName: "arrow-up")
            
        } else {
            medicineInTake = false
            medicineHeader.descriptionLabel.text = ""
            medicineHeader.expandImageView.image = #imageLiteral(resourceName: "arrow-down")
        }
        medicalDetailsTableView.reloadData()
        medicalDetailsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension MedicalDetailsViewController: WarningsTableViewCellDelegate {
    func didExpandButtonTapped() {
        if isWarning == false {
            isWarning = true
            
            for warnings in dataSource.warnings {
                warningsCell.descriptionLabel.text = "\(warnings.title): \n\(warnings.detail)"
            }
            if dataSource.warnings.count == 0 {
                warningsCell.descriptionLabel.text = "No Contradiction"
            }
            warningsCell.expandImageView.image = #imageLiteral(resourceName: "arrow-up")
            
        } else {
            isWarning = false
            warningsCell.descriptionLabel.text = ""
            warningsCell.expandImageView.image = #imageLiteral(resourceName: "arrow-down")
        }
        medicalDetailsTableView.reloadData()
        medicalDetailsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
