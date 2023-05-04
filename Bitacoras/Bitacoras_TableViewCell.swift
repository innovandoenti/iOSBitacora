//
//  Bitacoras_TableViewCell.swift
//  Bitacoras
//
//  Created by Jaime Solis on 02/06/15.
//  Copyright (c) 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit

class Bitacoras_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Fecha: UILabel!
    @IBOutlet weak var Bitacora: UILabel!
    @IBOutlet weak var Matricula: UILabel!
    @IBOutlet weak var Cliente: UILabel!
    @IBOutlet weak var Ruta: UILabel!
    @IBOutlet weak var Status: UIImageView!
    @IBOutlet weak var Sincronizado: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
