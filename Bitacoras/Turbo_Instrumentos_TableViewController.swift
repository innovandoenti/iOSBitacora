//
//  Turbo_Instrumentos_TableViewController.swift


import UIKit
import CoreData


class Turbo_Instrumentos_TableViewController: UITableViewController, UITextFieldDelegate {
    
    var totalArray : NSMutableArray = NSMutableArray()
    var logica = Util()
    var coreDataStack = CoreDataStack()
    let formatter : NumberFormatter = NumberFormatter()
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:16, 16:17, 17:18, 18:19, 19:20, 20:21, 21:22,22:23,23:24,24:0]
    
    
    
    @IBOutlet weak var txttorque: UITextField!
    @IBOutlet weak var txtrpm: UITextField!
    @IBOutlet weak var txtitt: UITextField!
    @IBOutlet weak var txtng: UITextField!
    @IBOutlet weak var txtpressaceite: UITextField!
    @IBOutlet weak var txttempaceite: UITextField!
    @IBOutlet weak var txtflujocomb: UITextField!
    @IBOutlet weak var txtdcac: UITextField!
    @IBOutlet weak var txtamps: UITextField!
    @IBOutlet weak var txtavionserie: UITextField!
    @IBOutlet weak var txtavionciclos: UITextField!
    @IBOutlet weak var txtavionturm: UITextField!
    @IBOutlet weak var txtaviontt: UITextField!
    @IBOutlet weak var txtmotorserie: UITextField!
    @IBOutlet weak var txtmotorciclos: UITextField!
    @IBOutlet weak var txtmotorturm: UITextField!
    @IBOutlet weak var txtmotortt: UITextField!
    @IBOutlet weak var txtheliceserie: UITextField!
    @IBOutlet weak var txtheliceciclos: UITextField!
    @IBOutlet weak var txtheliceturm: UITextField!
    @IBOutlet weak var txthelicett: UITextField!
    @IBOutlet weak var txtvv: UITextField!
    @IBOutlet weak var txtvi: UITextField!
    @IBOutlet weak var txtoat: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuraView()
        
    }
    
    func configuraView(){
        
        txttorque.delegate = self
        txtrpm.delegate = self
        txtitt.delegate = self
        txtng.delegate = self
        txtpressaceite.delegate = self
        txttempaceite.delegate = self
        txtflujocomb.delegate = self
        txtdcac.delegate = self
        txtamps.delegate = self
        txtavionserie.delegate = self
        txtavionciclos.delegate = self
        txtavionturm.delegate = self
        txtaviontt.delegate = self
        txtmotorserie.delegate = self
        txtmotorciclos.delegate = self
        txtmotorturm.delegate = self
        txtmotortt.delegate = self
        txtheliceserie.delegate = self
        txtheliceciclos.delegate = self
        txtheliceturm.delegate = self
        txthelicett.delegate = self
        txtoat.delegate = self
        txtvv.delegate = self
        txtvi.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Turbo_Instrumentos_TableViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        txttorque.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtrpm.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtitt.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtng.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtpressaceite.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txttempaceite.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtflujocomb.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtdcac.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtamps.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        txtavionciclos.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtavionturm.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtaviontt.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        txtmotorciclos.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotorturm.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotortt.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        txtheliceciclos.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtheliceturm.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txthelicett.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtoat.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtvv.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtvi.addTarget(self, action: #selector(Turbo_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        
        if(global_var.j_tramos_Id != 0){
            //Viene de consultar una bitacora y quiere modificar en caso de estar abierta
            cargarInstrumentos()
        }
        
        if(global_var.j_bitacoras_Id != 0){
            //Quiere decir que ya se capturo la bitacora y ya no puede cancelar
            btnCancelar.title = "Cancelar"
        }
        
    }
    
    @objc func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func cargarInstrumentos(){
        
        
        let _: NSError?
        let formato : NumberFormatter = NumberFormatter()
        formato.numberStyle = .decimal
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
        let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id, global_var.j_avion_matricula])
        fetchRequest.predicate = predicate
        
        let fetchResults = try! coreDataStack.managedObjectContext.fetch(fetchRequest) as? [BitacorasInstrumentos]
       
        if let aviones = fetchResults{
            
            for row in aviones{
                
                global_var.j_instrumentos_Id = row.idlectura!
                
                
                let torque = row.turbo_torque!
                let rpm = row.turbo_helicerpm!
                let itt = row.turbo_itt!
                let ng = row.turbo_ng!
                let pressaceite = row.turbo_oilpress!
                let tempaceite = row.turbo_oiltemp!
                let flujocomb = row.turbo_fflow!
                let dcac = row.turbo_dcac!
                let amps = row.turbo_amp!
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
                let vi = row.turbo_vi!
                let oat = row.turbo_oat!

                
                txttorque.text = formato.string(from: torque)
                txtrpm.text = formato.string(from: rpm)
                txtitt.text = formato.string(from:  itt)
                txtng.text = formato.string(from:  ng)
                txtpressaceite.text = formato.string(from:  pressaceite)
                txttempaceite.text = formato.string(from:  tempaceite)
                txtflujocomb.text = formato.string(from:  flujocomb)
                txtdcac.text = formato.string(from:  dcac)
                txtamps.text = formato.string(from:  amps)
                txtavionserie.text = avionserie
                txtavionciclos.text = formato.string(from:  avionciclos)
                txtavionturm.text = formato.string(from:  avionturm)
                txtaviontt.text = formato.string(from:  aviontt)
                txtmotorserie.text = motorserie
                txtmotorciclos.text = formato.string(from:  motorciclos)
                txtmotorturm.text = formato.string(from:  motorturm)
                txtmotortt.text = formato.string(from:  motortt)
                txtheliceserie.text = heliceserie
                txtheliceciclos.text = formato.string(from:  heliceciclos)
                txtheliceturm.text = formato.string(from: heliceturm)
                txthelicett.text = formato.string(from:  helicett)
                txtvv.text = formato.string(from:  vv)
                txtvi.text = formato.string(from:  vi)
                txtoat.text = formato.string(from:  oat)
                
            }
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var rows = 0
        
        if section == 0 {
            rows =  12
        }else if section == 1 {
            rows =  3
        }else{
            rows = 1
        }
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        var altura : CGFloat = 0
        
        if DeviceType.IS_IPAD{
            altura = 90
        }else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_5 {
            altura = 60
        }else{
            altura = 90
        }
        
        return altura
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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
        
        if(textField.tag != 25 && textField.tag != 29 && textField.tag != 33 && textField.tag != 37 ){
            
            let cs : CharacterSet =  CharacterSet.init(charactersIn: "1234567890.-").inverted //NSCharacterSet.init(charactersIn: "1234567890.-").inverted as NSCharacterSet // (charactersInString: "1234567890.-").invertedSet
            
            let components = string.components(separatedBy: cs) // omponents(separatedBy: cs)  //string.components(separatedBy: cs as NSCharacterSet) // components(separatedBy: cs) // components(separatedBy: cs) // componentsSeparatedByCharactersInSet(cs)
            let filtered = components.joined(separator: "") // joinWithSeparator("")
            
            if filtered != "." {
                
                let oldText: NSString = textField.text! as NSString
                var newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
                
                newText = newText.replacingOccurrences(of: ",", with: "") as NSString
                
                print(newText)
                print(oldText)
                /*if let kk = (f.number(from: newText as String)){
                 textField.text = f.string(from: kk)
                 }*/
                return true
            }else{
                return true
            }
            
            //return string == filtered
            
        }
        
        return true
        

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Ocultar Teclado")
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    
    @IBAction func btnCancelar(sender: AnyObject) {
        
        regresarABitacoras()
        
    }
    
    func regresarABitacoras(){
        
        
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.present(destviewcontroller, animated: true, completion: nil)
    }
    
    @IBAction func mostrarMenu(sender: AnyObject) {
        
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
                    
                    self.coreDataStack.actualizaUltimaInformacion(matricula: global_var.j_avion_matricula, ultimabitacora: global_var.j_avion_ultimabitacora, ultimodestino: global_var.j_avion_ultimodestino, ultimohorometro: global_var.j_avion_ultimohorometro, ultimohorometroapu: global_var.j_avion_ultimohorometroapu, sincronizado: 0, ultimoaterrizaje:  NSNumber(value: global_var.j_avion_ultimoaterrizaje.intValue + 1), ultimociclo: NSNumber(value: global_var.j_avion_ultimociclo.intValue + 1))
                    
                    self.coreDataStack.cerrarBitacora(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                    Util.invokeAlertMethod(strTitle: "Bitácora Cerrada", strBody: "Revisa tu información y sincroniza tu bitácora.", delegate: self)
                    /*
                     Se cambio por petición del Lic. Stein - 26/Mayo/2016 que no se sincronizaran las bitácoras de manera automatica
                     
                     //NSNotificationCenter.defaultCenter().postNotificationName("sincronizarBitacoras", object: nil)
                     //Util.invokeAlertMethod(strTitle: "Bitácora Cerrada", strBody: "Estara en proceso de sincronización.", delegate: self)
                     
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
        
        //alertController.addAction(saveAction)
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func GuardarInstrumentos(){
        
        
         var torque: NSNumber = 0
         var rpm: NSNumber = 0
         var itt: NSNumber = 0
         var ng: NSNumber = 0
         var pressaceite: NSNumber = 0
         var tempaceite: NSNumber = 0
         var flujocomb: NSNumber = 0
         var dcac: NSNumber = 0
         var amps: NSNumber = 0
         var avionserie: String = ""
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
         var helicett: NSNumber = 0
         var vv: NSNumber = 0
         var vi: NSNumber = 0
         var oat: NSNumber = 0
        
        
        let fflow_in : NSNumber = 0
        let fflow_in_motor2 : NSNumber = 0
        let fflow_out : NSNumber = 0
        let fflow_out_motor2 : NSNumber = 0
        
        
        if(!txttorque.text!.isEmpty){
            txttorque.text = txttorque.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txttorque.text! as String) {
                torque = cc
                Formatear(textField: txttorque)
            }else{
                txttorque.text = ""
                txttorque.becomeFirstResponder()
            }
        }
        if(!txtrpm.text!.isEmpty){
            txtrpm.text = txtrpm.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtrpm.text! as String) {
                rpm = cc
                Formatear(textField: txtrpm)
            }else{
                txtrpm.text = ""
                txtrpm.becomeFirstResponder()
            }
        }
        if(!txtitt.text!.isEmpty){
            txtitt.text = txtitt.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtitt.text! as String) {
                itt = cc
                Formatear(textField: txtitt)
            }else{
                txtitt.text = ""
                txtitt.becomeFirstResponder()
            }
        }
        if(!txtng.text!.isEmpty){
            txtng.text = txtng.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtng.text! as String) {
                ng = cc
                Formatear(textField: txtng)
            }else{
                txtng.text = ""
                txtng.becomeFirstResponder()
            }
        }
        
        if(!txtpressaceite.text!.isEmpty){
            txtpressaceite.text = txtpressaceite.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtpressaceite.text! as String) {
                pressaceite = cc
                Formatear(textField: txtpressaceite)
            }else{
                txtpressaceite.text = ""
                txtpressaceite.becomeFirstResponder()
            }
        }
        if(!txttempaceite.text!.isEmpty){
            txttempaceite.text = txttempaceite.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from:  txttempaceite.text! as String) {
                tempaceite = cc
                Formatear(textField: txttempaceite)
            }else{
                txttempaceite.text = ""
                txttempaceite.becomeFirstResponder()
            }
        }
        if(!txtflujocomb.text!.isEmpty){
            txtflujocomb.text = txtflujocomb.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtflujocomb.text! as String) {
                flujocomb = cc
                Formatear(textField: txtflujocomb)
            }else{
                txtflujocomb.text = ""
                txtflujocomb.becomeFirstResponder()
            }
        }
        if(!txtdcac.text!.isEmpty){
            txtdcac.text = txtdcac.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtdcac.text! as String) {
                dcac = cc
                Formatear(textField: txtdcac)
            }else{
                txtdcac.text = ""
                txtdcac.becomeFirstResponder()
            }
        }
        if(!txtamps.text!.isEmpty){
            txtamps.text = txtamps.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtamps.text! as String) {
                amps = cc
                Formatear(textField: txtamps)
            }else{
                txtamps.text = ""
                txtamps.becomeFirstResponder()
            }
        }
        
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
        }
        if(!txtvv.text!.isEmpty){
            txtvv.text = txtvv.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvv.text! as String) {
                vv = cc
                Formatear(textField: txtvv)
            }else{
                txtvv.text = ""
                txtvv.becomeFirstResponder()
            }
        }
        if(!txtvi.text!.isEmpty){
            txtvi.text = txtvi.text!.replacingOccurrences(of: ",", with: "")
            if let cc = formatter.number(from: txtvi.text! as String) {
                vi = cc
                Formatear(textField: txtvi)
            }else{
                txtvi.text = ""
                txtvi.becomeFirstResponder()
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
                
                
                coreDataStack.agregarInstrumentos_Turbo(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_instrumentos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, turbo_flow: flujocomb, turbo_flow_motor2: 0, turbo_helicerpm: rpm, turbo_helicerpm_motor2: 0, turbo_ias: vi, turbo_ias_motor2: 0, turbo_itt: itt, turbo_itt_motor2: 0, turbo_ng: ng, turbo_ng_motor2: 0, turbo_nivelvuelo: 0, turbo_oat: oat, turbo_oilpress: pressaceite, turbo_oilpress_motor2: 0, turbo_oiltemp: tempaceite, turbo_oiltemp_motor2: 0, turbo_torque: torque, turbo_torque_motor2: 0, turbo_vi: vi, turbo_vi_motor2: 0, turbo_vv: vv, turbo_vv_motor2: 0, turbo_dcac: dcac, turbo_dcac_motor2: 0, turbo_amp: amps, turbo_amp_motor2: 0, turbo_avion_serie: avionserie, turbo_avion_ciclos: avionciclos, turbo_avion_turm: avionturm, turbo_avion_tt: aviontt, turbo_motor_serie: motorserie, turbo_motor_ciclos: motorciclos, turbo_motor_turm: motorturm, turbo_motor_tt: motortt, turbo_helice_serie: heliceserie, turbo_helice_ciclos: heliceciclos, turbo_helice_turm: heliceturm, turbo_helice_tt: helicett, turbo_fflow_in: fflow_in, turbo_fflow_in_motor2:  fflow_in_motor2, turbo_fflow_out: fflow_out, turbo_fflow_out_motor2: fflow_out_motor2)
                
            }else {
                //Actualizacion
                
                 coreDataStack.actualizarInstrumentos_Turbo(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_instrumentos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, turbo_flow: flujocomb, turbo_flow_motor2: 0, turbo_helicerpm: rpm, turbo_helicerpm_motor2: 0, turbo_ias: vi, turbo_ias_motor2: 0, turbo_itt: itt, turbo_itt_motor2: 0, turbo_ng: ng, turbo_ng_motor2: 0, turbo_nivelvuelo: 0, turbo_oat: oat, turbo_oilpress: pressaceite, turbo_oilpress_motor2: 0, turbo_oiltemp: tempaceite, turbo_oiltemp_motor2: 0, turbo_torque: torque, turbo_torque_motor2: 0, turbo_vi: vi, turbo_vi_motor2: 0, turbo_vv: vv, turbo_vv_motor2: 0, turbo_dcac: dcac, turbo_dcac_motor2: 0, turbo_amp: amps, turbo_amp_motor2: 0, turbo_avion_serie: avionserie, turbo_avion_ciclos: avionciclos, turbo_avion_turm: avionturm, turbo_avion_tt: aviontt, turbo_motor_serie: motorserie, turbo_motor_ciclos: motorciclos, turbo_motor_turm: motorturm, turbo_motor_tt: motortt, turbo_helice_serie: heliceserie, turbo_helice_ciclos: heliceciclos, turbo_helice_turm: heliceturm, turbo_helice_tt: helicett, turbo_fflow_in: fflow_in, turbo_fflow_in_motor2:  fflow_in_motor2, turbo_fflow_out: fflow_out, turbo_fflow_out_motor2: fflow_out_motor2)
               
            }
            
        }
        else{
            
            Util.invokeAlertMethod(strTitle: "", strBody: "Es necesario registrar un tramo para continuar con los instrumentos ", delegate: self)
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
                
            }
        }
    }
    
    
    @IBAction func btnGuardar(_ sender: UIButton) {
        GuardarInformacion()
        if let tabbar = self.tabBarController {
            tabbar.selectedIndex = 2
        }
    }
    
    
    func GuardarInformacion(){
        if global_var.j_bitacora_abierta == 1 {
            self.GuardarInstrumentos()
            
        }else{
            Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
        }
    }
    
    @objc func Formatear(textField: UITextField){
        
        textField.text = textField.text!.replacingOccurrences(of: ",", with: "")
        let f : NumberFormatter = NumberFormatter();
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        
        let str = textField.text!
        
        if (str != ""){
            let lastChar = str.characters.last!
            if(textField.text!.characters.count < 11){
                if (lastChar != "." && lastChar != "-") {
                    if (textField.text!.range(of: ".0")) != nil { // rangeOfString(".0")) != nil {
                        print(textField.text!)
                        if (lastChar != "0"){
                            if let formateado = f.number(from: textField.text!) {
                                textField.text = f.string(from: formateado)!
                            }
                            else{
                                textField.text = textField.text!.substring(to: textField.text!.endIndex) // substringToIndex(textField.text!.endIndex)
                                //substringToIndex(textField.text!.characters.indexOf(<#T##element: Character##Character#>))  //textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                            }
                        }
                    }else{
                        
                        if let formateado = f.number(from: textField.text!) {
                            textField.text = f.string(from: formateado)!
                        }else{
                            textField.text = textField.text!.substring(to: textField.text!.endIndex) //substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                        }
                        
                    }
                }
            }else{
                textField.text = textField.text!.substring(to: textField.text!.endIndex) // textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                
                if let formateado = f.number(from: textField.text!) {
                    textField.text = f.string(from: formateado)!
                }else{
                    textField.text = textField.text!.substring(to: textField.text!.endIndex)//textField.text!.sub   substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                }
            }
        }
    }
}
