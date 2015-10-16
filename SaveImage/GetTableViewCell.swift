//
//  GetTableViewCell.swift
//  SaveImage
//
//  Created by Administrator on 10/10/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

import UIKit

class GetTableViewCell: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profileImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 136.0/255, green: 155.0/255, blue: 218.0/255, alpha: 1.0)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
