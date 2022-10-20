//
//  MyPrescptionsTableViewCell.swift
//  Doctoor
//
//  Created by Moiz Amjad on 09/04/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

protocol MyPrescptionsTableViewCellDelegate {
    func didFinishTask(cell: MyPrescptionsTableViewCell)
}

class MyPrescptionsTableViewCell: UITableViewCell {
    
    //MARK: - Vaviables
    
    var delegate : MyPrescptionsTableViewCellDelegate?
    
    @IBOutlet weak var namePrescription: UILabel!
    
    @IBOutlet weak var createdDate: UILabel!
    
    @IBOutlet weak var createdTime: UILabel!
    
    @IBOutlet weak var downloadPrescp: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        let downloadGesture = UITapGestureRecognizer(target: self, action: #selector(downloadFile(sender:)))
        downloadPrescp.addGestureRecognizer(downloadGesture)
    }
    
    @objc func downloadFile(sender: UITapGestureRecognizer){
        print("Clicked")
        delegate?.didFinishTask(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MyPrescptionsTableViewCell {
        let kMyPrescptionsTableViewCell = "kMyPrescptionsTableViewCell"
        tableView.register(UINib(nibName: "MyPrescptionsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kMyPrescptionsTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kMyPrescptionsTableViewCell, for: indexPath) as! MyPrescptionsTableViewCell
        return cell
    }
    
}
