//
//  MatchTableViewCell.swift
//  Tinder
//
//  Created by 刘任驰 on 11/23/17.
//  Copyright © 2017 lrc. All rights reserved.
//

import UIKit
import Parse

protocol CellInfoDelegate {
    func processBtnTap()
}


class MatchTableViewCell: UITableViewCell {
    
    
    var delegate: CellInfoDelegate?
    
    
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var textFiled: UITextField!
    
    @IBAction func buttap(_ sender: Any) {
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = textFiled.text
        
        message.saveInBackground()
        
        
        if let delegate = self.delegate {
            delegate.processBtnTap()
        }
        
        
        
        
    }
    var recipientObjectId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
