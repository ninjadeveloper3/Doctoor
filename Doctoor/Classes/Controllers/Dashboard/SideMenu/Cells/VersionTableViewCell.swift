//
//  VersionTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 07/04/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

class VersionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.versionLabel.text = "       Version: \(version)   Build: \(build)"
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> VersionTableViewCell {
        let kVersionTableViewCell = "kVersionTableViewCell"
        tableView.register(UINib(nibName: "VersionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kVersionTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kVersionTableViewCell, for: indexPath) as! VersionTableViewCell
        return cell
    }
}
