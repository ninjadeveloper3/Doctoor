//
//  EquipmentCollectionViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol EquipmentCollectionViewCellDelegate {
    func didFinishTask(cell: EquipmentCollectionViewCell)
    func didCartItemTapped(cell: EquipmentCollectionViewCell,isAdd: Bool)
}

class EquipmentCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Vaviables
    
    var isCartSelected = false
    
    var delegate : EquipmentCollectionViewCellDelegate?
    
    //MARK: - Outlets

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var equipImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var brandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if !isCartSelected {
            cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            
        } else {
            cartImageView.image = #imageLiteral(resourceName: "select-cart")
        }
        
    }
    
    @IBAction func cartIconButtonTapped(_ sender: Any) {
        
        if !isCartSelected {
            cartImageView.image = #imageLiteral(resourceName: "select-cart")
            isCartSelected = true
            
        } else {
            cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            isCartSelected = false
        }
        delegate?.didCartItemTapped(cell: self, isAdd: isCartSelected)
    }
    
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> EquipmentCollectionViewCell {
        let kEquipmentCollectionViewCellIdentifier = "kEquipmentCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "EquipmentCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kEquipmentCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEquipmentCollectionViewCellIdentifier, for: indexPath) as! EquipmentCollectionViewCell
        return cell
    }
    

}
