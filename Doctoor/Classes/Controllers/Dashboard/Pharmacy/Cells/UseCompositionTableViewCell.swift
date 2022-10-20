//
//  UseCompositionTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class UseCompositionTableViewCell: UITableViewCell {

    @IBOutlet weak var primaryUseTextLabel: UILabel!
    
    @IBOutlet weak var compositionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        primaryUseTextLabel.sizeToFit()
        compositionLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        primaryUseTextLabel.sizeToFit()
        compositionLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> UseCompositionTableViewCell {
        return UINib(nibName: "UseCompositionTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UseCompositionTableViewCell
    }
    
}
