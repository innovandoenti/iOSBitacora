//
//  Pasajeros_TableViewCell.swift
//  Bitacoras
//
//  Created by Jaime Solis on 27/05/15.
//  Copyright (c) 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit

class Pasajeros_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Nombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
