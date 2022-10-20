//
//  WarningsTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 15/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol WarningsTableViewCellDelegate {
    func didExpandButtonTapped()
}

class WarningsTableViewCell: UITableViewCell {

    @IBOutlet weak var expandImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegate: WarningsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> WarningsTableViewCell {
        return UINib(nibName: "WarningsTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WarningsTableViewCell
    }
    
    
    @IBAction func didExpandButtonTapped(_ sender: Any) {
        delegate?.didExpandButtonTapped()
    }
}
