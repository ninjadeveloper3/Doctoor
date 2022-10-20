//
//  OrderTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol OrderTableViewCellDelegate {
    func reOrder(cell: OrderTableViewCell)
}

class OrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var orderTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var orderAmountLabel: UILabel!
    
    @IBOutlet weak var paymentTypeLabel: UILabel!
    
    @IBOutlet weak var statusOuterView: HMView!
    
    @IBOutlet weak var statusInnerView: HMView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var delegate: OrderTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = . none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reOrderTapped(_ sender: Any) {
        print("tapped")
        delegate?.reOrder(cell: self)
    }
    
    func setOrderStautus(status: Int){
        
        if status == 1 {
            statusLabel.text = "Cancelled"
            statusOuterView.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.1764705882, blue: 0.0431372549, alpha: 1)
        }
        if status == 2 {
            statusLabel.text = "In-Progress"
            statusOuterView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.5647058824, blue: 0.1450980392, alpha: 1)
        }
        if status == 3 {
            statusLabel.text = "Pending"
            statusOuterView.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
        }
        if status == 4 {
            statusLabel.text = "Completed"
            statusOuterView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.7098039216, blue: 0.2666666667, alpha: 1)
        }
    }
    
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> OrderTableViewCell {
        let kOrderTableViewCell = "kOrderTableViewCell"
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kOrderTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kOrderTableViewCell, for: indexPath) as! OrderTableViewCell
        return cell
    }
}
