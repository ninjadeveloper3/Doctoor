//
//  CartTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
protocol CartTableViewCellDelegate {
    func didIncrementOrder(cell: CartTableViewCell)
    func didDecrementOrder(cell: CartTableViewCell)
    func didDeleteOrder(cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    //MARK: - Vaviables
    
    var availableQty = 1
    
    var selectedQty = 1
    
    var singleItemPrice = 0.0
    
    //MARK: - Outlets
    
    var delegate : CartTableViewCellDelegate?
    
    @IBOutlet weak var itemQuantityPlus: UIButton!
    
    @IBOutlet weak var itemQuantityMinus: UIButton!
    
    @IBOutlet weak var itemQuantity: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBOutlet weak var titleCartLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        itemPrice.text! = "\(singleItemPrice)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Private Methods
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CartTableViewCell {
        let kCartTableViewCell = "kCartTableViewCell"
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kCartTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kCartTableViewCell, for: indexPath) as! CartTableViewCell
        return cell
    }
    
    @IBAction func itemPlusTapped(_ sender: Any) {
        var itemTotal = 0.0
        selectedQty += 1
        itemQuantity.text! = String(selectedQty)
        itemTotal = Double(selectedQty) * singleItemPrice
        let itemDouble = itemTotal
        let itemDoubleString = String(format: "%.2f", itemDouble) // "3.14"
        itemPrice.text! = "\(itemDoubleString)"
        
        delegate?.didIncrementOrder(cell: self)
    }
    
    @IBAction func itemMinusTapped(_ sender: Any) {
        if selectedQty - 1 == 0 {
            
        } else {
            var itemTotal = 0.0
            selectedQty -= 1
            itemQuantity.text! = String(selectedQty)
            itemTotal = Double(selectedQty) * singleItemPrice
            let itemDouble = itemTotal
            let itemDoubleString = String(format: "%.2f", itemDouble) // "3.14"
            itemPrice.text! = "\(itemDoubleString)"
        }
        delegate?.didDecrementOrder(cell: self)
    }

    @IBAction func removeItemButtonTapped(_ sender: Any) {
        delegate?.didDeleteOrder(cell: self)
    }
}
