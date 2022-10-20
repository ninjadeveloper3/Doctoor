//
//  DrawerHeaderTableViewCell.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol DrawerHeaderTableViewCellDelegate {
    func didFinishTask()
}

class DrawerHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var delegate : DrawerHeaderTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = true
        let uploadGesture = UITapGestureRecognizer(target: self, action: #selector(signOut(sender:)))
        
        if !Utility.isKeyPresentInUserDefaults(key: kToken) {
            usernameLabel.text = "  "
            profileImageView.image = #imageLiteral(resourceName: "profileplaceholder")
            signOutBtn.setTitle("Sign in",for: .normal)
        }
        else{
            //replace profile image
        }
        
        signOutBtn.addGestureRecognizer(uploadGesture)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func signOut(sender: UITapGestureRecognizer){
        print("Clicked")
        
        
//        Utility.deleteAllUserDefaults()
        
        delegate?.didFinishTask()
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> DrawerHeaderTableViewCell {
        let kDrawerHeaderTableViewCell = "kDrawerHeaderTableViewCell"
        tableView.register(UINib(nibName: "DrawerHeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kDrawerHeaderTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kDrawerHeaderTableViewCell, for: indexPath) as! DrawerHeaderTableViewCell
        return cell
    }
    
}
