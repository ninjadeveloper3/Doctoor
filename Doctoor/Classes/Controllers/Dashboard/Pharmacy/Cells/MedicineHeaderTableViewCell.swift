//
//  MedicineHeaderTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 22/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol  MedicineHeaderTableViewCellDelegate {
    func didTappedExpandButton()
}

class MedicineHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegat : MedicineHeaderTableViewCellDelegate?
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var expandImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> MedicineHeaderTableViewCell {
        return UINib(nibName: "MedicineHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MedicineHeaderTableViewCell
    }
    
    @IBAction func expandButtonTapped(_ sender: Any) {
        delegat?.didTappedExpandButton()
    }
}
