//
//  InDemandTestCollectionViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 06/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class InDemandTestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: HMView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> InDemandTestCollectionViewCell {
        let kInDemandTestCollectionViewCellIdentifier = "kInDemandTestCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "InDemandTestCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kInDemandTestCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kInDemandTestCollectionViewCellIdentifier, for: indexPath) as! InDemandTestCollectionViewCell
        
        return cell
    }


}
