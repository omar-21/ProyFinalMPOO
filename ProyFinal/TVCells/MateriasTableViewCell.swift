//
//  MateriasTableViewCell.swift
//  ProyFinal
//
//  Created by 2020-1 on 10/9/19.
//  Copyright © 2019 2020-1. All rights reserved.
//

import UIKit

class MateriasTableViewCell: UITableViewCell {

    @IBOutlet weak var materia: UILabel!
    
    @IBOutlet weak var imagenMat: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
