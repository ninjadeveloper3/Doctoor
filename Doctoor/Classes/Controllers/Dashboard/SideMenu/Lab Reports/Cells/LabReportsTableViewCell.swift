//
//  LabReportsTableViewCell.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol LabReportsTableViewCellDelegate {
    func didFinishTask(cell: LabReportsTableViewCell)
}

class LabReportsTableViewCell: UITableViewCell {

    //MARK: - Vaviables
    
    var delegate : LabReportsTableViewCellDelegate?
    
    //MARK: - Outlets

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var downloadAction: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        let downloadGesture = UITapGestureRecognizer(target: self, action: #selector(downloadFile(sender:)))
        downloadAction.addGestureRecognizer(downloadGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private Methods

    
    @objc func downloadFile(sender: UITapGestureRecognizer){
        print("Clicked")
        delegate?.didFinishTask(cell: self)
    }

    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> LabReportsTableViewCell {
        let kLabReportsTableViewCell = "kLabReportsTableViewCell"
        tableView.register(UINib(nibName: "LabReportsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kLabReportsTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kLabReportsTableViewCell, for: indexPath) as! LabReportsTableViewCell
        return cell
    }
}
