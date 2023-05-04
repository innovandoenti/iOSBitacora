//
//  TVC_AvionesTableViewCell.swift
//  BItacoras
//
//  Created by Jaime Solis on 13/05/16.
//  Copyright © 2016 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit

class TVC_AvionesTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var LbMatricula: UILabel!
    @IBOutlet weak var lbBitacora: UILabel!
    @IBOutlet weak var lbDestino: UILabel!
    @IBOutlet weak var lbHorometro: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
