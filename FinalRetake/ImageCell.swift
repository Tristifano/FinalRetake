//
//  ImageCell.swift
//  FinalRetake
//
//  Created by MacBook on 6/1/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
