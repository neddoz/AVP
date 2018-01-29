//
//  NomineeTableViewCell.swift
//  avp_ios
//
//  Created by kayeli dennis on 11/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import UIKit

class NomineeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUpControls(){
        self.userImage.layer.cornerRadius = 5
    }

    func configure(with nominee: Award.Nominee){
        self.displayName?.text = nominee.name
    }
}

extension NomineeTableViewCell: ReusableView {}
