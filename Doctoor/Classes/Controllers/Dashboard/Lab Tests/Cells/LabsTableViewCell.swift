//
//  LabsTableViewCell.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class LabsTableViewCell: UITableViewCell {
    
//    Marker- IBoutlets
    @IBOutlet weak var labNameTitle: UILabel!
    @IBOutlet weak var labSubTitle: UILabel!
    @IBOutlet weak var labTestLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> LabsTableViewCell {
        let kLabsTableViewCell = "kLabsTableViewCell"
        tableView.register(UINib(nibName: "LabsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kLabsTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kLabsTableViewCell, for: indexPath) as! LabsTableViewCell
        return cell
    }
    
}
