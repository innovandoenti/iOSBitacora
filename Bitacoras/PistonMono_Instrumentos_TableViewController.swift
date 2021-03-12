//
//  PistonMono_Instrumentos_TableViewController.swift


import UIKit
import CoreData

class PistonMono_Instrumentos_TableViewController: UITableViewController, UITextFieldDelegate {

    var totalArray : NSMutableArray = NSMutableArray()
    var logica = Util()
    var coreDataStack = CoreDataStack()
    
    @IBOutlet weak var txtOAT: UITextField!
    @IBOutlet weak var txtAceite: UITextField!
    @IBOutlet weak var txtCrucero: UITextField!
    @IBOutlet weak var txtManPress: UITextField!
    @IBOutlet weak var txtFuelPress: UITextField!
    @IBOutlet weak var txtOilPress: UITextField!
    @IBOutlet weak var txtRPM: UITextField!
    @IBOutlet weak var txtFlow: UITextField!
    @IBOutlet weak var txtTemp: UITextField!
    @IBOutlet weak var txtVolts: UITextField!
    @IBOutlet weak var txtAmpers: UITextField!
    @IBOutlet weak var txtEGT: UITextField!
    @IBOutlet weak var txtCHT: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    
    
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:0]
    let formatter : NumberFormatter = NumberFormatter()
    let effect = UIBlurEffect(style: .dark)
    let resizingMask: UIView.AutoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtOAT.delegate = self
        txtAceite.delegate = self
        txtCrucero.delegate = self
        txtManPress.delegate = self
        txtFuelPress.delegate = self
        txtOilPress.delegate = self
        txtRPM.delegate = self
        txtFlow.delegate = self
        txtTemp.delegate = self
        txtVolts.delegate = self
        txtAmpers.delegate = self
        txtEGT.delegate = self
        txtCHT.delegate = self
        
        
        txtOAT.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtAceite.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtCrucero.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtManPress.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtFuelPress.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtOilPress.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtRPM.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtFlow.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtTemp.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtVolts.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtAmpers.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtEGT.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtCHT.addTarget(self, action: #selector(PistonMono_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        
        configuraView()
        
    }
    
    
    func buildImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "Default@2x.png"))
        imageView.frame = view.bounds
        imageView.autoresizingMask = resizingMask
        return imageView
    }
    
    func buildBlurView() -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = resizingMask
        return blurView
    }
    
    
    func configuraView(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PistonMono_Instrumentos_TableViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
    
    
    func cargarInstrumentos(){
        
        print("IdBitacora: \(global_var.j_bitacoras_Id)")
        let formato : NumberFormatter = NumberFormatter()
        formato.numberStyle = .decimal
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
        let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id,global_var.j_avion_matricula])
        fetchRequest.predicate = predicate
        
        do{
        let fetchResults = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [BitacorasInstrumentos]
        
        if let aviones = fetchResults{
            
            for row in aviones{
                
                let _oat = row.piston_oat
                let _aceite = row.piston_aceite_mas
                let _crucero = row.piston_crucero
                let _manpress = row.piston_manpress
                let _fuelpress = row.piston_fuelpress
                let _oilpress = row.piston_oilpress
                let _rpm =  row.piston_rpm
                let _flow = row.piston_flow
                let _temp = row.piston_temp
                let _volts = row.piston_volts
                let _ampers = row.piston_ampers
                let _egt = row.piston_egt
                let _cht = row.piston_cht
                
                global_var.j_instrumentos_Id = row.idlectura!
                
                txtOAT.text = formato.string(from: _oat!)
                txtAceite.text =  formato.string(from: _aceite!)
                txtCrucero.text = formato.string(from: _crucero!)
                txtManPress.text = formato.string(from: _manpress!)
                txtFuelPress.text = formato.string(from: _fuelpress!)
                txtOilPress.text = formato.string(from: _oilpress!)
                txtRPM.text = formato.string(from: _rpm!)
                txtFlow.text = formato.string(from: _flow!)
                txtTemp.text = formato.string(from: _temp!)
                txtVolts.text = formato.string(from: _volts!)
                txtAmpers.text = formato.string(from: _ampers!)
                txtEGT.text = formato.string(from: _egt!)
                txtCHT.text = formato.string(from: _cht!)
                
            }
            
        }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        GuardarInformacion()
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
        
        
    }
    
    func GuardarInformacion(){
        
        if global_var.j_bitacora_abierta == 1 {
            self.GuardarInstrumentos()
        }else{
            
            Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
        }
    }
    
    func GuardarInstrumentos(){
        
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        
        var _oat : NSNumber = 0
        var _aceite : NSNumber = 0
        var _crucero : NSNumber = 0
        var _manpress : NSNumber = 0
        var _fuelpress : NSNumber = 0
        var _oilpress : NSNumber = 0
        var _rpm : NSNumber =  0
        var _flow : NSNumber = 0
        var _temp : NSNumber = 0
        var _volts : NSNumber = 0
        var _ampers : NSNumber = 0
        var _egt : NSNumber = 0
        var _cht : NSNumber = 0
        
        
        if(!txtOAT.text!.isEmpty){
            txtOAT.text = txtOAT.text!.replacingOccurrences(of: ",", with: "")
            if let oat = formatter.number(from: txtOAT.text! as String) {
                _oat = oat
                Formatear(textField: txtOAT)
            }else{
                txtOAT.text = ""
                txtOAT.becomeFirstResponder()
            }
        }
        if(!txtAceite.text!.isEmpty){
            txtAceite.text = txtAceite.text!.replacingOccurrences(of: ",", with: "")
            if let aceite = formatter.number(from: txtAceite.text! as String) {
                _aceite = aceite
                Formatear(textField:txtAceite)
            }else{
                txtAceite.text = ""
                txtAceite.becomeFirstResponder()
            }
        }
        if(!txtCrucero.text!.isEmpty){
            txtCrucero.text = txtCrucero.text!.replacingOccurrences(of: ",", with: "")
            if let crucero = formatter.number(from: txtCrucero.text! as String) {
                _crucero = crucero
                Formatear(textField: txtCrucero)
            }else{
                txtCrucero.text = ""
                txtCrucero.becomeFirstResponder()
            }
        }
        if(!txtManPress.text!.isEmpty){
            txtManPress.text = txtManPress.text!.replacingOccurrences(of: ",", with: "")
            if let manpress = formatter.number(from: txtManPress.text! as String){
                _manpress = manpress
                Formatear(textField: txtManPress)
            }else{
                txtManPress.text = ""
                txtManPress.becomeFirstResponder()
            }
        }
        if(!txtFuelPress.text!.isEmpty){
            txtFuelPress.text = txtFuelPress.text!.replacingOccurrences(of: ",", with: "")
            if let fuelpress = formatter.number(from: txtFuelPress.text! as String) {
                _fuelpress = fuelpress
                Formatear(textField: txtFuelPress)
            }else{
                txtFuelPress.text = ""
                txtFuelPress.becomeFirstResponder()
            }
        }
        if(!txtOilPress.text!.isEmpty){
            txtOilPress.text = txtOilPress.text!.replacingOccurrences(of: ",", with: "")
            if let oilpress = formatter.number(from: txtOilPress.text! as String) {
                _oilpress = oilpress
                Formatear(textField: txtOilPress)
            }else{
                txtOilPress.text = ""
                txtOilPress.becomeFirstResponder()
            }
        }
        if(!txtRPM.text!.isEmpty){
            txtRPM.text = txtRPM.text!.replacingOccurrences(of: ",", with: "")
            if let rpm = formatter.number(from: txtRPM.text! as String) {
                _rpm = rpm
                Formatear(textField: txtRPM)
            }else{
                txtRPM.text = ""
                txtRPM.becomeFirstResponder()
            }
            
        }
        if(!txtFlow.text!.isEmpty){
            txtFlow.text = txtFlow.text!.replacingOccurrences(of: ",", with: "")
            if let flow = formatter.number(from: txtFlow.text! as String) {
                _flow = flow
                Formatear(textField: txtFlow)
            }else{
                txtFlow.text = ""
                txtFlow.becomeFirstResponder()
            }
        }
        if(!txtTemp.text!.isEmpty){
            txtTemp.text = txtTemp.text!.replacingOccurrences(of: ",", with: "")
            if let temp = formatter.number(from: txtTemp.text! as String) {
                _temp = temp
                Formatear(textField: txtTemp)
            }else{
                txtTemp.text = ""
                txtTemp.becomeFirstResponder()
            }
        }
        if(!txtVolts.text!.isEmpty){
            txtVolts.text = txtVolts.text!.replacingOccurrences(of: ",", with: "")
            if let volts = formatter.number(from: txtVolts.text! as String) {
                _volts = volts
                Formatear(textField: txtVolts)
            }else{
                txtVolts.text = ""
                txtVolts.becomeFirstResponder()
            }
        }
        if(!txtAmpers.text!.isEmpty){
            txtAmpers.text = txtAmpers.text!.replacingOccurrences(of: ",", with: "")
            if let amprs = formatter.number(from: txtAmpers.text! as String) {
                _ampers = amprs
                Formatear(textField: txtAmpers)
            }else{
                txtAmpers.text = ""
                txtAmpers.becomeFirstResponder()
            }
        }
        if(!txtEGT.text!.isEmpty){
            txtEGT.text = txtEGT.text!.replacingOccurrences(of: ",", with: "")
            if let EGT = formatter.number(from: txtEGT.text! as String) {
                _egt = EGT
                Formatear(textField: txtEGT)
            }else{
                txtEGT.text = ""
                txtEGT.becomeFirstResponder()
            }
            
        }
        if(!txtCHT.text!.isEmpty){
            txtCHT.text = txtCHT.text!.replacingOccurrences(of: ",", with: "")
            if let CHT = formatter.number(from: txtCHT.text! as String) {
                _cht = CHT
                Formatear(textField: txtCHT)
            }else{
                txtEGT.text = ""
                txtEGT.becomeFirstResponder()
            }
        }
        
        
        if( global_var.j_bitacoras_Id !=  0){
            
            if (global_var.j_instrumentos_Id == 0) {
                
                global_var.j_instrumentos_Id = coreDataStack.obtenerIdInstrumento()
                
                coreDataStack.agregarInstrumentos_Piston_MonoMotor(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_tramos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, piston_aceite_mas: _aceite, piston_ampers: _ampers, piston_cht: _cht, piston_crucero: _crucero, piston_egt: _egt, piston_flow: _flow, piston_fuelpress: _fuelpress, piston_manpress: _manpress, piston_oat: _oat, piston_oilpress: _oilpress, piston_rpm: _rpm, piston_temp: _temp, piston_volts: _volts)
                
            }else {
                //Actualizacion
                
                coreDataStack.actualizarInstrumentos_Piston_MonoMotor(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_tramos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, piston_aceite_mas: _aceite, piston_ampers: _ampers, piston_cht: _cht, piston_crucero: _crucero, piston_egt: _egt, piston_flow: _flow, piston_fuelpress: _fuelpress, piston_manpress: _manpress, piston_oat: _oat, piston_oilpress: _oilpress, piston_rpm: _rpm, piston_temp: _temp, piston_volts: _volts)
            }
            
        }
        else{
            Util.invokeAlertMethod(strTitle: "", strBody: "Es necesario registrar un tramo para continuar con los instrumentos ", delegate: self)
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
                
            }
        }
        
    }


    // MARK: - Table view data source

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 14
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
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.GuardarInformacion()
        let nextTag = nextField[textField.tag]
        self.view.viewWithTag(nextTag!)?.becomeFirstResponder()
        
        if nextTag == 13 {
            btnGuardar.sendActions(for: .touchUpInside)
        }
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        
        let f : NumberFormatter = NumberFormatter();
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        
        
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
                
                return  true
                
            }else{
                return   true
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
    }
    
    
    
    @IBAction func btnCancelar(_ sender: Any) {

        regresarABitacoras()
        
    }
    
    func regresarABitacoras(){
        
        
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.present(destviewcontroller, animated: true, completion: nil)
    }
    
   
    @IBAction func muestraMenu(_ sender: Any) {
        
        let mensaje = "Se cerrará la bitácora con el folio: ** \(global_var.j_bitacora_num) ** "
        
        let alertController = UIAlertController(title: "", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .default){ action -> Void in
            
            if global_var.j_bitacora_abierta == 1 {
                
                self.GuardarInformacion()
                
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
                
            }else{
                
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
        
        //alertController.addAction(saveAction)
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

