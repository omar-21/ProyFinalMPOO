//
//  TutoresTableViewCell.swift
//  ProyFinal
//
//  Created by 2020-1 on 10/9/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit

class TutoresTableViewCell: UITableViewCell {

    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var valoracion: UILabel!
    
    @IBOutlet weak var promedio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
