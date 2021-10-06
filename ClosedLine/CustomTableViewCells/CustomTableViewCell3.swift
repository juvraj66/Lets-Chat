//
//  CustomTableViewCell3.swift
//  ClosedLine
//
//  Created by Juvraj on 9/6/21.
//

import UIKit

class CustomTableViewCell3: UITableViewCell {
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
