//
//  VuelosTableViewCell.swift
//  Bitacoras
//
//  Created by Jaime Solis on 25/05/15.
//  Copyright (c) 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit

class VuelosTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var LbRuta: UILabel!
    @IBOutlet weak var LbMatricula: UILabel!
    @IBOutlet weak var LbCliente: UILabel!
    @IBOutlet weak var LbFecha: UILabel!
    @IBOutlet weak var LbTiempoVuelo: UILabel!
    @IBOutlet weak var LbDistancia: UILabel!
    @IBOutlet weak var LbTV: UILabel!
    @IBOutlet weak var BtnPax: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
