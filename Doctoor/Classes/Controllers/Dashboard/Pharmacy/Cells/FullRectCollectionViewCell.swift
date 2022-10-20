//
//  FullRectCollectionViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class FullRectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var upperTitleLabel: UILabel!
    
    @IBOutlet weak var lowerTitleLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> FullRectCollectionViewCell {
        let kFullRectCollectionViewCellIdentifier = "kFullRectCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "FullRectCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kFullRectCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFullRectCollectionViewCellIdentifier, for: indexPath) as! FullRectCollectionViewCell
        
        return cell
    }

}
