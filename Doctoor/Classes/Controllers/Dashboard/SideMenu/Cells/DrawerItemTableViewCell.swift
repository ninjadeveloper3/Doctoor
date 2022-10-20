//
//  DrawerItemTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class DrawerItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> DrawerItemTableViewCell {
        let kDrawerItemTableViewCell = "kDrawerItemTableViewCell"
        tableView.register(UINib(nibName: "DrawerItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kDrawerItemTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kDrawerItemTableViewCell, for: indexPath) as! DrawerItemTableViewCell
        return cell
    }
}
