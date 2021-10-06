//
//  CustomTableViewCell2.swift
//  ClosedLine
//
//  Created by Juvraj on 8/4/21.
//

import UIKit

class CustomTableViewCell2: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
}
