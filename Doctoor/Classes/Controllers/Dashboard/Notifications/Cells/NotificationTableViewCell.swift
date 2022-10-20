//
//  NotificationTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 19/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NotificationTableViewCell {
        let kNotificationTableViewCell = "kNotificationTableViewCell"
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kNotificationTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kNotificationTableViewCell, for: indexPath) as! NotificationTableViewCell
        return cell
    }
}
