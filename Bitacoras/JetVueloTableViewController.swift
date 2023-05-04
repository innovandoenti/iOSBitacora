//
//  JetVueloTableViewController.swift
//  BItacoras
//
//  Created by Jaime Solis on 14/11/15.
//  Copyright © 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit

class JetVueloTableViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate {
    
    let coreDataStack = CoreDataStack()
    let util  = Util()
    let timeIndex = 2
    let timeHeight = 164
    var timePickerIsShowing : Bool = false
    var tagUTC = 0
    var combustibleCarga : Float = 0
    var combustibleSale : Float = 0
    var combustibleLLega : Float = 0
    var combustibleConsumo : Float = 0
    var pesoAterrizaje : Float = 0
    var pesoDespegue : Float = 0
    var pesoCombustible : Float = 0
    var pesoCombustibleLlega : Float = 0
    var pesoCarga : Float = 0
    var pesoOperacion : Float = (global_var.j_avion_pesooperacion).floatValue
    var tiempoVueloHorometro : Float = 0
    var totalArray : NSMutableArray = NSMutableArray()
    let formatter : NumberFormatter = NumberFormatter()
    var logica = Util()
    var datePickerView : UIDatePicker = UIDatePicker()
    var dt : NSMutableArray = NSMutableArray()
    var date = Date();
    var dateFormatter = DateFormatter()
    var dateformatter : DateFormatter = DateFormatter()
    var time_set = 0
    var IFR : Float = 1
    
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    @IBOutlet weak var btnShowMenu: UIBarButtonItem!
    
    //MARK: - .text!Box
    @IBOutlet weak var txtNivelVuelo: UITextField!
    @IBOutlet weak var txtUTCSale: UITextField!
    @IBOutlet weak var txtUTCLlega: UITextField!
    @IBOutlet weak var txtSale: UITextField!
    @IBOutlet weak var txtLlega: UITextField!
    @IBOutlet weak var txtTV: UITextField!
    @IBOutlet weak var txtCalzos: UITextField!
    @IBOutlet weak var txtHorometroSale: UITextField!
    @IBOutlet weak var txtHorometroLlega: UITextField!
    @IBOutlet weak var txtCombustibleSale: UITextField!
    @IBOutlet weak var txtCombustibleLlega: UITextField!
    @IBOutlet weak var txtConsumo: UITextField!
    @IBOutlet weak var txtPesoOperacion: UITextField!
    @IBOutlet weak var txtPesoCarga: UITextField!
    @IBOutlet weak var txtPesoCombustible: UITextField!
    @IBOutlet weak var txtPesoDespegue: UITextField!
    @IBOutlet weak var lbMTOW: UILabel!
    @IBOutlet weak var txtMatricula: UITextField!
    @IBOutlet weak var txtBitacora: UITextField!
    @IBOutlet weak var txtFecha: UITextField!
    @IBOutlet weak var txtCliente: UITextField!
    @IBOutlet weak var txtPesoAterrizaje: UITextField!
    @IBOutlet weak var txtCombustibleCargado: UITextField!
    @IBOutlet weak var txtAceiteCargadoMotor: UITextField!
    @IBOutlet weak var txtAceiteCargadoAPU: UITextField!
    @IBOutlet weak var lbIFR: UILabel!
    @IBOutlet weak var SwitchIFR: UISwitch!
    @IBOutlet weak var SegmentoUnidadMedida: UISegmentedControl!
    @IBOutlet weak var SegmentoUnidadPeso: UISegmentedControl!
    @IBOutlet weak var btnGuardar: UIButton!
    
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:17, 17:18, 18:20, 20:21, 21:22, 22:23, 23:0]
    
    //dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
    //dateformatter.dateFormat = "dd/MM/yyyy"

    override func viewDidLoad() {
        super.viewDidLoad()
        global_var.j_tramos_Id = 0
        //configurarView()

    }
    
    //MARK: - Funciones Locales
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

  
}
