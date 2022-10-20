//
//  FaminineCollectionViewCell.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol FaminineCollectionViewCellDelegate  {
    func didCartItemTapped(cell: FaminineCollectionViewCell, isAdd: Bool)
}

class FaminineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var medicineImageView: UIImageView!
    
    @IBOutlet weak var medicineTitle: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var brandImageView: UIImageView!
    
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var cartImageView: UIImageView!
    
    
    //Variables
    
    var isCartSelected = false
    
    var delegate: FaminineCollectionViewCellDelegate?


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if !isCartSelected {
            cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            
        } else {
            cartImageView.image = #imageLiteral(resourceName: "select-cart")
        }
    }
    
    
    @IBAction func cartIconTapped(_ sender: Any) {
        
        if !isCartSelected {
            cartImageView.image = #imageLiteral(resourceName: "select-cart")
            isCartSelected = true
            
        } else {
            cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            isCartSelected = false
        }
        delegate?.didCartItemTapped(cell: self, isAdd: isCartSelected)
    }
    
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> FaminineCollectionViewCell {
        let kFaminineCollectionViewCellIdentifier = "kFaminineCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "FaminineCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kFaminineCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFaminineCollectionViewCellIdentifier, for: indexPath) as! FaminineCollectionViewCell
        return cell
    }
}
