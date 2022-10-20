//
//  SquareCollectionViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> SquareCollectionViewCell {
        let kSquareCollectionViewCellIdentifier = "kSquareCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kSquareCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSquareCollectionViewCellIdentifier, for: indexPath) as! SquareCollectionViewCell
        
        return cell
    }

}
