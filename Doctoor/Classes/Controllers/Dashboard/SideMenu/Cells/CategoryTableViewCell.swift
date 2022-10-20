//
//  CategoryTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CategoryTableViewCell {
        let kCategoryTableViewCell = "kCategoryTableViewCell"
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kCategoryTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kCategoryTableViewCell, for: indexPath) as! CategoryTableViewCell
        return cell
    }
    
}
