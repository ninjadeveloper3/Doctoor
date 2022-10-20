//
//  TestCategoryCollectionViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class TestCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var upperLabel: UILabel!
    
    @IBOutlet weak var lowerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> TestCategoryCollectionViewCell {
        let kTestCategoryCollectionViewCellIdentifier = "kTestCategoryCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "TestCategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kTestCategoryCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTestCategoryCollectionViewCellIdentifier, for: indexPath) as! TestCategoryCollectionViewCell
        return cell
    }

}
