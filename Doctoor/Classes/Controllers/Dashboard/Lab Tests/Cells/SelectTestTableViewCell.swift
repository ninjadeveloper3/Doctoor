//
//  SelectTestTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol SelectTestTableViewCellDelegate  {
    func didCartItemTapped(cell: SelectTestTableViewCell, isAdd: Bool)
}

class SelectTestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var colorView: HMView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var cartImageView: UIImageView!
    
    var isCartSelected = false
    
    var delegate: SelectTestTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        if !isCartSelected {
            cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            
        } else {
            cartImageView.image = #imageLiteral(resourceName: "select-cart")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SelectTestTableViewCell {
        let kSelectTestTableViewCell = "kSelectTestTableViewCell"
        tableView.register(UINib(nibName: "SelectTestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kSelectTestTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSelectTestTableViewCell, for: indexPath) as! SelectTestTableViewCell
        return cell
    }
    
    
    @IBAction func cartItemTapped(_ sender: Any) {
        
        if !isCartSelected {
            cartImageView.image = #imageLiteral(resourceName: "select-cart")
            isCartSelected = true
            
        } else {
            cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            isCartSelected = false
        }
        delegate?.didCartItemTapped(cell: self, isAdd: isCartSelected)
    }
    
}
