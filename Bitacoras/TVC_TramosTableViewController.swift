//
//  TVC_TramosTableViewController.swift


import UIKit
import CoreData


class TVC_TramosTableViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate, UIPickerViewDelegate {

    let coreDataStack = CoreDataStack()
    let util = Util()
    let timeIndex = 2
    let timeHeight = 164
    var timePickerIsShowing : Bool = false
    var tagUTC = 0
    var combustibleSale : Float = 0
    var combustibleLLega : Float = 0
    var combustibleConsumo : Float = 0
    var pesoAterrizaje : Float = 0
    var pesoDespegue : Float = 0
    var pesoCombustible : Float = 0
    var pesoCarga : Float = 0
    var pesoOperacion : Float = (global_var.j_avion_pesooperacion).floatValue
    var tiempoVueloHorometro : Float = 0
    var IFR : Float = 1
    var totalArray : NSMutableArray = NSMutableArray()
    let formatter : NumberFormatter = NumberFormatter()
    var logica = Util()
    var datePickerView : UIDatePicker = UIDatePicker()
    var dt : NSMutableArray = NSMutableArray()
    var dateformatter : DateFormatter = DateFormatter()
    var time_set = 0
    var date = NSDate();
    var dateFormatter = DateFormatter()
    
    var totalArrayPilotos : Array<AnyObject> = []
    var totalArrayCopilotos : Array<AnyObject> = []
    var pickerViewPilotos = UIPickerView()
    var pickerViewCopilotos = UIPickerView()
    
    /* Variables LOcales */
    
    var _calzos : String =  "0000"
    
    var _combustiblecargado : NSNumber = 0
    var _aceitecargadomotor : NSNumber = 0
    var _aceitecargadoapu : NSNumber = 0
    var _pesoaterrizaje : NSNumber = 0
    
    var _combustiblellega : NSNumber = 0
    var _combustiblesale : NSNumber = 0
    var _combustibleconsumo : NSNumber = 0
    var _horometrosale :NSNumber = 0
    var _horometrollega : NSNumber = 0
    var _nivelvuelo  : NSNumber = 0
    var _pesodespegue : NSNumber = 0
    var _pesooperacion :NSNumber = 0
    var _pesocombustible : NSNumber = 0
    var _pesocarga : NSNumber = 0
    var _TV : NSNumber = 0
    var _aterrizajemotor1 : NSNumber = 0
    var _aterrizajemotor2 : NSNumber = 0
    var _ciclosmotor1 : NSNumber = 0
    var _ciclosmotor2 : NSNumber = 0
    var _ultimabitacora : NSNumber = 0
    
    //MARK: - TextBox
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
    @IBOutlet weak var SegmentoUnidadMedida: UISegmentedControl!
    @IBOutlet weak var SegmentoUnidadPeso: UISegmentedControl!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var txtIFR: UISwitch!
    @IBOutlet weak var lbIFR: UILabel!
    @IBOutlet weak var pickerFecha: UIDatePicker!
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    
    //JET
    
    @IBOutlet weak var txtAceiteCargardoMotor: UITextField!
    @IBOutlet weak var txtAceiteCargoAPU: UITextField!
    @IBOutlet weak var txtCombustibleCargado: UITextField!
    @IBOutlet weak var txtPesoAterrizaje: UITextField!
    
    
    //Actualización del día 9 de Abril 2016

    @IBOutlet weak var txtciclos: UITextField!
    @IBOutlet weak var txtAterrizaje: UITextField!
    
    
    //Actualizacion del día 1 de Junio 2016
    @IBOutlet weak var txtNombreCopiloto: UITextField!
    @IBOutlet weak var txtLicenciaCopiloto: UITextField!
    
    //Actualizacion 16 de mayo 2017
    @IBOutlet weak var txtNombrePiloto: UITextField!
    @IBOutlet weak var txtLicenciaPiloto: UITextField!
    
    
    let effect = UIBlurEffect(style: .dark)
    let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    var nextField = [0:0]
    
    let nextFieldPiston =  [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:16, 16:19, 19:22, 22:23, 23:0]
    
    let nextFieldJet = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:16, 16:17, 17:19, 19:20, 20:22, 22:25, 25:26, 26:27, 27:0]
    
    let nextFieldTurbo = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:16, 16:17, 17:19, 19:21, 21:25, 25:26, 26:0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = SwiftSpinner.show("Creando Bitácora", animated: true)
        
        let queue = TaskQueue()
        
        queue.tasks += { result, next in
            DispatchQueue.main.async() {
                self.configurarView()
                next(nil)
            }
        }
        
        queue.tasks += { result, next in
            
              DispatchQueue.main.async() {
                print("finished")
                
                SwiftSpinner.hide()
                self.txtCliente.becomeFirstResponder()
                next(nil)
            }
        }
        
        queue.run()
        
        obtenerPilotos()
        obtenerCopilotos()
        
    }
    
    func configurarView(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TVC_TramosTableViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        txtBitacora.delegate = self
        txtCliente.delegate = self
        txtFecha.delegate = self
        txtUTCLlega.delegate = self
        txtUTCSale.delegate = self
        txtTV.delegate = self
        txtNivelVuelo.delegate = self
        txtSale.delegate = self
        txtLlega.delegate = self
        txtTV.delegate = self
        txtCalzos.delegate = self
        txtHorometroSale.delegate = self
        txtHorometroLlega.delegate = self
        txtCombustibleLlega.delegate = self
        txtCombustibleSale.delegate = self
        txtConsumo.delegate = self
        txtPesoOperacion.delegate = self
        txtPesoCarga.delegate = self
        txtPesoCombustible.delegate = self
        txtPesoDespegue.delegate = self
        txtCliente.delegate = self
        txtAterrizaje.delegate = self
        txtciclos.delegate = self
        txtNombreCopiloto.delegate = self
        txtLicenciaCopiloto.delegate = self
        txtNombrePiloto.delegate = self
        txtLicenciaPiloto.delegate = self
        
        pickerViewPilotos.delegate = self
        pickerViewPilotos.tag = 1
        
        pickerViewCopilotos.delegate = self
        pickerViewCopilotos.tag = 2
        
        txtNombrePiloto.inputView = pickerViewPilotos
        txtNombreCopiloto.inputView = pickerViewCopilotos
        
        //Toolbar pilotos
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        let defaultButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TVC_TramosTableViewController.cancelButtonPressed))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(TVC_TramosTableViewController.doneButtonPressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Piloto"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        let toolBarCop = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        toolBarCop.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBarCop.barStyle = UIBarStyle.blackTranslucent
        
        toolBarCop.tintColor = UIColor.white
        
        toolBarCop.backgroundColor = UIColor.black
        
        
        let defaultButtonCop = UIBarButtonItem(title: "Limpiar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TVC_TramosTableViewController.clearButtonPressed))
        let cangeButtonCop = UIBarButtonItem(title: "Manual", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TVC_TramosTableViewController.cambiaTeclado))
        let doneButtonCop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(TVC_TramosTableViewController.doneButtonPressed))
        let flexSpaceCop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let labelCop = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        labelCop.font = UIFont(name: "Helvetica", size: 12)
        labelCop.backgroundColor = UIColor.clear
        labelCop.textColor = UIColor.white
        labelCop.text = "Copiloto"
        labelCop.textAlignment = NSTextAlignment.center
        
        let textBtnCop = UIBarButtonItem(customView: labelCop)
        
        toolBarCop.setItems([defaultButtonCop,flexSpaceCop,textBtnCop,flexSpaceCop,doneButtonCop], animated: true)
        
        txtNombrePiloto.inputAccessoryView = toolBar
        txtNombreCopiloto.inputAccessoryView = toolBarCop
        
        txtNombrePiloto.text = global_var.j_piloto_nombre
        txtLicenciaPiloto.text = global_var.j_piloto_licencia
        global_var.j_piloto_id = String (global_var.j_usuario_idPiloto)
        global_var.j_copiloto_id = ""
        
        txtNivelVuelo.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtHorometroSale.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtHorometroLlega.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtCombustibleLlega.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtCombustibleSale.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtPesoOperacion.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtPesoCarga.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtPesoCombustible.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtPesoDespegue.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtBitacora.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtAterrizaje.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        txtciclos.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        
        
        
        //Jet
        if global_var.j_avion_tipomotor != "2" {
            txtCombustibleCargado.delegate = self
            txtPesoAterrizaje.delegate = self
            
            if global_var.j_avion_tipomotor == "1"{
                
                txtAceiteCargoAPU.delegate = self
                txtAceiteCargardoMotor.delegate = self
                
                txtAceiteCargoAPU.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
                txtAceiteCargardoMotor.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
            }
            
            txtCombustibleCargado.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
            txtPesoAterrizaje.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        }
        
        
        dateformatter.dateStyle = .short
        dateformatter.dateFormat = "dd/MM/yyyy"
        
        global_var.j_tramos_Id = 0
        
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        txtPesoOperacion.text = formatter.string(from: global_var.j_avion_pesooperacion)
        txtPesoDespegue.text = formatter.string(from: global_var.j_avion_pesooperacion)
        lbMTOW.text   =  "MTOW: " + formatter.string(from: NSNumber(value: global_var.j_avion_mtow))!
        txtPesoDespegue.isEnabled = false
        txtMatricula.isEnabled = false
        txtMatricula.text = global_var.j_avion_matricula
        txtHorometroSale.text =  formatter.string(from:  global_var.j_avion_ultimohorometro)!
        SegmentoUnidadPeso.selectedSegmentIndex = Int(global_var.j_avion_unidadpesoavion)
        SegmentoUnidadMedida.selectedSegmentIndex = global_var.j_avion_pesofuel
        
        //Asigna el seguimiento de controles
        if global_var.j_avion_tipomotor == "1" {
            nextField = nextFieldJet
            txtAceiteCargardoMotor.delegate = self
            txtAceiteCargoAPU.delegate = self
            txtAceiteCargardoMotor.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
            txtAceiteCargoAPU.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        }else if global_var.j_avion_tipomotor == "2" {
            nextField = nextFieldPiston
        }else if global_var.j_avion_tipomotor == "3" {
            nextField = nextFieldTurbo
            txtAceiteCargardoMotor.delegate = self
            txtAceiteCargardoMotor.addTarget(self, action: #selector(TVC_TramosTableViewController.Formatear(textField:)), for: .editingChanged)
        }
        
        if(global_var.j_procedencia == 1){
            
            //Procedencia de BVC (Manual)
            coreDataStack.obtieneUltimaInformacion(matricula: global_var.j_avion_matricula)
            self.navigationItem.title = global_var.j_avion_matricula
            txtBitacora.text = global_var.j_avion_ultimabitacora.stringValue //"\(coreDataStack.IdBitacora(matricula: global_var.j_avion_matricula))"
            self.txtSale.text = global_var.j_avion_ultimodestino.uppercased()
            txtFecha.text = self.dateformatter.string(from: date as Date)
            txtAterrizaje.text = formatter.string(from: global_var.j_avion_ultimoaterrizaje)
            txtciclos.text = formatter.string(from: global_var.j_avion_ultimociclo)
            
        }
        else{
            
            if(global_var.j_bitacoras_Id != 0){
                //Editar la bitacora registrada
                cargarTramo()
            }else{
                
                //Procedencia del Vuelos Table View Controller
                coreDataStack.obtieneUltimaInformacion(matricula: global_var.j_avion_matricula)
                print("Entro desde la sección del vuelo")
                self.navigationItem.title = global_var.j_avion_matricula
                print(global_var.j_vuelo_fecha)
                self.txtFecha.text = self.dateformatter.string(from: (global_var.j_vuelo_fecha as NSDate) as Date)
                self.txtCliente.text = global_var.j_vuelo_customername
                self.txtSale.text = global_var.j_vuelo_aeropuertosale
                self.txtLlega.text = global_var.j_vuelo_aeropuertollega
                self.txtNombreCopiloto.text = global_var.j_vuelo_copiloto
                global_var.j_bitacora_prevuelo = global_var.j_vuelo_prevuelo
                
                if !global_var.j_bitacora_prevuelo.isEmpty || global_var.j_bitacora_prevuelo != "" {
                    global_var.j_bitacora_prevuelolocal = 1
                }
                
                
                let inFormatter = DateFormatter()
                inFormatter.locale = Locale(identifier: "en_US_POSIX")
                inFormatter.dateFormat = "HH:mm"
                
                let outFormatter = DateFormatter()
                outFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
                // TimeZone(name: "UTC")
                outFormatter.dateFormat = "HH:mm"
                
                if global_var.j_vuelo_horasale != "" {
                    
                    let inStr = global_var.j_vuelo_horasale
                    let date_local = inFormatter.date(from: inStr)!
                    let outStr = outFormatter.string(from: date_local)
                    self.txtUTCSale.text = outStr
                    
                }else{
                    self.txtUTCSale.text = global_var.j_vuelo_horasale
                }
                
                self.txtUTCLlega.text = ""
                self.txtAterrizaje.text = self.formatter.string(from: global_var.j_avion_ultimoaterrizaje)
                self.txtciclos.text = self.formatter.string(from: global_var.j_avion_ultimociclo)
                self.txtBitacora.text = global_var.j_avion_ultimabitacora.stringValue //"\(self.coreDataStack.IdBitacora(matricula: global_var.j_avion_matricula))"
                self.calculaTiempoVuelo()
                
            }
        }
        
    }
    
    @objc func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tramos
    func cargarTramo(){
        
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
        let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id, global_var.j_avion_matricula])
        fetchRequest.predicate = predicate
        
        
        do{
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [BitacorasLegs]
            if let aviones = fetchResults{
                for row in aviones{
                    txtSale.text = row.origen!.uppercased()
                    txtLlega.text = row.destino!.uppercased()
                    global_var.j_bitacora_ultimo_destino = row.destino!.uppercased()
                    
                    let _nivelvuelo = row.nivelvuelo
                    txtNivelVuelo.text =  formatter.string(from: _nivelvuelo!)
                    
                    txtUTCSale.text! = row.horasalida!
                    txtUTCLlega.text! = row.horallegada!    
                    
                    let _calzos = row.calzoacalzo
                    txtCalzos.text = "\(_calzos!)"
                    
                    let _hsale = row.horometrodespegue
                    let _hllega = row.horometroaterrizaje
                    txtHorometroLlega.text = formatter.string(from:_hllega!)
                    global_var.j_bitacora_ultimo_horometro = _hllega!
                    txtHorometroSale.text = formatter.string(from:_hsale!)
                    
                    let _tv = row.tv
                    txtTV.text = formatter.string(from:_tv!)
                    
                    let _combSale = row.combustibledespegue
                    let _combLlega = row.combustibleaterrizaje
                    let _combConsumido = row.combustibleconsumido
                    txtCombustibleSale.text = formatter.string(from:_combSale!)
                    txtCombustibleLlega.text = formatter.string(from:_combLlega!)
                    txtConsumo.text = formatter.string(from:_combConsumido!)
                    
                    let _pesocarga = row.pesocarga
                    let _pesocombustible = row.pesocombustible
                    let _pesoDespegue = row.pesodespegue
                    txtPesoCarga.text = formatter.string(from:_pesocarga!)
                    txtPesoCombustible.text =  formatter.string(from:_pesocombustible!)
                    txtPesoDespegue.text =  formatter.string(from: _pesoDespegue!)
                    
                    if global_var.j_avion_tipomotor != "2" {
                        
                        let _aceitecargadomotor = row.aceitecargado!
                        let _aceitecargadoapu = row.aceitecargadoapu!
                        let _combcargado = row.combustiblecargado!
                        let _pesoaterrizaje = row.pesoaterrizaje!
                        
                        if global_var.j_avion_tipomotor == "1" || global_var.j_avion_tipomotor == "3" {
                            if let aceitecargo = formatter.string(from:_aceitecargadomotor){
                                 txtAceiteCargardoMotor.text = aceitecargo
                            }else{
                                txtAceiteCargardoMotor.text = ""
                            }
                           
                            
                            if global_var.j_avion_tipomotor == "1" {
                                if let aceitecargo_apu = formatter.string(from:_aceitecargadoapu) {
                                     txtAceiteCargoAPU.text = aceitecargo_apu
                                }else{
                                    txtAceiteCargoAPU.text = ""
                                }
                           
                            }
                        }
                        
                        txtCombustibleCargado.text = formatter.string(from:_combcargado)
                        txtPesoAterrizaje.text = formatter.string(from:_pesoaterrizaje)
                        
                    }
                    
                    txtBitacora.text = "\(global_var.j_bitacora_num)"
                    global_var.j_bitacora_ultima_bitacora = global_var.j_bitacora_num
                    txtFecha.text = dateformatter.string(from: global_var.j_bitacora_fecha as Date)
                    txtCliente.text = global_var.j_bitacora_cliente
                    txtNombreCopiloto.text = global_var.j_bitacora_nombrecopiloto
                    txtLicenciaCopiloto.text = global_var.j_bitacora_licenciacopiloto
                    
                    txtNombrePiloto.text = global_var.j_bitacora_nombrepiloto
                    txtLicenciaPiloto.text = global_var.j_bitacora_licenciapiloto
                    global_var.j_piloto_id = String (global_var.j_bitacora_idpiloto)
                    
                    
                    //Actualización día 9 de Abril
                    txtAterrizaje.text = formatter.string(from:global_var.j_bitacora_totalaterrizajes)
                    txtciclos.text = formatter.string(from:global_var.j_bitacora_ciclos)
                    global_var.j_tramos_Id = row.idtramo!
                    IFR = (global_var.j_bitacoras_ifr).floatValue
                    calcularPeso()
                }
                
                
                if global_var.j_bitacoras_ifr == 1 {
                    self.txtIFR.setOn(true, animated: true)
                    IFRChanged(sender: self.txtIFR)
                }else{
                    self.txtIFR.setOn(false, animated: true)
                    IFRChanged(sender: self.txtIFR)
                }
                
            }
        }catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error2", strBody: error.description as NSString, delegate: self)
        }
    }
    
    
    // MARK: - Tiempos de Vuelo
    
    @IBAction func mostrarHora(_ sender: Any) {
        
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.backgroundColor = UIColor.white
        time_set = (sender as! UITextField).tag
        
        let toolbar  : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TVC_TramosTableViewController.cancelButtonPressed(sender :)))
        let flexible : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: nil)
        
        toolbar.setItems([cancelButton,flexible,doneButton], animated: true)
        (sender as! UITextField).inputView = datePickerView
        (sender as! UITextField).inputAccessoryView = toolbar
        
    }
    @IBAction func mostrarHora(sender: UITextField) {
        
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.backgroundColor = UIColor.white
        time_set = sender.tag
        
      //  let toolbar  : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let toolbar : UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TVC_TramosTableViewController.cancelButtonPressed(sender :)))
        let flexible : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: nil)
        
        toolbar.setItems([cancelButton,flexible,doneButton], animated: true)
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolbar
        
        
    }
    
    @objc func cancelButtonPressed(sender: UIDatePicker){
        self.view.endEditing(true)
    }
    
    @objc func clearButtonPressed(sender: UIDatePicker){
        txtNombreCopiloto.text = ""
        txtLicenciaCopiloto.text = ""
        global_var.j_copiloto_id = ""
        
        obtenerPilotos()
        //self.view.endEditing(true)
    }
    
    @objc func doneButtonPressed(sender: AnyObject){
        
        print(datePickerView.date)
        txtFecha.text = dateformatter.string(from: datePickerView.date)
        self.view.endEditing(true)
        txtCliente.becomeFirstResponder()
    }
    
    func calculaTiempoVuelo(){
        
        
        if(!txtUTCLlega.text!.isEmpty && !txtUTCSale.text!.isEmpty)
        {
            dateFormatter.dateStyle = .short //Set date style
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "HH:mm"
            //dateFormatter.string(from: date)
            
            let sale = dateFormatter.string(from: dateFormatter.date(from: txtUTCSale.text!)!)
            let llega = dateFormatter.string(from: dateFormatter.date(from: txtUTCLlega.text!)!)
            
            print(sale)
            print(llega)
            
            var HoraSaleSplit : [String] =  sale.split(separator: ":")
            var HoraLlegaSplit : [String] = llega.split(separator: ":")
            
            
            if(HoraSaleSplit.count > 1 && HoraLlegaSplit.count > 1){
                
                let horasSale = HoraSaleSplit[0]
                let minutosSale = HoraSaleSplit[1] //.substringFromIndex(<#T##index: Index##Index#>) substring(to: HoraSaleSplit[1].index(HoraSaleSplit[1].startIndex, offsetBy: 2))
                
                let minutosLlega = HoraLlegaSplit[1] //.substring(to: HoraLlegaSplit[1].index(HoraLlegaSplit[1].startIndex, offsetBy: 2))
                let horasLlega = HoraLlegaSplit[0]
                
                var DiferenciaHoras : Int = 0
                var DiferenciaMinutos : Int = 0
                
                if(Int(horasLlega)! < Int(horasSale)!){
                    
                    //Tengo que realizar un operaciones temporal
                    DiferenciaHoras = (24 - Int(horasSale)!) + Int(horasLlega)!
                    
                }else if (Int(horasLlega)! >= Int(horasSale)!){
                    
                    DiferenciaHoras = Int(horasLlega)! - Int(horasSale)!
                }
                
                if minutosLlega < minutosSale{
                    DiferenciaHoras -= 1
                    DiferenciaMinutos = (Int(minutosLlega)! - Int(minutosSale)!) + 60
                }
                else{
                    DiferenciaMinutos = Int(minutosLlega)! - Int(minutosSale)!
                }
                
                formatter.minimumIntegerDigits = 2
                if DiferenciaHoras < 0 {
                    txtCalzos.text = "00:00"
                }else{
                    txtCalzos.text = "\(formatter.string(from:NSNumber(value: DiferenciaHoras))!):\(formatter.string(from:NSNumber(value: DiferenciaMinutos))!)"
                }
            }
        }
        
    }
    
    @IBAction func btnMostrarUTCSale(sender: AnyObject) {
        
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateStyle = .short//Set date style
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone! as TimeZone
        self.txtUTCSale.text! = dateFormatter.string(from: date as Date)
        
    }
    
    @IBAction func btnMostrarUTCLlega(sender: AnyObject) {
        
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeZone = timeZone! as TimeZone
        dateFormatter.dateStyle = .short //Set date style
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH:mm"
        self.txtUTCLlega.text = dateFormatter.string(from: date as Date)
        
        
        calculaTiempoVuelo()
    }
    
    @IBAction func calcularAlSalir(_ sender: Any) {
        if(!txtHorometroSale.text!.isEmpty && !txtHorometroLlega.text!.isEmpty){
            calcularHorometro(tipo: false)
        }
    }
    
    
    // MARK: - Horometros
    
    @IBAction func txtHorometros(_ sender: Any) {
        if(!txtHorometroSale.text!.isEmpty && !txtHorometroLlega.text!.isEmpty){
            calcularHorometro(tipo: false)
        }
    }
    
    @IBAction func txtTV(_ sender: Any) {
        if(!txtTV.text!.isEmpty){
            calcularHorometro(tipo: true)
        }
    }
    
    func calcularHorometro(tipo: Bool){
        
        self.tiempoVueloHorometro = 0
        
        var HorometroSale : Float = 0
        var HorometroLlega : Float = 0
        var TV : Float = 0
        
        txtHorometroSale.text = txtHorometroSale.text!.replacingOccurrences(of: ",", with: "")
        txtHorometroLlega.text = txtHorometroLlega.text!.replacingOccurrences(of: ",", with: "")
        
        //Calcular Horometro de Llegada
        if let horometrosale = formatter.number(from: txtHorometroSale.text! as String)?.floatValue{
            HorometroSale = horometrosale
        }else{
            HorometroSale = 0
        }
        
        if tipo == false {
            //Calcular Tiempo de Vuelo -> Restar Llegada - Salida
            
            if let horometrollega = formatter.number(from: txtHorometroLlega.text! as String)?.floatValue {
                HorometroLlega = horometrollega
            }else{
                HorometroLlega = 0
            }
            
            tiempoVueloHorometro = HorometroLlega - HorometroSale
            
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .decimal
            txtTV.text = ""
            txtTV.text = "\(formatter.string(from:NSNumber(value: tiempoVueloHorometro))!)"
            Formatear(textField: txtHorometroSale)
            Formatear(textField: txtHorometroLlega)
            
        }
        else{
            
            
            if let tv = formatter.number(from: txtTV.text! as String)?.floatValue {
                TV = tv
            }else{
                TV = 0
            }
            HorometroLlega = HorometroSale + TV
            
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .decimal
            txtHorometroLlega.text = ""
            txtHorometroLlega.text = "\(formatter.string(from:NSNumber(value: HorometroLlega))!)"
            Formatear(textField: txtHorometroLlega)
            Formatear(textField: txtHorometroSale)
        }
        
        
    }
    
    
    
    
    // MARK: - Pesos 
    @IBAction func txtPesos(_ sender: Any) {
        self.pesoDespegue  = 0
         calcularPeso()
    }
    
    func calcularPeso(){
        
        
        self.pesoOperacion = 0
        self.pesoCombustible = 0
        self.pesoCarga = 0
        self.pesoDespegue = 0
        
        if(!txtPesoOperacion.text!.isEmpty){
            txtPesoOperacion.text = txtPesoOperacion.text!.replacingOccurrences(of: ",", with: "")
            if let po = formatter.number(from: txtPesoOperacion.text! as String)?.floatValue {
                self.pesoOperacion = po
                Formatear(textField: txtPesoOperacion)
            }
        }
        
        if(!txtPesoCombustible.text!.isEmpty){
            txtPesoCombustible.text = txtPesoCombustible.text!.replacingOccurrences(of: ",", with: "")
            if let pc = formatter.number(from: txtPesoCombustible.text! as String)?.floatValue {
                self.pesoCombustible = pc
                Formatear(textField: txtPesoCombustible)
            }
        }
        
        if(!txtPesoCarga.text!.isEmpty){
            txtPesoCarga.text = txtPesoCarga.text!.replacingOccurrences(of: ",", with: "")
            if let pc = formatter.number(from: txtPesoCarga.text! as String)?.floatValue {
                self.pesoCarga = pc
                Formatear(textField: txtPesoCarga)
            }
        }
        
        if global_var.j_avion_matricula.uppercased() == "XAUQK" {
            
            self.pesoDespegue =  ((self.pesoOperacion) + (self.pesoCarga) + (self.pesoCombustible)) - 15
        }
        else{
            
            self.pesoDespegue =  (self.pesoOperacion) + (self.pesoCarga) + (self.pesoCombustible)
            
        }
        print(self.pesoDespegue)
        let f : NumberFormatter = NumberFormatter()
        f.decimalSeparator = "."
        f.maximumFractionDigits = 1
        f.numberStyle = .decimal
        txtPesoDespegue.backgroundColor = UIColor.white
        txtPesoDespegue.textColor = UIColor.black
        txtPesoDespegue.text = "\(f.string(from:NSNumber(value: self.pesoDespegue))!)"
        
        if(self.combustibleLLega > 0 && global_var.j_avion_tipomotor != "2"){
            calcularPesoAterrizaje()
        }
        
    }
    
    func calcularPesoAterrizaje(){
        
        
        
        self.pesoOperacion = 0
        self.pesoCarga = 0
        
        if(self.combustibleLLega > 0){
            if(!txtPesoOperacion.text!.isEmpty){
                txtPesoOperacion.text = txtPesoOperacion.text!.replacingOccurrences(of: ",", with: "")
                self.pesoOperacion = formatter.number(from: txtPesoOperacion.text! as String)!.floatValue
                Formatear(textField: txtPesoOperacion)
            }
            
            if(!txtPesoCarga.text!.isEmpty){
                txtPesoCarga.text = txtPesoCarga.text!.replacingOccurrences(of: ",", with: "")
                self.pesoCarga =  formatter.number(from: txtPesoCarga.text! as String)!.floatValue
                Formatear(textField: txtPesoCarga)
            }
            
            print("Peso Operacion: \(self.pesoOperacion)")
            print("Peso Carga: \(self.pesoCarga)")
            print("Peso combustible: \(self.combustibleLLega)")
            
            self.pesoAterrizaje =  (self.pesoOperacion) + (self.pesoCarga)  + self.combustibleLLega
            
            print(self.pesoAterrizaje)
            self.txtPesoAterrizaje.text! = "\(formatter.string(from:NSNumber(value: self.pesoAterrizaje))!)"
        }
        
        
    }
    
    @IBAction func verificaMTOW(sender: UITextField) {
        
        let textbox : UITextField = sender 
        
        //Verifica si el peso de despegue excede el MTOW del AVION
        if self.pesoDespegue > global_var.j_avion_mtow {
            Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica el peso de despegue, excedes el MTOW", delegate: self)
                textbox.text = "0"
            textbox.resignFirstResponder()
        }
        
    }
    
    // MARK: - Combustibles
    
    
    @IBAction func SegmentoUnidadMedida(sender: AnyObject) {
        
        if global_var.j_avion_tipomotor == "2" {
            
            if(!txtCombustibleSale.text!.isEmpty){
                txtCombustibleSale.text =  txtCombustibleSale.text!.replacingOccurrences(of: ",", with: "")
                if let cs = formatter.number(from: txtCombustibleSale.text! as String)?.floatValue {
                    self.combustibleSale = cs
                    Formatear(textField: txtCombustibleSale)
                }else{
                    self.combustibleSale = 0
                }
                
            }
            
            print(self.combustibleSale)
            if(self.combustibleSale>0){
                txtPesoCombustible.text! = util.calculaPesoCombustible(cantidadpeso: self.combustibleSale, unidadfuel: NSNumber(value: SegmentoUnidadMedida.selectedSegmentIndex), unidadpesofuel: global_var.j_avion_unidadpesoavion)
                
                txtPesos(txtPesoCombustible)
                
                
            }else{
                txtPesoCombustible.text! = "0"
            }
        }
    }
    
    @IBAction func SegmentoUnidadPeso(sender: AnyObject) {
        if(self.combustibleSale>0){
            txtPesoCombustible.text = util.calculaPesoCombustible(cantidadpeso: self.combustibleSale, unidadfuel: NSNumber(value: SegmentoUnidadMedida.selectedSegmentIndex), unidadpesofuel: global_var.j_avion_unidadpesoavion)
            
            txtPesos(txtPesoCombustible)
            
        }else{
            txtPesoCombustible.text = "0"
        }
    }
    
    @IBAction func txtCombustibleConsumo(_ sender: Any) {
        
        self.combustibleSale = 0
        self.combustibleLLega = 0
        self.combustibleConsumo = 0
        
        if(!txtCombustibleSale.text!.isEmpty){
            txtCombustibleSale.text =  txtCombustibleSale.text!.replacingOccurrences(of: ",", with: "")
            if let cs = formatter.number(from: txtCombustibleSale.text! as String)?.floatValue {
                self.combustibleSale = cs
                Formatear(textField: txtCombustibleSale)
            }else{
                self.combustibleSale = 0
            }
            
        }
        
        if(!txtCombustibleLlega.text!.isEmpty){
            txtCombustibleLlega.text =  txtCombustibleLlega.text!.replacingOccurrences(of: ",", with: "")
            if let cl = formatter.number(from: txtCombustibleLlega.text! as String)?.floatValue {
                self.combustibleLLega = cl
                Formatear(textField: txtCombustibleLlega)
            }
            else{
                self.combustibleLLega = 0
            }
        }
        
        calculaConsumoCombustible()
        
        //Solo para aviones piston se calcula de acuerdo a los cantidad de combustible con el que sale
        if(global_var.j_avion_tipomotor == "2"){
            txtPesoCombustible.text! = util.calculaPesoCombustible(cantidadpeso: self.combustibleSale, unidadfuel: NSNumber(value: SegmentoUnidadMedida.selectedSegmentIndex), unidadpesofuel: global_var.j_avion_unidadpesoavion)
        }
        else{
            txtPesoCombustible.text! = txtCombustibleSale.text!
        }
        
        //Fire Handler Pesos
        txtPesos(txtPesoCombustible)
        

    }
    
    func calculaConsumoCombustible(){
        
        if(combustibleSale > 0){
            if (combustibleLLega > combustibleSale) {
                
                Util.invokeAlertMethod(strTitle: "Error", strBody: "Combustible de llegada no puede ser mayor a al combustible de salida", delegate: self)
                txtCombustibleLlega.text = ""
                txtCombustibleLlega.becomeFirstResponder()
                
            }
            else{
                if combustibleLLega > 0 {
                    self.combustibleConsumo = self.combustibleSale - self.combustibleLLega
                    formatter.decimalSeparator = "."
                    formatter.maximumFractionDigits = 1
                    formatter.numberStyle = .decimal
                    txtConsumo.text = "\(formatter.string(from:NSNumber(value: self.combustibleConsumo))!)"
                }
            }
        }
    }
    
    
    // MARK: - IFR
    
    @IBAction func IFRChanged(sender: AnyObject) {
        if txtIFR.isOn {
            lbIFR.text = "I.F.R.:"
            IFR = 1
        }
        else{
            lbIFR.text = "V.F.R.:"
            IFR = 0
        }
    }
    
    // MARK: - Pilotos pickerview
    
    func obtenerPilotos(){
        totalArrayPilotos.removeAll(keepingCapacity: false)
        
        var ids : Array<AnyObject> = []
        /*print("matricula: ", global_var.j_avion_matricula)
        
        
        
        let requestMatriculas = NSFetchRequest<NSFetchRequestResult>(entityName: "AvionesAsignados")
        requestMatriculas.fetchBatchSize = 20
       // requestMatriculas.predicate = NSPredicate(format: "matricula = %@", [global_var.j_avion_matricula])
        do {
            let fetchResults = try coreDataStack.managedObjectContext.fetch(requestMatriculas) as! [AvionesAsignados]
            
            if fetchResults.count > 0 {
                for bas in fetchResults as [AvionesAsignados]
                {
                    print("id piloto en tablal: ", bas.idpiloto)
                    print(global_var.j_piloto_id)
                    if(bas.idpiloto != global_var.j_copiloto_id){
                        ids.append(bas.idpiloto! as AnyObject)
                    }
                }
            }else{
                print("NO hay nada de pilotos")
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pilotos")
        request.predicate = NSPredicate(format:"idpiloto IN %@", ids)
        */
        totalArrayPilotos = coreDataStack.obtienePilotosMatricula(matricula: global_var.j_avion_matricula)
        //try! coreDataStack.managedObjectContext.fetch(request) as Array<AnyObject>
    }
    
    func obtenerCopilotos(){
        totalArrayCopilotos.removeAll(keepingCapacity: false)
        
        var ids : Array<AnyObject> = []
        
        let requestMatriculas = NSFetchRequest<NSFetchRequestResult>(entityName: "AvionesAsignados")
        requestMatriculas.predicate = NSPredicate(format: "matricula == %@", global_var.j_avion_matricula)
        do {
            let fetchResults = try coreDataStack.managedObjectContext.fetch(requestMatriculas) as! [AvionesAsignados]
            
            if fetchResults.count > 0 {
                for bas in fetchResults as [AvionesAsignados]
                {
                    print(bas.idpiloto)
                    if(bas.idpiloto != global_var.j_piloto_id){
                        ids.append(bas.idpiloto! as AnyObject)
                    }
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pilotos")
        request.predicate = NSPredicate(format:"idpiloto IN %@", ids)
        
        totalArrayCopilotos = try! coreDataStack.managedObjectContext.fetch(request) as Array<AnyObject>
    }
    
    @objc func cambiaTeclado(sender: UIDatePicker){
        txtNombreCopiloto.inputView = nil
        txtNombreCopiloto.inputAccessoryView = nil
        txtNombreCopiloto.reloadInputViews()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var total : Int = 0
        if(pickerView.tag == 1){
            total = totalArrayPilotos.count
        }
        
        if(pickerView.tag == 2){
            total = totalArrayCopilotos.count
        }
        
        return total
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var total : Int = 0
        if(pickerView.tag == 1){
            total = totalArrayPilotos.count
        }
        
        if(pickerView.tag == 2){
            total = totalArrayCopilotos.count
        }
        
        return total
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1){
            let item = totalArrayPilotos[row] as! Pilotos
            return item.nombre!
        }
        else{
            let item = totalArrayCopilotos[row] as! Pilotos
            return item.nombre!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if(pickerView.tag == 1){
            
            let row = totalArrayPilotos[row] as! Pilotos
            txtLicenciaPiloto.text = row.licencia
            txtNombrePiloto.text = row.nombre
            global_var.j_piloto_id = row.idpiloto!
            print("piloto asignado")
            print(global_var.j_piloto_id)
            
            obtenerCopilotos()
        }
        
        if(pickerView.tag == 2){
            
            let row = totalArrayCopilotos[row] as! Pilotos
            txtNombreCopiloto.text = row.nombre
            txtLicenciaCopiloto.text = row.licencia
            global_var.j_copiloto_id = row.idpiloto!
            
            print("copiloto asignado")
            print(global_var.j_copiloto_id)
            obtenerPilotos()
        }
    }

    
    // MARK: - TextField Delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        let nextTag = nextField[textField.tag]
        self.view.viewWithTag(nextTag!)?.becomeFirstResponder()
        if(GuardarInformacion() == true){
            if(nextTag == 0){
                btnGuardar.sendActions(for: .touchUpInside)
            }
            print("se guardo")
        }
        return false
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var cs : CharacterSet!
              
        if(textField.tag != 0 && textField.tag != 2 && textField.tag != 3 && textField.tag != 4 && textField.tag != 6  && textField.tag != 7){
            
            cs = CharacterSet.init(charactersIn: "1234567890-.").inverted
            
            
            if (textField.tag == 5 || textField.tag == 1){
                cs = CharacterSet.init(charactersIn: "1234567890").inverted
            }
            
            let components = string.components(separatedBy: cs)
            //components(separatedBy: cs)
            //componentsSeparatedByCharactersInSet(cs)
            
            let filtered = components.joined(separator: "")
            
            return string == filtered
            
        }else{
            cs = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNÑOPQRSTUVW‌​XYZabcdefghijklmnñopq‌​rstuvwxyz ").inverted
            
            let components = string.components(separatedBy: cs)
            //componentsSeparatedByCharactersInSet(cs)
            
            let filtered = components.joined(separator: "")
            
            return string == filtered
        
        }
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField === txtUTCSale){
            tagUTC = 0
            
        }else if(textField === txtUTCLlega){
            tagUTC = 1
            
        }
        else if(textField === txtCalzos){
            calculaTiempoVuelo()
        }
        else if(textField === txtPesoCombustible){
            txtCombustibleConsumo(textField)
        }
        else if(textField === txtNombreCopiloto){
            if txtNombreCopiloto.text == ""
            {
                txtNombreCopiloto.inputView = pickerViewCopilotos
                txtNombreCopiloto.reloadInputViews()
                if totalArrayCopilotos.count > 0
                {
                    let row = totalArrayCopilotos[0] as! Pilotos
                    txtNombreCopiloto.text = row.nombre
                    txtLicenciaCopiloto.text = row.licencia
                    global_var.j_copiloto_id = row.idpiloto!
                    obtenerPilotos()
                }
                else{
                    txtNombreCopiloto.isUserInteractionEnabled = false
                    txtNombreCopiloto.isEnabled = false
                    txtNombreCopiloto.inputView = nil
                    txtNombreCopiloto.inputAccessoryView = nil
                    txtNombreCopiloto.reloadInputViews()
                    
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var editable = false
        if(textField == txtCalzos || textField == txtConsumo || textField == txtPesoOperacion || textField == txtPesoDespegue || textField == txtPesoCombustible){
            
            editable = false
        
        }else if(textField === txtFecha){
            if(self.VerificaIdBitacora()){
            textField.resignFirstResponder()
            DatePickerDialog().show("Fecha del Vuelo", doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", datePickerMode: .date) {
                (date) -> Void in
                if date != nil {
                textField.text = self.dateformatter.string(from: date!)
                _ = self.GuardarInformacion()
                    self.txtCliente.becomeFirstResponder()
                }else{
                   self.txtCliente.becomeFirstResponder()
                }
            }
            }
        }else if(textField === txtUTCSale || textField === txtUTCLlega){
            //textField.resignFirstResponder()
            var titulo = ""
            if (textField === txtUTCSale){
                titulo = "Hora Local Salida"
            }
            else{
                titulo = "Hora Local Llegada"
            }
            
            DatePickerDialog().show( "DatePicker", doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", datePickerMode: .time) { date in
                    if let dt = date {
                        let formatohora : DateFormatter = DateFormatter()
                        formatohora.timeZone = TimeZone.init(abbreviation: "UTC")
                            formatohora.dateFormat = "HH:mm"
                        textField.text = formatohora.string(from: dt)
                        self.calculaTiempoVuelo()
                        _ = self.GuardarInformacion()
                    }
                }
            
            
        /*    DatePickerDialog().show(title: titulo, doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", datePickerMode: .time) {
                (time) -> Void in
                 if time != nil {
                let formatohora : DateFormatter = DateFormatter()
                formatohora.timeZone = TimeZone.init(abbreviation: "UTC")
                    formatohora.dateFormat = "HH:mm"
                textField.text = formatohora.string(from: time!)
                self.calculaTiempoVuelo()
                _ = self.GuardarInformacion()
                }
                
            }*/
        }
        else{
            editable = true
        }
        
        print(global_var.j_avion_tipomotor)
        if(global_var.j_avion_tipomotor == "1" || global_var.j_avion_tipomotor == "3"){
            
            if(textField == txtPesoAterrizaje){
                editable=false
            }
        }
        
        return editable
    }
    
    @objc func Formatear(textField: UITextField){
        
        textField.text = textField.text!.replacingOccurrences(of: ",", with: "")
        let f : NumberFormatter = NumberFormatter();
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        
        let str = textField.text!
        
        if (str != ""){
            let lastChar = str.last!
            if(textField.text!.count < 11){
                if (lastChar != "." && lastChar != "-") {
                    if (textField.text!.range(of: ".0")) != nil { // rangeOfString(".0")) != nil {
                        print(textField.text!)
                        if (lastChar != "0"){
                            if let formateado = f.number(from: textField.text!) {
                                textField.text = f.string(from: formateado)!
                            }
                            else{
                                textField.text = textField.text!.substring(to: textField.text!.endIndex) // substringToIndex(textField.text!.endIndex)
                                //substringToIndex(textField.text!.indexOf(<#T##element: Character##Character#>))  //textField.text!.substring(to: textField.text!.index(before: textField.text!.endIndex))
                            }
                        }
                    }else{
                        
                        if let formateado = f.number(from: textField.text!) {
                            textField.text = f.string(from: formateado)!
                        }else{
                            textField.text = textField.text!.substring(to: textField.text!.endIndex) //substring(to: textField.text!.index(before: textField.text!.endIndex))
                        }
                        
                    }
                }
            }else{
                textField.text = textField.text!.substring(to: textField.text!.endIndex) // textField.text!.substring(to: textField.text!.index(before: textField.text!.endIndex))
                
                if let formateado = f.number(from: textField.text!) {
                    textField.text = f.string(from: formateado)!
                }else{
                    textField.text = textField.text!.substring(to: textField.text!.endIndex)//textField.text!.sub   substring(to: textField.text!.index(before: textField.text!.endIndex))
                }
            }
        }
    }
    
    // MARK: - Funciones Locales
    
    
    func mostrarFecha(sender: UITextField) {
        
       	sender.resignFirstResponder()
        DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            sender.text = self.dateformatter.string(from: date!)
            
        }
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if(GuardarInformacion()){
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    func GuardarInformacion() -> Bool {
        
        var ok = false
        
        if global_var.j_bitacora_abierta == 1 {
                ok = self.GuardarTramo()
                self.btnCancelar.title = "Cancelar"
            }else{
            Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
        }
        print(ok)
        return ok
    }
    
    
    func VerificaIdBitacora() -> Bool {
        
        var registrado : Bool = false
        if(!txtBitacora.text!.isEmpty){
            if let cc = formatter.number(from: txtBitacora.text! as String) {
                _ultimabitacora = cc
            }
        }
        
        if((_ultimabitacora) as! Int > 0) {
            registrado = true
        }
        
        return registrado
        
    }
    
    func GuardarBitacora() -> Bool {
        
        print("Guardando bitacora")
        print(txtBitacora.text!)
        var registrado : Bool = false
        if(!txtBitacora.text!.isEmpty){
            if let cc = formatter.number(from: txtBitacora.text! as String) {
                _ultimabitacora = cc
                
            }
        }
        
        if((_ultimabitacora) as! Int > 0) {
            
            dateFormatter.dateStyle = .short //Set date style
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let FechaRegistro = date
            var FechaVuelo = date
            
            if (!txtFecha.text!.isEmpty){
                FechaVuelo = dateformatter.date(from: txtFecha.text!)! as NSDate
            }
            
            var nombrecapitan = global_var.j_usuario_nombre
            if !txtNombrePiloto.text!.isEmpty{
                nombrecapitan = txtNombrePiloto.text!
            }
            
            var licenciacapitan = String(global_var.j_piloto_licencia)
            if !txtLicenciaPiloto.text!.isEmpty{
                licenciacapitan = txtLicenciaPiloto.text!
            }
            
            var nombrecopiloto = ""
            if !txtNombreCopiloto.text!.isEmpty {
                nombrecopiloto = txtNombreCopiloto.text!
            }
            
            var licenciacopiloto = ""
            if !txtLicenciaCopiloto.text!.isEmpty {
                licenciacopiloto = txtLicenciaCopiloto.text!
            }
            
            if global_var.j_bitacoras_Id == 0 { //Agregar nueva bitacora
               
                print(global_var.j_bitacoras_Id)
                
                global_var.j_bitacoras_Id = _ultimabitacora
                global_var.j_bitacora_ultima_bitacora = _ultimabitacora
                global_var.j_bitacora_ultimo_destino = txtLlega.text!
                global_var.j_bitacora_ultimo_horometro = _horometrollega
                global_var.j_bitacora_ultimo_aterrizaje = _aterrizajemotor1
                global_var.j_bitacora_ultimo_ciclo = _ciclosmotor1
                txtBitacora.text = "\(global_var.j_bitacoras_Id)"
                
                if(!coreDataStack.obtenerIdBitacora(matricula: global_var.j_avion_matricula, numbitacora: _ultimabitacora)) {
                    
                    coreDataStack.agregarBitacora(accioncorreectiva: "", aterrizajes: 0, capitan: global_var.j_piloto_id, capitannombre: nombrecapitan, capitanlicencia: licenciacapitan, ciclos: _ciclosmotor1, ciclosapu: 0, cliente: txtCliente.text!, copiloto: licenciacopiloto, copilotonombre: nombrecopiloto, fecharegistro: FechaRegistro, fechavuelo:  FechaVuelo, horometroapu: 0, horometrollegada: _horometrollega, horometrosalida: _horometrosale, hoy: 1, idbitacora: _ultimabitacora , idservidor: 0, ifr: NSNumber(value: IFR), legid: formatter.number(from:
                        global_var.j_vuelo_legid)!, licenciatecnico: "", mantenimientodgac: global_var.j_bitacora_mantenimientoDGAC, mantenimientointerno: global_var.j_bitacora_mantenimientoInterno, matricula: global_var.j_avion_matricula, nocturno: "", nombretecnico: "", numbitacora: _ultimabitacora, quienprevuelo: global_var.j_bitacora_prevuelo, reportes: "", serie: "", sincronizado: 0, status: 1, totalaterrizaje: _aterrizajemotor1, tv: _TV, modificada: global_var.j_bitacora_modificada, modificadatotal: global_var.j_bitacora_nummodificada, prevuelolocal: global_var.j_bitacora_prevuelolocal)
                    
                    global_var.j_bitacora_num = _ultimabitacora
                    global_var.j_bitacora_abierta = 1
                    print("Se registro Bitacora con  ID: \(_ultimabitacora)")
                    
                    //Actualizo el vuelo a realizado
                    coreDataStack.actualizaVueloRealizado(legid: global_var.j_vuelo_legid)
                    
                    registrado = true
                    
                }else{
                    Util.invokeAlertMethod(strTitle: "Error", strBody: "El numero de bitacora ya existe, verifica los datos", delegate: self)
                    global_var.j_bitacoras_Id  = 0
                    
                    
                }
                
            }else{
                
                print("Se actualizo Bitacora con ID: \(global_var.j_bitacoras_Id)")
                print("Se actualizo Bitacora con numero: \(_ultimabitacora)")
                
                coreDataStack.actualizarBitacora(accioncorreectiva: "", aterrizajes: 0, capitan: global_var.j_piloto_id, capitannombre: nombrecapitan, capitanlicencia: licenciacapitan, ciclos: _ciclosmotor1, ciclosapu: 0, cliente: txtCliente.text!, copiloto: licenciacopiloto, copilotonombre: nombrecopiloto, fecharegistro: FechaRegistro, fechavuelo: dateformatter.date(from: txtFecha.text!)! as NSDate, horometroapu: 0, horometrollegada: _horometrollega, horometrosalida: _horometrosale, hoy: 1, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, ifr: NSNumber(value: IFR), legid:  formatter.number(from: global_var.j_vuelo_legid)!, licenciatecnico: "", mantenimientodgac: global_var.j_bitacora_mantenimientoDGAC, mantenimientointerno: global_var.j_bitacora_mantenimientoInterno, matricula: global_var.j_avion_matricula, nocturno: "", nombretecnico: "", numbitacora: _ultimabitacora, quienprevuelo: global_var.j_bitacora_prevuelo, reportes: "", serie: "", sincronizado: 0, status: 1, totalaterrizaje: _aterrizajemotor1, tv: 0, modificada: global_var.j_bitacora_modificada, modificadatotal:  global_var.j_bitacora_nummodificada, prevuelolocal: global_var.j_bitacora_prevuelolocal)
                
                global_var.j_bitacora_num = _ultimabitacora
                
                registrado = true
            }
        }
        else{
            Util.invokeAlertMethod(strTitle: "Error", strBody: "Debes ingresar un número de bitácora valido", delegate: self)
            
        }
        
        return registrado
        
    }
    
    func GuardarTramo() -> Bool {
        
        var ok = false
        if(!txtBitacora.text!.isEmpty){
            if let cc = formatter.number(from: txtBitacora.text! as String) {
                _ultimabitacora = cc
            }
        }
        
        if(txtCalzos.text! != "00:00"){
            
            if((_ultimabitacora) as! Int > 0) {
                
                if self.pesoDespegue <= global_var.j_avion_mtow {
                    
                    formatter.decimalSeparator = "."
                    formatter.numberStyle = .decimal
                    
                    if global_var.j_avion_tipomotor != "2" {
                        
                        if global_var.j_avion_tipomotor == "1" || global_var.j_avion_tipomotor == "3" {
                            
                            if(!txtAceiteCargardoMotor.text!.isEmpty){
                                if let cc = formatter.number(from: txtAceiteCargardoMotor.text! as String) {
                                    _aceitecargadomotor = cc
                                }else{
                                    txtAceiteCargardoMotor.text = ""
                                }
                            }
                            
                            if global_var.j_avion_tipomotor == "1" {
                                if(!txtAceiteCargoAPU.text!.isEmpty){
                                    if let cc = formatter.number(from: txtAceiteCargoAPU.text! as String) {
                                        _aceitecargadoapu = cc
                                    }else{
                                        txtAceiteCargoAPU.text = ""
                                    }
                                }
                            }
                        }
                        
                        
                        if(!txtCombustibleCargado.text!.isEmpty){
                            if let cc = formatter.number(from: txtCombustibleCargado.text! as String) {
                                _combustiblecargado = cc
                            }else{
                                txtCombustibleCargado.text = ""
                            }
                        }
                        
                        
                        if(!txtPesoAterrizaje.text!.isEmpty){
                            if let cc = formatter.number(from: txtPesoAterrizaje.text! as String) {
                                _pesoaterrizaje = cc
                            }else{
                                txtPesoAterrizaje.text = ""
                            }
                        }
                    }
                    
                    
                    if(!txtHorometroLlega.text!.isEmpty){
                        if let cc = formatter.number(from: txtHorometroLlega.text! as String) {
                            global_var.j_bitacora_ultimo_horometro = cc
                        }else{
                            txtHorometroLlega.text = "0"
                        }
                    }
                    
                    if(!txtBitacora.text!.isEmpty){
                        if let cc = formatter.number(from: txtBitacora.text! as String) {
                                _ultimabitacora = cc
                        }else{
                            txtBitacora.text = "0"
                        }
                    }
                    
                    if(!txtCalzos.text!.isEmpty){
                        _calzos = (txtCalzos.text! as NSString) as String
                    }
                    
                    if(!txtCombustibleLlega.text!.isEmpty){
                        if let cc = formatter.number(from: txtCombustibleLlega.text! as String) {
                            _combustiblellega = cc
                        }else{
                            txtCombustibleLlega.text = ""
                        }
                    }
                    if(!txtCombustibleSale.text!.isEmpty){
                        if let cc = formatter.number(from: txtCombustibleSale.text! as String) {
                            _combustiblesale = cc
                        }else{
                            txtCombustibleSale.text = ""
                        }
                    }
                    if(!txtConsumo.text!.isEmpty){
                        if let cc = formatter.number(from: txtConsumo.text! as String){
                            _combustibleconsumo = cc
                        }else{
                            txtConsumo.text = ""
                        }
                    }
                    if(!txtHorometroLlega.text!.isEmpty){
                        if let cc = formatter.number(from: txtHorometroLlega.text! as String){
                            _horometrollega = cc
                        }else{
                            txtHorometroLlega.text = ""
                        }
                    }
                    if(!txtHorometroSale.text!.isEmpty){
                        if let cc = formatter.number(from: txtHorometroSale.text! as String) {
                            _horometrosale = cc
                        }else{
                            txtHorometroSale.text = ""
                        }
                    }
                    if(!txtNivelVuelo.text!.isEmpty){
                        if let cc = formatter.number(from: txtNivelVuelo.text! as String) {
                            _nivelvuelo = cc
                        }else{
                            txtNivelVuelo.text = ""
                        }
                    }
                    if(!txtPesoCombustible.text!.isEmpty){
                        if let cc = formatter.number(from: txtPesoCombustible.text! as String) {
                            _pesocombustible = cc
                        }else{
                            txtPesoCombustible.text = ""
                        }
                    }
                    if(!txtPesoDespegue.text!.isEmpty){
                        if let cc = formatter.number(from: txtPesoDespegue.text! as String){
                            _pesodespegue = cc
                        }else{
                            txtPesoDespegue.text = ""
                        }
                    }
                    if(!txtPesoOperacion.text!.isEmpty){
                        if let cc = formatter.number(from: txtPesoOperacion.text! as String) {
                            _pesooperacion = cc
                        }else{
                            txtPesoOperacion.text = ""
                        }
                    }
                    if(!txtPesoCarga.text!.isEmpty){
                        if let cc = formatter.number(from: txtPesoCarga.text! as String) {
                            _pesocarga = cc
                        }else{
                            txtPesoCarga.text = ""
                        }
                    }
                    if(!txtTV.text!.isEmpty){
                        if let cc = formatter.number(from: txtTV.text! as String) {
                            _TV = cc
                        }else{
                            txtTV.text = ""
                        }
                    }
                    
                    if(!txtAterrizaje.text!.isEmpty){
                        if let cc = formatter.number(from: txtAterrizaje.text! as String) {
                            _aterrizajemotor1 = cc
                        }else{
                            txtAterrizaje.text = ""
                        }
                    }
                    
                    if(!txtciclos.text!.isEmpty){
                        if let cc = formatter.number(from: txtciclos.text! as String) {
                            _ciclosmotor1 = cc
                        }else{
                            txtciclos.text = ""
                        }
                    }
                    
                    if(self.GuardarBitacora())
                    {
                        if(global_var.j_bitacoras_Id != 0){
                            
                            if(global_var.j_tramos_Id == 0){
                                
                                global_var.j_tramos_Id = self.coreDataStack.obtenerIdTramo()
                                
                                self.coreDataStack.agregarTramo(aceitecargado: _aceitecargadomotor, aceitecargadoapu: _aceitecargadoapu, calzoacalzo: _calzos, capitan_altimetrorvsm: 0, combustibleaterrizaje: _combustiblellega, combustiblecargado: _combustiblecargado, combustibleconsumido: _combustibleconsumo, combustibledespegue: _combustiblesale, coordenadasregistradas: "", destino: self.txtLlega.text!.uppercased(), destinociudad: self.txtLlega.text!.uppercased(), horallegada: self.txtUTCLlega.text!, horasalida: self.txtUTCSale.text!, horometroaterrizaje: _horometrollega, horometrodespegue: _horometrosale, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nivelvuelo: _nivelvuelo, numbitacora: global_var.j_bitacora_num, oat: 0, origen: self.txtSale.text!.uppercased(), origenciudad: self.txtSale.text!.uppercased(), pesoaterrizaje: _pesoaterrizaje , pesocarga: _pesocarga, pesocombustible: _pesocombustible, pesodespegue: _pesodespegue, pesoperacion: _pesooperacion, primeroficialaltimetrorvsm: "", tv: _TV, combustibleunidadmedida: "\(self.SegmentoUnidadMedida.selectedSegmentIndex)", combustibleunidadpeso: "\(global_var.j_avion_unidadpesofuel)", matricula: global_var.j_avion_matricula)
                                
                                //Agregar los pax de la tabla de vuelos a la tabla de bitacoras
                                self.coreDataStack.agregarPasajeroDeVuelosABitacoras(legid: global_var.j_vuelo_legid, idbitacora: global_var.j_bitacoras_Id, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula)
                                
                                ok = true
                                
                            }else{
                                
                                self.coreDataStack.actualizaTramo(aceitecargado: _aceitecargadomotor, aceitecargadoapu: _aceitecargadoapu, calzoacalzo: _calzos, capitan_altimetrorvsm: 0, combustibleaterrizaje: _combustiblellega, combustiblecargado: _combustiblecargado, combustibleconsumido: _combustibleconsumo, combustibledespegue: _combustiblesale, coordenadasregistradas: "", destino: self.txtLlega.text!.uppercased(), destinociudad: self.txtLlega.text!.uppercased(), horallegada: self.txtUTCLlega.text!, horasalida: self.txtUTCSale.text!, horometroaterrizaje: _horometrollega, horometrodespegue: _horometrosale, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nivelvuelo: _nivelvuelo, numbitacora: global_var.j_bitacora_num, oat: 0, origen: self.txtSale.text!.uppercased(), origenciudad: self.txtSale.text!.uppercased(), pesoaterrizaje: _pesoaterrizaje, pesocarga: _pesocarga, pesocombustible: _pesocombustible, pesodespegue: _pesodespegue, pesoperacion: _pesooperacion, primeroficialaltimetrorvsm: "", tv: _TV,combustibleunidadmedida: "\(self.SegmentoUnidadMedida.selectedSegmentIndex)", combustibleunidadpeso: "\(global_var.j_avion_unidadpesofuel)", matricula: global_var.j_avion_matricula)
                                
                            }
                            
                            ok = true
                        }
                        else{
                            Util.invokeAlertMethod(strTitle: "Error", strBody: "Es necesario primero registrar la bitácora, consulta al administrador", delegate: self)
                        }
                    }
                    
                    print("Bitácora registrada con el folio: \(global_var.j_bitacora_num)")
                    
                    
                }else{
                    
                    let diferencia = self.pesoDespegue   - global_var.j_avion_mtow
                    
                    txtPesoDespegue.backgroundColor = UIColor.red
                    txtPesoDespegue.textColor = UIColor.white
                    
                    Util.invokeAlertMethod(strTitle: "Alerta", strBody: "Verifica tu peso de despegue, excedes MTOW ( \(diferencia) ). Verifica la información" as NSString, delegate: self)
                }
                
                print(ok)
                
                
            }else{
                txtFecha.resignFirstResponder()
                txtBitacora.becomeFirstResponder()
                Util.invokeAlertMethod(strTitle: "Error", strBody: "Debes ingresar un número de bitácora válido", delegate: self)
                
                
            }
        }else{
            txtCalzos.resignFirstResponder()
            txtCalzos.becomeFirstResponder()
            Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica el tiempo calzo a calzo", delegate: self)
        }
        
        
        return ok
    }
    
    @IBAction func btnCancelar(sender: AnyObject) {
        regresarABitacoras()
    }
    
    func regresarABitacoras() {
        
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        if global_var.j_bitacoras_Id == 0{
            destviewcontroller.selectedIndex = 0
        }else{
         destviewcontroller.selectedIndex = 1
        }
        
        self.present(destviewcontroller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func mostrarMenu(sender: AnyObject) {
        
        let mensaje = "Se cerrará la bitácora con el folio: ** " + txtBitacora.text! + " ** "
        
        let alertController = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitácora", style: .default){ action -> Void in
            
            if (global_var.j_bitacora_abierta == 1){
                
                
                if(self.GuardarInformacion()){
                    
                    if(global_var.j_bitacoras_Id == 0){
                        //La esta cerrando sin registrar otros vistas
                        if(self.GuardarTramo()){
                            print("Se guardo correctamente")
                        }
                    }
                    
                    
                    //Verifico si registro un copiloto, solicitar el numero de licencia
                    let copiloto = self.txtNombreCopiloto.text!
                    var copiloto_error = false
                    
                    if copiloto.count > 0 {
                        
                        if self.txtLicenciaCopiloto.text!.isEmpty {
                            copiloto_error = true
                        }
                    }
                    
                    if copiloto_error == false {
                        
                        let Status = self.coreDataStack.verificaBitacoraPorCerrar(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                        
                        //Cierro la bitacora para la sincronizacion
                        if(Status == "Sin Error"){
                            
                            if(self.GuardarInformacion()){
                                
                                self.coreDataStack.actualizaUltimaInformacion(matricula: self.txtMatricula.text!, ultimabitacora: self.formatter.number(from: self.txtBitacora.text!)!, ultimodestino: self.txtLlega.text!, ultimohorometro: self.formatter.number(from: self.txtHorometroLlega.text!)!, ultimohorometroapu: global_var.j_avion_ultimohorometroapu, sincronizado: 0, ultimoaterrizaje:  self.formatter.number(from: self.txtAterrizaje.text!)!, ultimociclo: self.formatter.number(from: self.txtciclos.text!)!)
                                
                                self.coreDataStack.cerrarBitacora(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                                Util.invokeAlertMethod(strTitle: "Bitácora Cerrada", strBody: "Revisa la información y sincroniza la bitácora.", delegate: self)
                                /*
                                 Se cambio por petición del Lic. Stein - 26/Mayo/2016 que no se sincronizaran las bitácoras de manera automatica
                                 
                                 //NSNotificationCenter.defaultCenter().postNotificationName("sincronizarBitacoras", object: nil)
                                 //Util.invokeAlertMethod(strTitle: "Bitácora Cerrada", strBody: "Estara en proceso de sincronización.", delegate: self)
                                 
                                 */
                                self.regresarABitacoras()
                            }
                        }else{
                            Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica: \(Status)" as NSString, delegate: self)
                            if let tabBarController = self.tabBarController {
                                tabBarController.selectedIndex = 0
                            }
                            
                        }
                    }else{
                          Util.invokeAlertMethod(strTitle: "Error", strBody: "Es necesario la licencia del copiloto.", delegate: self)
                        self.txtLicenciaCopiloto.becomeFirstResponder()
                    }
                }
            }
            else{
                
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    /* Fin Funciones Locales */
    

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        let titulo = ""
        var kglbs = ""
        if global_var.j_avion_unidadpesoavion == 0 {
            kglbs = "LBS"
        }
        else{
            kglbs = "KG"
        }
        
        
        switch(section){
        case 0:
            return "VUELO"
        case 1:
            return "RUTA"
        case 2:
            return "TIEMPOS"
        case 3:
            return "COMBUSTIBLES"
        case 4:
            if global_var.j_avion_tipomotor == "2" {
                return "PESOS EN " + kglbs
            }else if global_var.j_avion_tipomotor == "1" {
                return "ACEITES"
            }else if global_var.j_avion_tipomotor == "3" {
                return "ACEITE "
            }
        case 5:
            if global_var.j_avion_tipomotor == "2" {
                return "ATERRIZAJES / CICLOS "
            }else if global_var.j_avion_tipomotor == "3" {
                return  "PESOS EN " + kglbs
            }
            else if global_var.j_avion_tipomotor == "1"{
               return "PESOS EN " + kglbs
            }else{
                break
            }
        case 6:
            if global_var.j_avion_tipomotor == "1" || global_var.j_avion_tipomotor == "3" {
                return  "ATERRIZAJES / CICLOS " 
            }
            else{
                break
            }
            
        default:
            break
        }
        
        return titulo
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        var altura : CGFloat = 90
        
        if DeviceType.IS_IPAD{
            altura = 90
        }else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_5 {
            altura = 60
        }else{
            altura = 90
        }
        
        return altura
    }
    

}
