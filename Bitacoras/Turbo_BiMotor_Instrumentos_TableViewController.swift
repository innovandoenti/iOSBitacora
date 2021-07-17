//
//  Turbo_BiMotor_Instrumentos_TableViewController.swift


import UIKit
import CoreData


class Turbo_BiMotor_Instrumentos_TableViewController: UITableViewController, UITextFieldDelegate {
    
    var totalArray : NSMutableArray = NSMutableArray()
    var logica = Util()
    var coreDataStack = CoreDataStack()
    let formatter : NumberFormatter = NumberFormatter()
    
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:16, 16:17, 17:18, 18:19, 19:20, 20:21, 21:22,22:23,23:24,24:25,25:26,26:27,27:0]
    
    
    @IBOutlet weak var txtvv_motor1: UITextField!
    @IBOutlet weak var txtvv_motor2: UITextField!
    @IBOutlet weak var txtvi_motor1: UITextField!
    @IBOutlet weak var txtvi_motor2: UITextField!
    @IBOutlet weak var txttorque_motor1: UITextField!
    @IBOutlet weak var txttorque_motor2: UITextField!
    @IBOutlet weak var txtitt_motor1: UITextField!
    @IBOutlet weak var txtitt_motor2: UITextField!
    @IBOutlet weak var txtrpm_motor1: UITextField!
    @IBOutlet weak var txtrpm_motor2: UITextField!
    @IBOutlet weak var txtrpmhelice_motor1: UITextField!
    @IBOutlet weak var txtrpmhelice_motor2: UITextField!
    @IBOutlet weak var txtff_motor1: UITextField!
    @IBOutlet weak var txtff_motor2: UITextField!
    @IBOutlet weak var txtot_motor1: UITextField!
    @IBOutlet weak var txtot_motor2: UITextField!
    @IBOutlet weak var txtop_motor1: UITextField!
    @IBOutlet weak var txtop_motor2: UITextField!
    @IBOutlet weak var txtoat: UITextField!
    @IBOutlet weak var txtvolts_motor1: UITextField!
    @IBOutlet weak var txtvolts_motor2: UITextField!
    @IBOutlet weak var txtamps_motor1: UITextField!
    @IBOutlet weak var txtamps_motor2: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    
    //Actualización 18 de Abril
    @IBOutlet weak var txtfflow_in: UITextField!
    @IBOutlet weak var txtfflow_in_motor2: UITextField!
    @IBOutlet weak var txtfflow_out: UITextField!
    @IBOutlet weak var txtfflow_out_motor2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       configuraView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Funciones Locales
    func configuraView(){
        
        txtvv_motor1.delegate = self
        txtvv_motor2.delegate = self
        txtvi_motor1.delegate = self
        txtvi_motor2.delegate = self
        txttorque_motor1.delegate = self
        txttorque_motor2.delegate = self
        txtitt_motor1.delegate = self
        txtitt_motor2.delegate = self
        txtrpm_motor1.delegate = self
        txtrpm_motor2.delegate = self
        txtrpmhelice_motor1.delegate = self
        txtrpmhelice_motor2.delegate = self
        txtff_motor1.delegate = self
        txtff_motor2.delegate = self
        txtot_motor1.delegate = self
        txtot_motor2.delegate = self
        txtop_motor1.delegate = self
        txtop_motor2.delegate = self
        txtoat.delegate = self
        txtvolts_motor1.delegate = self
        txtvolts_motor2.delegate = self
        txtamps_motor1.delegate = self
        txtamps_motor2.delegate = self
        
        txtfflow_in.delegate = self
        txtfflow_in_motor2.delegate = self
        txtfflow_out.delegate = self
        txtfflow_out_motor2.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        txtvv_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtvv_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtvi_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtvi_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txttorque_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txttorque_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtitt_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtitt_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtrpm_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtrpm_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtrpmhelice_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtrpmhelice_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtff_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtff_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtot_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtot_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtop_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtop_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtoat.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtvolts_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtvolts_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtamps_motor1.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtamps_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        
        txtfflow_in.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtfflow_in_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtfflow_out.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        txtfflow_out_motor2.addTarget(self, action: #selector(Turbo_BiMotor_Instrumentos_TableViewController.Formatear(textField: )), for: .editingChanged)
        
        if(global_var.j_tramos_Id != 0){
            //Viene de consultar una bitacora y quiere modificar en caso de estar abierta
            cargarInstrumentos()
        }
        
    }
    
    @objc func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func cargarInstrumentos(){
        
        
        let error: NSError?
        let formato : NumberFormatter = NumberFormatter()
        formato.numberStyle = .decimal
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
        let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id, global_var.j_avion_matricula])
        fetchRequest.predicate = predicate
        
        do{
            let fetchResults = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [BitacorasInstrumentos]
            
            if (fetchResults?.count)! > 0 {
                
                if let aviones = fetchResults{
                    
                    for row in aviones{
                        
                        global_var.j_instrumentos_Id = row.idlectura!
                        
                        
                        let torque = row.turbo_torque!
                        let torque_motor2 = row.turbo_torque_motor2!
                        let rpm = row.turbo_helicerpm!
                        let rpm_motor2 = row.turbo_helicerpm_motor2!
                        let itt = row.turbo_itt!
                        let itt_motor2 = row.turbo_itt_motor2!
                        let ng = row.turbo_ng!
                        let ng_motor2 = row.turbo_ng_motor2!
                        let pressaceite = row.turbo_oilpress!
                        let pressaceite_motor2 = row.turbo_oilpress_motor2!
                        let tempaceite = row.turbo_oiltemp!
                        let tempaceite_motor2 = row.turbo_oiltemp_motor2!
                        let flujocomb = row.turbo_fflow!
                        let flujocomb_motor2 = row.turbo_fflow_motor2!
                        let dcac = row.turbo_dcac!
                        let dcac_motor2 = row.turbo_dcac_motor2!
                        let amps = row.turbo_amp!
                        let amps_motor2 = row.turbo_amp_motor2!
                        
                        let avionserie = row.turbo_avion_serie!
                        let avionciclos = row.turbo_avion_ciclos!
                        let avionturm = row.turbo_avion_turm!
                        let aviontt = row.turbo_avion_tt!
                        
                        let motorserie = row.turbo_motor_serie!
                        let motorciclos = row.turbo_motor_ciclos!
                        let motorturm = row.turbo_motor_turm!
                        let motortt = row.turbo_motor_tt!
                        
                        let heliceserie = row.turbo_helice_serie!
                        let heliceciclos = row.turbo_helice_ciclos!
                        let heliceturm = row.turbo_helice_turm!
                        let helicett = row.turbo_helice_tt!
                        
                        let vv = row.turbo_vv!
                        let vv_motor2 = row.turbo_vv_motor2!
                        let vi = row.turbo_ias!
                        let vi_motor2 = row.turbo_ias_motor2!
                        let oat = row.turbo_oat!
                        
                        let fflow_in = row.turbo_fflow_in!
                        let fflow_in_motor2 = row.turbo_fflow_in_motor2!
                        let fflow_out = row.turbo_fflow_out!
                        let fflow_out_motor2 = row.turbo_fflow_out_motor2!
                        
                        
                        txttorque_motor1.text = formato.string(from: torque)
                        txttorque_motor2.text = formato.string(from:torque_motor2)
                        txtrpmhelice_motor1.text = formato.string(from:rpm)
                        txtrpmhelice_motor2.text = formato.string(from:rpm_motor2)
                        txtitt_motor1.text = formato.string(from:itt)
                        txtitt_motor2.text = formato.string(from:itt_motor2)
                        txtvv_motor1.text = formato.string(from:vv)
                        txtvv_motor2.text = formato.string(from:vv_motor2)
                        txtvi_motor1.text = formato.string(from:vi)
                        txtvi_motor2.text = formato.string(from:vi_motor2)
                        txtrpm_motor1.text = formato.string(from:ng)
                        txtrpm_motor2.text = formato.string(from:ng_motor2)
                        txtff_motor1.text = formato.string(from:flujocomb)
                        txtff_motor2.text = formato.string(from:flujocomb_motor2)
                        txtot_motor1.text = formato.string(from:tempaceite)
                        txtot_motor2.text = formato.string(from:tempaceite_motor2)
                        txtop_motor1.text = formato.string(from:pressaceite)
                        txtop_motor2.text = formato.string(from:pressaceite_motor2)
                        txtoat.text = formato.string(from:oat)
                        txtvolts_motor1.text = formato.string(from:dcac)
                        txtvolts_motor2.text = formato.string(from:dcac_motor2)
                        txtamps_motor1.text = formato.string(from:amps)
                        txtamps_motor2.text = formato.string(from:amps_motor2)
                        
                        txtfflow_in.text = formato.string(from:fflow_in)
                        txtfflow_in_motor2.text = formato.string(from:fflow_in_motor2)
                        txtfflow_out.text = formato.string(from:fflow_out)
                        txtfflow_out_motor2.text = formato.string(from:fflow_out_motor2)
                        
                        
                    }
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    @objc func Formatear(textField: UITextField){
        
        textField.text = textField.text!.replacingOccurrences(of: ",", with: "")
        //stringByReplacingOccurrencesOfString(",", withString: "")
        let f : NumberFormatter = NumberFormatter();
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        
        let str = textField.text!
        
        if (str != ""){
            let lastChar = str.last!
            if(textField.text!.count < 11){
                if (lastChar != "." && lastChar != "-") {
                    if (textField.text!.range(of: ".0")) != nil {
                        // rangeOfString(".0"))
                        print(textField.text!)
                        if (lastChar != "0"){
                            if let formateado = f.number(from: textField.text!) {
                                textField.text = f.string(from:formateado)!
                            }
                            else{
                                textField.text = textField.text!.substring(to: textField.text!.endIndex)// substringToIndex(textField.text!.endIndex)
                                //substringToIndex(textField.text!.indexOf(<#T##element: Character##Character#>))  //textField.text!.substring(to: textField.text!.index(before: textField.text!.endIndex))
                            }
                        }
                    }else{
                        
                        if let formateado = f.number(from: textField.text!) {
                            textField.text = f.string(from:formateado)!
                        }else{
                            textField.text = textField.text!.substring(to: textField.text!.endIndex)
                            //textField.text!.substringToIndex(textField.text!.endIndex) //substring(to: textField.text!.index(before: textField.text!.endIndex))
                        }
                        
                    }
                }
            }else{
                textField.text = textField.text!.substring(to: textField.text!.endIndex) // textField.text!.substring(to: textField.text!.index(before: textField.text!.endIndex))
                
                if let formateado = f.number(from: textField.text!) {
                    textField.text = f.string(from:formateado)!
                }else{
                    textField.text = textField.text!.substring(to: textField.text!.endIndex) //textField.text!.sub   substring(to: textField.text!.index(before: textField.text!.endIndex))
                }
            }
        }
    }
    
        
    
    func GuardarInformacion(){
        if global_var.j_bitacora_abierta == 1 {
            self.GuardarInstrumentos()
            
        }else{
            Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
        }
    }
    
    @IBAction func Menu(sender: UIBarButtonItem) {
        
        let mensaje = "Se cerrará la bitácora con el folio: ** \(global_var.j_bitacora_num) ** "
        
        let alertController = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .default){ action -> Void in
            
            if (global_var.j_bitacora_abierta == 1){
                
                
                if(global_var.j_bitacoras_Id == 0){
                    //La esta cerrando sin registrar otros vistas
                    self.GuardarInstrumentos()
                    
                }
                
                let Status = self.coreDataStack.verificaBitacoraPorCerrar(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                
                //Cierro la bitacora para la sincronizacion
                if(Status == "Sin Error"){
                    
                    self.GuardarInformacion()
                    
                    self.coreDataStack.actualizaUltimaInformacion(matricula: global_var.j_avion_matricula, ultimabitacora: global_var.j_avion_ultimabitacora, ultimodestino: global_var.j_avion_ultimodestino, ultimohorometro: global_var.j_avion_ultimohorometro, ultimohorometroapu: global_var.j_avion_ultimohorometroapu, sincronizado: 0, ultimoaterrizaje:  ( NSNumber(value: global_var.j_avion_ultimoaterrizaje.intValue + 1)), ultimociclo: (NSNumber(value: global_var.j_avion_ultimociclo.intValue + 1)))
                    
                    self.coreDataStack.cerrarBitacora(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                    Util.invokeAlertMethod(strTitle: "Bitácora Cerrada", strBody: "Revisa tu información y sincroniza tu bitácora.", delegate: self)
                    /*
                     Se cambio por petición del Lic. Stein - 26/Mayo/2016 que no se sincronizaran las bitácoras de manera automatica
                     
                     //NSNotificationCenter.defaultCenter().postNotificationName("sincronizarBitacoras", object: nil)
                     //Util.invokeAlertMethod("Bitácora Cerrada", strBody: "Estara en proceso de sincronización.", delegate: self)
                     
                     */
                    self.regresarABitacoras()
                }else{
                    Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica \(Status)" as NSString, delegate: self)
                    if let tabBarController = self.tabBarController {
                        tabBarController.selectedIndex = 0
                    }
                    
                }
            }
            else{
                
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
        
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
  
    
    func GuardarInstrumentos(){
        
        
        var vv_motor1 : NSNumber = 0
        var vv_motor2 : NSNumber = 0
        var vi_motor1 : NSNumber = 0
        var vi_motor2 : NSNumber = 0
        var torque_motor1 : NSNumber = 0
        var torque_motor2 : NSNumber = 0
        var itt_motor1 : NSNumber = 0
        var itt_motor2 : NSNumber = 0
        var rpm_motor1 : NSNumber = 0
        var rpm_motor2 : NSNumber = 0
        var rpmhelice_motor1 : NSNumber = 0
        var rpmhelice_motor2 : NSNumber = 0
        var ff_motor1 : NSNumber = 0
        var ff_motor2 : NSNumber = 0
        var ot_motor1 : NSNumber = 0
        var ot_motor2 : NSNumber = 0
        var op_motor1 : NSNumber = 0
        var op_motor2 : NSNumber = 0
        var oat : NSNumber = 0
        var volts_motor1 : NSNumber = 0
        var volts_motor2 : NSNumber = 0
        var amps_motor1 : NSNumber = 0
        var amps_motor2 : NSNumber = 0
        
        let avionserie: String = ""
        var avionciclos: NSNumber = 0
        var avionturm: NSNumber = 0
        var aviontt: NSNumber = 0
        var motorserie: String = ""
        var motorciclos: NSNumber = 0
        var motorturm: NSNumber = 0
        var motortt: NSNumber = 0
        var heliceserie: String = ""
        var heliceciclos: NSNumber = 0
        var heliceturm: NSNumber = 0
        let helicett: NSNumber = 0
        
        var fflow_in : NSNumber = 0
        var fflow_in_motor2 : NSNumber = 0
        var fflow_out : NSNumber = 0
        var fflow_out_motor2 : NSNumber = 0
        
        if(!txtfflow_in.text!.isEmpty){
            txtfflow_in.text = txtfflow_in.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtfflow_in.text! as String) {
                fflow_in = cc
                Formatear(textField: txtfflow_in)
            }else{
                txtfflow_in.text = ""
                txtfflow_in.becomeFirstResponder()
            }
        }
        
        if(!txtfflow_in_motor2.text!.isEmpty){
            txtfflow_in_motor2.text = txtfflow_in_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtfflow_in_motor2.text! as String) {
                fflow_in_motor2 = cc
                Formatear(textField: txtfflow_in_motor2)
            }else{
                txtfflow_in_motor2.text = ""
                txtfflow_in_motor2.becomeFirstResponder()
            }
        }
        
        if(!txtfflow_out.text!.isEmpty){
            txtfflow_out.text = txtfflow_out.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtfflow_out.text! as String) {
                fflow_out = cc
                Formatear(textField: txtfflow_out)
            }else{
                txtfflow_out.text = ""
                txtfflow_out.becomeFirstResponder()
            }
        }
        
        if(!txtfflow_out_motor2.text!.isEmpty){
            txtfflow_out_motor2.text = txtfflow_out_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtfflow_out_motor2.text! as String) {
                fflow_out_motor2 = cc
                Formatear(textField: txtfflow_out_motor2)
            }else{
                txtfflow_out_motor2.text = ""
                txtfflow_out_motor2.becomeFirstResponder()
            }
        }
        
        
        if(!txttorque_motor1.text!.isEmpty){
            txttorque_motor1.text = txttorque_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txttorque_motor1.text! as String) {
                torque_motor1 = cc
                Formatear(textField: txttorque_motor1)
            }else{
                txttorque_motor1.text = ""
                txttorque_motor1.becomeFirstResponder()
            }
        }
        if(!txttorque_motor2.text!.isEmpty){
            txttorque_motor2.text = txttorque_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txttorque_motor2.text! as String) {
                torque_motor2 = cc
                Formatear(textField: txttorque_motor2)
            }else{
                txttorque_motor2.text = ""
                txttorque_motor2.becomeFirstResponder()
            }
        }
        if(!txtrpm_motor1.text!.isEmpty){
            txtrpm_motor1.text = txtrpm_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtrpm_motor1.text! as String) {
                rpm_motor1 = cc
                Formatear(textField: txtrpm_motor1)
            }else{
                txtrpm_motor1.text = ""
                txtrpm_motor1.becomeFirstResponder()
            }
        }
        if(!txtrpm_motor2.text!.isEmpty){
            txtrpm_motor2.text = txtrpm_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtrpm_motor2.text! as String) {
                rpm_motor2 = cc
                Formatear(textField: txtrpm_motor2)
            }else{
                txtrpm_motor2.text = ""
                txtrpm_motor2.becomeFirstResponder()
            }
        }
        if(!txtitt_motor1.text!.isEmpty){
            txtitt_motor1.text = txtitt_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtitt_motor1.text! as String) {
                itt_motor1 = cc
                Formatear(textField: txtitt_motor1)
            }else{
                txtitt_motor1.text = ""
                txtitt_motor1.becomeFirstResponder()
            }
        }
        if(!txtitt_motor2.text!.isEmpty){
            txtitt_motor2.text = txtitt_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtitt_motor2.text! as String) {
                itt_motor2 = cc
                Formatear(textField: txtitt_motor2)
            }else{
                txtitt_motor2.text = ""
                txtitt_motor2.becomeFirstResponder()
            }
        }
        if(!txtrpmhelice_motor1.text!.isEmpty){
            txtrpmhelice_motor1.text = txtrpmhelice_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtrpmhelice_motor1.text! as String) {
                rpmhelice_motor1 = cc
                Formatear(textField: txtrpmhelice_motor1)
            }else{
                txtrpmhelice_motor1.text = ""
                txtrpmhelice_motor1.becomeFirstResponder()
            }
        }
        if(!txtrpmhelice_motor2.text!.isEmpty){
            txtrpmhelice_motor2.text = txtrpmhelice_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtrpmhelice_motor2.text! as String) {
                rpmhelice_motor2 = cc
                Formatear(textField: txtrpmhelice_motor2)
            }else{
                txtrpmhelice_motor2.text = ""
                txtrpmhelice_motor2.becomeFirstResponder()
            }
        }
        
        if(!txtop_motor1.text!.isEmpty){
            txtop_motor1.text = txtop_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtop_motor1.text! as String) {
                op_motor1 = cc
                Formatear(textField: txtop_motor1)
            }else{
                txtop_motor1.text = ""
                txtop_motor1.becomeFirstResponder()
            }
        }
        if(!txtop_motor2.text!.isEmpty){
            txtop_motor2.text = txtop_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtop_motor2.text! as String) {
                op_motor2 = cc
                Formatear(textField: txtop_motor2)
            }else{
                txtop_motor1.text = ""
                txtop_motor1.becomeFirstResponder()
            }
        }
        if(!txtot_motor1.text!.isEmpty){
            txtot_motor1.text = txtot_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtot_motor1.text! as String) {
                ot_motor1 = cc
                Formatear(textField: txtot_motor1)
            }else{
                txtot_motor1.text = ""
                txtot_motor1.becomeFirstResponder()
            }
        }
        if(!txtot_motor2.text!.isEmpty){
            txtot_motor2.text = txtot_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtot_motor2.text! as String) {
                ot_motor2 = cc
                Formatear(textField: txtot_motor2)
            }else{
                txtot_motor2.text = ""
                txtot_motor2.becomeFirstResponder()
            }
        }
        if(!txtff_motor1.text!.isEmpty){
            txtff_motor1.text = txtff_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtff_motor1.text! as String) {
                ff_motor1 = cc
                Formatear(textField: txtff_motor1)
            }else{
                txtff_motor1.text = ""
                txtff_motor1.becomeFirstResponder()
            }
        }
        if(!txtff_motor2.text!.isEmpty){
            txtff_motor2.text = txtff_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtff_motor2.text! as String) {
                ff_motor2 = cc
                Formatear(textField: txtff_motor2)
            }else{
                txtff_motor2.text = ""
                txtff_motor2.becomeFirstResponder()
            }
        }
        if(!txtvolts_motor1.text!.isEmpty){
            txtvolts_motor1.text = txtvolts_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvolts_motor1.text! as String) {
                volts_motor1 = cc
                Formatear(textField: txtvolts_motor1)
            }else{
                txtvolts_motor1.text = ""
                txtvolts_motor1.becomeFirstResponder()
            }
        }
        if(!txtvolts_motor2.text!.isEmpty){
            txtvolts_motor2.text = txtvolts_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvolts_motor2.text! as String) {
                volts_motor2 = cc
                Formatear(textField: txtvolts_motor2)
            }else{
                txtvolts_motor2.text = ""
                txtvolts_motor2.becomeFirstResponder()
            }
        }
        if(!txtamps_motor1.text!.isEmpty){
            txtamps_motor1.text = txtamps_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtamps_motor1.text! as String) {
                amps_motor1 = cc
                Formatear(textField: txtamps_motor1)
            }else{
                txtamps_motor1.text = ""
                txtamps_motor1.becomeFirstResponder()
            }
        }
        if(!txtamps_motor2.text!.isEmpty){
            txtamps_motor2.text = txtamps_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtamps_motor2.text! as String) {
                amps_motor2 = cc
                Formatear(textField: txtamps_motor2)
            }else{
                txtamps_motor2.text = ""
                txtamps_motor2.becomeFirstResponder()
            }
        }
        
        /*
        if(!txtavionserie.text!.isEmpty){
            avionserie  = txtavionserie.text! as String
        }
        
        if(!txtavionciclos.text!.isEmpty){
            txtavionciclos.text = txtavionciclos.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtavionciclos.text! as String) {
                avionciclos = cc
                Formatear(textField: txtavionciclos)
            }else{
                txtavionciclos.text = ""
                txtavionciclos.becomeFirstResponder()
            }
        }
        if(!txtavionturm.text!.isEmpty){
            txtavionturm.text = txtavionturm.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtavionturm.text! as String) {
                avionturm = cc
                Formatear(textField: txtavionturm)
            }else{
                txtavionturm.text = ""
                txtavionturm.becomeFirstResponder()
            }
        }
        if(!txtaviontt.text!.isEmpty){
            txtaviontt.text = txtaviontt.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtaviontt.text! as String) {
                aviontt = cc
                Formatear(textField: txtaviontt)
            }else{
                txtaviontt.text = ""
                txtaviontt.becomeFirstResponder()
            }
        }
        
        if(!txtmotorserie.text!.isEmpty){
            motorserie = txtheliceserie.text! as String
        }
        
        if(!txtmotorciclos.text!.isEmpty){
            txtmotorciclos.text = txtmotorciclos.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtmotorciclos.text! as String) {
                motorciclos = cc
                Formatear(textField: txtmotorciclos)
            }else{
                txtmotorciclos.text = ""
                txtmotorciclos.becomeFirstResponder()
            }
        }
        if(!txtmotorturm.text!.isEmpty){
            txtmotorturm.text = txtmotorturm.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtmotorturm.text! as String) {
                motorturm = cc
                Formatear(textField: txtmotorturm)
            }else{
                txtmotorturm.text = ""
                txtmotorturm.becomeFirstResponder()
            }
        }
        if(!txtmotortt.text!.isEmpty){
            txtmotortt.text = txtmotortt.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtmotortt.text! as String) {
                motortt = cc
                Formatear(textField: txtmotortt)
            }else{
                txtmotortt.text = ""
                txtmotortt.becomeFirstResponder()
            }
        }
        if(!txtheliceserie.text!.isEmpty){
            heliceserie = txtheliceserie.text! as String
        }
        if(!txtheliceciclos.text!.isEmpty){
            txtheliceciclos.text = txtheliceciclos.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtheliceciclos.text! as String) {
                heliceciclos = cc
                Formatear(textField: txtheliceciclos)
            }else{
                txtheliceciclos.text = ""
                txtheliceciclos.becomeFirstResponder()
            }
        }
        if(!txtheliceturm.text!.isEmpty){
            txtheliceturm.text = txtheliceturm.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtheliceturm.text! as String) {
                heliceturm = cc
                Formatear(textField: txtheliceturm)
            }else{
                txtheliceturm.text = ""
                txtheliceturm.becomeFirstResponder()
            }
        }
        if(!txthelicett.text!.isEmpty){
            txthelicett.text = txthelicett.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txthelicett.text! as String) {
                helicett = cc
                Formatear(textField: txthelicett)
            }else{
                txthelicett.text = ""
                txthelicett.becomeFirstResponder()
            }
        }*/
        if(!txtvv_motor1.text!.isEmpty){
            txtvv_motor1.text = txtvv_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvv_motor1.text! as String) {
                vv_motor1 = cc
                Formatear(textField: txtvv_motor1)
            }else{
                txtvv_motor1.text = ""
                txtvv_motor1.becomeFirstResponder()
            }
        }
        if(!txtvv_motor2.text!.isEmpty){
            txtvv_motor2.text = txtvv_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvv_motor2.text! as String) {
                vv_motor2 = cc
                Formatear(textField: txtvv_motor1)
            }else{
                txtvv_motor2.text = ""
                txtvv_motor2.becomeFirstResponder()
            }
        }
        if(!txtvi_motor1.text!.isEmpty){
            txtvi_motor1.text = txtvi_motor1.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvi_motor1.text! as String) {
                vi_motor1 = cc
                Formatear(textField: txtvi_motor1)
            }else{
                txtvi_motor1.text = ""
                txtvi_motor1.becomeFirstResponder()
            }
        }
        if(!txtvi_motor2.text!.isEmpty){
            txtvi_motor2.text = txtvi_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvi_motor2.text! as String) {
                vi_motor2 = cc
                Formatear(textField: txtvi_motor2)
            }else{
                txtvi_motor2.text = ""
                txtvi_motor2.becomeFirstResponder()
            }
        }
        
        if(!txtoat.text!.isEmpty){
            txtoat.text = txtoat.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtoat.text! as String) {
                oat = cc
                Formatear(textField: txtoat)
            }else{
                txtoat.text = ""
                txtoat.becomeFirstResponder()
            }
        }
        
        if( global_var.j_tramos_Id !=  0){
            
            if (global_var.j_instrumentos_Id == 0) {
                
                global_var.j_instrumentos_Id = coreDataStack.obtenerIdInstrumento()
                
                coreDataStack.agregarInstrumentos_Turbo(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_instrumentos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, turbo_flow: ff_motor1, turbo_flow_motor2: ff_motor2, turbo_helicerpm: rpmhelice_motor1, turbo_helicerpm_motor2: rpmhelice_motor2, turbo_ias: vi_motor1, turbo_ias_motor2: vi_motor2, turbo_itt: itt_motor1, turbo_itt_motor2: itt_motor2, turbo_ng: rpm_motor1, turbo_ng_motor2: rpm_motor2, turbo_nivelvuelo: 0, turbo_oat: oat, turbo_oilpress: op_motor1, turbo_oilpress_motor2: op_motor2, turbo_oiltemp: ot_motor1, turbo_oiltemp_motor2: ot_motor2, turbo_torque: torque_motor1, turbo_torque_motor2: torque_motor2, turbo_vi: vi_motor1, turbo_vi_motor2: vi_motor2, turbo_vv: vv_motor1, turbo_vv_motor2: vv_motor2, turbo_dcac: volts_motor1, turbo_dcac_motor2: volts_motor2, turbo_amp: amps_motor1, turbo_amp_motor2: amps_motor2, turbo_avion_serie: avionserie, turbo_avion_ciclos: avionciclos, turbo_avion_turm: avionturm, turbo_avion_tt: aviontt, turbo_motor_serie: motorserie, turbo_motor_ciclos: motorciclos, turbo_motor_turm: motorturm, turbo_motor_tt: motortt, turbo_helice_serie: heliceserie, turbo_helice_ciclos: heliceciclos, turbo_helice_turm: heliceturm, turbo_helice_tt: helicett, turbo_fflow_in: fflow_in, turbo_fflow_in_motor2:  fflow_in_motor2, turbo_fflow_out: fflow_out, turbo_fflow_out_motor2: fflow_out_motor2)
                
            }else {
                //Actualizacion
                
                coreDataStack.actualizarInstrumentos_Turbo(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_instrumentos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, turbo_flow: ff_motor1, turbo_flow_motor2: ff_motor2, turbo_helicerpm: rpmhelice_motor1, turbo_helicerpm_motor2: rpmhelice_motor2, turbo_ias: vi_motor1, turbo_ias_motor2: vi_motor2, turbo_itt: itt_motor1, turbo_itt_motor2: itt_motor2, turbo_ng: rpm_motor1, turbo_ng_motor2: rpm_motor2, turbo_nivelvuelo: 0, turbo_oat: oat, turbo_oilpress: op_motor1, turbo_oilpress_motor2: op_motor2, turbo_oiltemp: ot_motor1, turbo_oiltemp_motor2: ot_motor2, turbo_torque: torque_motor1, turbo_torque_motor2: torque_motor2, turbo_vi: vi_motor1, turbo_vi_motor2: vi_motor2, turbo_vv: vv_motor1, turbo_vv_motor2: vv_motor2, turbo_dcac: volts_motor1, turbo_dcac_motor2: volts_motor2, turbo_amp: amps_motor1, turbo_amp_motor2: amps_motor2, turbo_avion_serie: avionserie, turbo_avion_ciclos: avionciclos, turbo_avion_turm: avionturm, turbo_avion_tt: aviontt, turbo_motor_serie: motorserie, turbo_motor_ciclos: motorciclos, turbo_motor_turm: motorturm, turbo_motor_tt: motortt, turbo_helice_serie: heliceserie, turbo_helice_ciclos: heliceciclos, turbo_helice_turm: heliceturm, turbo_helice_tt: helicett, turbo_fflow_in: fflow_in, turbo_fflow_in_motor2:  fflow_in_motor2, turbo_fflow_out: fflow_out, turbo_fflow_out_motor2: fflow_out_motor2)
                
            }
            
        }
        else{
            
            Util.invokeAlertMethod(strTitle: "", strBody: "Es necesario registrar un tramo para continuar con los instrumentos ", delegate: self)
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
                
            }
        }
    }
    
    @IBAction func btnCancela(sender: AnyObject) {
        regresarABitacoras()
    }
       
    func regresarABitacoras(){
        
        
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.present(destviewcontroller, animated: true, completion: nil)
    }

    @IBAction func btnGuarda(sender: UIButton) {
        GuardarInformacion()
        if let tabbar = self.tabBarController {
            tabbar.selectedIndex = 2
        }
    }
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var number = 0
        
        print(section.description)
        if global_var.j_avion_matricula == "XAVFR" {
            if section == 6 {
                number = 0
            }
            else if section == 7 {
                number = 2
            }else {
                number = 1
            }
        }else{
            if section == 7 {
                number = 0
            }else{
            number = 1
            }
        }
        
        
        return number
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
    
        var altura : CGFloat = 0
        if (indexPath as NSIndexPath).row == 6 && global_var.j_avion_matricula == "XAVFR" {
            altura = 0
        }else{
            if DeviceType.IS_IPAD{
                altura = 90
            }else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_5 {
                altura = 60
            }else{
                altura = 90
            }
        }
        
        
        return altura
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
   
        
        var altura : CGFloat = 0
        
        if global_var.j_avion_matricula == "XAVFR" {
            if section == 6 {
                altura = 0.0
            }
            else {
                altura = tableView.sectionHeaderHeight
            }
        }else{
           altura = tableView.sectionHeaderHeight
        }
        
        return altura
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        
        switch section {
            
        case  0 :
                return "VELOCIDAD VERDADERA (V.V)"
            
        case 1 :
                return "VELOCIDAD INDICADA (V.I)"
        case 2 :
            return "TORQUE (TQ)"
        case 3 :
            return "TEMPERATURA MOTOR (I.T.T)"
        case 4 :
            return "RPM MOTOR (NG)"
        case 5 :
            return "RPM HELICE (NP)"
        case 6 :
                 if global_var.j_avion_matricula == "XAVFR" {
                    return ""
                 }else{
                    return "FLUJO DE CUMBUSTIBLE (F.F.)"
            
            }
        case 7 :
            return "FLUJO DE COMBUSTIBLE (F.F.)"
        case 8 :
            return "TEMPERATURA ACEITE (OT)"
        case 9 :
            return "PRESIÓN ACEITE (OP)"
        case 10:
            return "TEMPERATURA EXTERIOR (OAT)"
        case 11:
            return "VOLTS (DC)"
        case 12:
            return "AMPS"
            
            
        default:
            return ""
            
        }
    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Text Field Delegate
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Ocultar Teclado")
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        GuardarInformacion()
        let nextTag = nextField[textField.tag]
        self.view.viewWithTag(nextTag!)?.becomeFirstResponder()
        
        if nextTag == 0 {
            btnGuardar.sendActions(for: .touchUpInside)
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
            let cs : CharacterSet = CharacterSet.init(charactersIn: "1234567890.-").inverted
            
            let components = string.components(separatedBy: cs) // componentsSeparatedByCharactersInSet(cs)
            
            let filtered = components.joined(separator: "")
            
            if filtered != "." {
               
                let oldText: NSString = textField.text! as NSString
                var newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
                //replacingCharacters(in: range, with: string) as NSString
                
                newText = newText.replacingOccurrences(of: ",", with: "") as NSString
                
                print(newText)
                print(oldText)
                
                return true
              
            }else{
                return true
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
}
