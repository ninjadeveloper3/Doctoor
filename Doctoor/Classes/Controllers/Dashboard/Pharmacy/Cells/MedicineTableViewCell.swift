//
//  MedicineTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
protocol MedicineTableViewCellDelegate {
    func didIncrementQuantity(cell: MedicineTableViewCell)
    func didDecrementQuantity(cell: MedicineTableViewCell)
}

class MedicineTableViewCell: UITableViewCell {
    
    //MARK: - Vaviables

    
    var availableQty = 1
    
    var selectedQty = 1
    
    var singleItemPrice = 0.0
    
    var delegate : MedicineTableViewCellDelegate?
    
    @IBOutlet weak var medicineImageView: UIImageView!
    
    @IBOutlet weak var unit: UILabel!
    
    @IBOutlet weak var perscriptionLabel: UILabel!
    
    @IBOutlet weak var compositionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var medicineTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func doIncrementQuantity(_ sender: UIButton) {
        
        var itemTotal = 0.0
        selectedQty += 1
        quantity.text! = String(selectedQty)
        itemTotal = Double(selectedQty) * singleItemPrice
        priceLabel.text! = "\(itemTotal)"
        delegate?.didIncrementQuantity(cell: self)
    }
    
    @IBAction func doDecrementQuantity(_ sender: UIButton) {
        
        if selectedQty - 1 == 0 {

        } else {
            var itemTotal = 0.0
            selectedQty -= 1
            quantity.text! = String(selectedQty)
            itemTotal = Double(selectedQty) * singleItemPrice
            priceLabel.text! = "\(itemTotal)"
        }
        delegate?.didDecrementQuantity(cell: self)
    }
    
    class func instanceFromNib() -> MedicineTableViewCell {
        return UINib(nibName: "MedicineTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MedicineTableViewCell
    }
    
}
