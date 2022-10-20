//
//  InDemandCollectionViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 19/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class InDemandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var firstTitleLabel: UILabel!
    
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> InDemandCollectionViewCell {
        let kInDemandCollectionViewCellIdentifier = "kInDemandCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "InDemandCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kInDemandCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInDemandCollectionViewCellIdentifier, for: indexPath) as! InDemandCollectionViewCell
        
        return cell
    }

}
