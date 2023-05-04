//
//  Jet_Instrumentos_TableViewController.swift


import UIKit
import CoreData

class Jet_Instrumentos_TableViewController: UITableViewController, UITextFieldDelegate {

    var totalArray : NSMutableArray = NSMutableArray()
    var logica = Util()
    var coreDataStack = CoreDataStack()
    let formatter : NumberFormatter = NumberFormatter()
    
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:16, 16:17, 17:18, 18:19, 19:20, 20:21, 21:22, 22:23, 23:24, 24:25, 25:26, 26:27, 27:28, 28:29, 29:30, 30:31, 31:32, 32:33, 33:34, 34:35, 35:36, 36:37, 37:38, 38:39, 39:40, 40:0]
    
    
   
    @IBOutlet weak var txtn1: UITextField!
    @IBOutlet weak var txtn1_motor2: UITextField!
    @IBOutlet weak var txtn2: UITextField!
    @IBOutlet weak var txtn2_motor2: UITextField!
    @IBOutlet weak var txtitt: UITextField!
    @IBOutlet weak var txtitt_motor2: UITextField!
    @IBOutlet weak var txtfflow: UITextField!
    @IBOutlet weak var txtfflow_motor2: UITextField!
    @IBOutlet weak var txtftemp: UITextField!
    @IBOutlet weak var txtftemp_motor2: UITextField!
    @IBOutlet weak var txtoilpress: UITextField!
    @IBOutlet weak var txtoilpress_motor2: UITextField!
    @IBOutlet weak var txtoiltemp: UITextField!
    @IBOutlet weak var txtoiltemp_motor2: UITextField!
    @IBOutlet weak var txthydvol: UITextField!
    @IBOutlet weak var txthydvol_motor2: UITextField!
    @IBOutlet weak var txtamp: UITextField!
    @IBOutlet weak var txtamp_motor2: UITextField!
    @IBOutlet weak var txtdcac: UITextField!
    @IBOutlet weak var txtdcac_motor2: UITextField!
    @IBOutlet weak var txtias: UITextField!
    @IBOutlet weak var txtoat: UITextField!
    @IBOutlet weak var txtaltimetrocapitan: UITextField!
    @IBOutlet weak var txtaltimetrooficial: UITextField!
    @IBOutlet weak var txtavionserie: UITextField!
    @IBOutlet weak var txtavionciclos: UITextField!
    @IBOutlet weak var txtavionturm: UITextField!
    @IBOutlet weak var txtaviontt: UITextField!
    @IBOutlet weak var txtmotor1serie: UITextField!
    @IBOutlet weak var txtmotor1ciclos: UITextField!
    @IBOutlet weak var txtmotor1turm: UITextField!
    @IBOutlet weak var txtmotor1tt: UITextField!
    @IBOutlet weak var txtmotor2serie: UITextField!
    @IBOutlet weak var txtmotor2ciclos: UITextField!
    @IBOutlet weak var txtmotor2turm: UITextField!
    @IBOutlet weak var txtmotor2tt: UITextField!
    @IBOutlet weak var txtapuserie: UITextField!
    @IBOutlet weak var txtapuciclos: UITextField!
    @IBOutlet weak var txtaputurm: UITextField!
    @IBOutlet weak var txtaputt: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    
    @IBOutlet weak var txtdc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuraView()
        
    }
    
    func configuraView(){
        
        txtn1.delegate = self
        txtn1_motor2.delegate = self
        txtn2.delegate = self
        txtn2_motor2.delegate = self
        txtitt.delegate = self
        txtitt_motor2.delegate = self
        txtfflow.delegate = self
        txtfflow_motor2.delegate = self
        txtftemp.delegate = self
        txtftemp_motor2.delegate = self
        txtoilpress.delegate = self
        txtoilpress_motor2.delegate = self
        txtoiltemp.delegate = self
        txtoiltemp_motor2.delegate = self
        txthydvol.delegate = self
        txthydvol_motor2.delegate = self
        txtamp.delegate = self
        txtamp_motor2.delegate = self
        txtdcac.delegate = self
        txtdcac_motor2.delegate = self
        txtias.delegate = self
        txtoat.delegate = self
        txtaltimetrocapitan.delegate = self
        txtaltimetrooficial.delegate = self
        txtavionserie.delegate = self
        txtavionciclos.delegate = self
        txtavionturm.delegate = self
        txtaviontt.delegate = self
        txtmotor1serie.delegate = self
        txtmotor1ciclos.delegate = self
        txtmotor1turm.delegate = self
        txtmotor1tt.delegate = self
        txtmotor2serie.delegate = self
        txtmotor2ciclos.delegate = self
        txtmotor2turm.delegate = self
        txtmotor2tt.delegate = self
        txtapuserie.delegate = self
        txtapuciclos.delegate = self
        txtaputurm.delegate = self
        txtaputt.delegate = self
        txtdc.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Jet_Instrumentos_TableViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)

        
        txtn1.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtn1_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtn2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtn2_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtitt.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtitt_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtfflow.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtfflow_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtftemp.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtftemp_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtoilpress.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtoilpress_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtoiltemp.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtoiltemp_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txthydvol.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txthydvol_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtamp.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtamp_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtdcac.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtdcac_motor2.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtias.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtoat.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtaltimetrocapitan.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtaltimetrooficial.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtavionciclos.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtavionturm.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtaviontt.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotor1ciclos.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotor1turm.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotor1tt.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotor2ciclos.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotor2turm.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtmotor2tt.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtapuciclos.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtaputurm.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        txtaputt.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        txtdc.addTarget(self, action: #selector(Jet_Instrumentos_TableViewController.Formatear(textField:)), for: .editingChanged)
        
        if(global_var.j_bitacoras_Id != 0){
            //Viene de consultar una bitacora y quiere modificar en caso de estar abierta
            btnCancelar.title = "Cancelar"
            cargarInstrumentos()
        }
    }
    
    
    func cargarInstrumentos(){
        
            
        do{
            
            let formato : NumberFormatter = NumberFormatter()
            formato.numberStyle = .decimal
            
            print(global_var.j_bitacoras_Id.stringValue + " " +  global_var.j_avion_matricula)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
            let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id, global_var.j_avion_matricula])
            fetchRequest.predicate = predicate
            
            let fetchResults = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [BitacorasInstrumentos]
            
            if (fetchResults?.count)! > 0 {
            if let aviones = fetchResults{
                
                for row in aviones{
                    
                    global_var.j_instrumentos_Id = row.idlectura!
                    
                    let n1 = row.jet_n1!, n1_motor2 = row.jet_n1_motor2!
                    let n2 = row.jet_n2!, n2_motor2 = row.jet_n2_motor2!
                    let itt = row.jet_itt!, itt_motor2 = row.jet_itt_motor2!
                    let fflow = row.jet_fflow!, fflow_motor2 = row.jet_fflow_motor2!
                    let ftemp = row.jet_fueltemp!, ftemp_motor2 = row.jet_fueltemp_motor2!
                    let oiltemp = row.jet_oiltemp!, oiltemp_motor2 = row.jet_oiltemp_motor2!
                    let oilpress = row.jet_oilpress!, oilpress_motor2 = row.jet_oilpress_motor2!
                    let hydvol = row.jet_hydvol!, hydvol_motor2 = row.jet_hydvol_motor2!
                    let amp = row.jet_amp!, amp_motor2 = row.jet_amp_motor2!
                    let dcac = row.jet_dcac!, dcac_motor2 = row.jet_dcac_motor2!
                    let ias = row.jet_ias!
                    let oat = row.jet_oat!
                    let altimetrocapitan = row.jet_lecturaaltimetro_capitan!
                    let altimetrooficial = row.jet_lecturaaltimetro_primeroficial!
                    
                    let avion_serie  = row.jet_avion_serie!
                    let motor1_serie = row.jet_motor1_serie!
                    let motor2_serie = row.jet_motor2_serie!
                    let apu = row.jet_apu_serie!
                    
                    let avion_ciclos = row.jet_avion_ciclos!
                    let motor1_ciclos = row.jet_motor1_ciclos!
                    let motor2_ciclos = row.jet_motor2_ciclos!
                    let apu_ciclos = row.jet_apu_ciclos!
                    
                    let avion_turm  = row.jet_avion_turm!
                    let motor1_turm = row.jet_motor1_turm!
                    let motor2_turm = row.jet_motor2_turm!
                    let apu_turm = row.jet_apu_turm!
                    
                    let avion_tt = row.jet_avion_tt!
                    let motor1_tt = row.jet_motor1_tt!
                    let motor2_tt = row.jet_motor2_tt!
                    let apu_tt = row.jet_apu_tt!
                    let dc = row.jet_dc!
                    
                    txtn1.text = formato.string(from: n1)
                    txtn1_motor2.text = formato.string(from: n1_motor2)
                    txtn2.text = formato.string(from: n2)
                    txtn2_motor2.text = formato.string(from: n2_motor2)
                    txtitt.text = formato.string(from: itt)
                    txtitt_motor2.text = formato.string(from: itt_motor2)
                    txtfflow.text = formato.string(from: fflow)
                    txtfflow_motor2.text = formato.string(from: fflow_motor2)
                    txtftemp.text = formato.string(from: ftemp)
                    txtftemp_motor2.text = formato.string(from: ftemp_motor2)
                    txtoilpress.text = formato.string(from: oilpress)
                    txtoilpress_motor2.text = formato.string(from: oilpress_motor2)
                    txtoiltemp.text = formato.string(from: oiltemp)
                    txtoiltemp_motor2.text = formato.string(from: oiltemp_motor2)
                    txthydvol.text = formato.string(from: hydvol)
                    txthydvol_motor2.text = formato.string(from: hydvol_motor2)
                    txtamp.text = formato.string(from: amp)
                    txtamp_motor2.text = formato.string(from: amp_motor2)
                    txtdcac.text = formato.string(from: dcac)
                    txtdcac_motor2.text = formato.string(from: dcac_motor2)
                    txtias.text = formato.string(from: ias)
                    txtoat.text = formato.string(from: oat)
                    txtaltimetrocapitan.text = formato.string(from: altimetrocapitan)
                    txtaltimetrooficial.text = formato.string(from: altimetrooficial)
                    txtavionserie.text = avion_serie
                    txtavionciclos.text = formato.string(from: avion_ciclos)
                    txtavionturm.text = formato.string(from:  avion_turm)
                    txtaviontt.text = formato.string(from:  avion_tt)
                    txtmotor1serie.text = motor1_serie
                    txtmotor1ciclos.text = formato.string(from: motor1_ciclos)
                    txtmotor1turm.text = formato.string(from: motor1_turm)
                    txtmotor1tt.text = formato.string(from: motor1_tt)
                    txtmotor2serie.text = motor2_serie
                    txtmotor2ciclos.text = formato.string(from:  motor2_ciclos)
                    txtmotor2turm.text = formato.string(from:  motor2_turm)
                    txtmotor2tt.text = formato.string(from:  motor2_tt)
                    txtapuserie.text = apu
                    txtapuciclos.text = formato.string(from: apu_ciclos)
                    txtaputurm.text = formato.string(from:  apu_turm)
                    txtaputt.text = formato.string(from: apu_tt)
                    txtdc.text = formato.string(from: dc)
                }
                
            }
            else{
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puedo, Intentalo nuevamente", delegate: self)
                }
            }
        } catch {
            print("error")
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 15
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var rows = 0
        
        
        if section == 13 {
            rows = 4
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
         tableView.deselectRow(at: indexPath, animated: true)
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
            }else{
                return true
            }
            
            //return string == filtered
            
        }
        
        return true
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
        
        let alertController = UIAlertController(title: "", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .default){ action -> Void in
            
            if (global_var.j_bitacora_abierta == 1){
                
                self.GuardarInformacion()
                
                let Status = self.coreDataStack.verificaBitacoraPorCerrar(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                
                //Cierro la bitacora para la sincronizacion
                if(Status == "Sin Error"){
                    
                    self.coreDataStack.actualizaUltimaInformacion(matricula: global_var.j_avion_matricula, ultimabitacora: global_var.j_avion_ultimabitacora, ultimodestino: global_var.j_avion_ultimodestino, ultimohorometro: global_var.j_avion_ultimohorometro, ultimohorometroapu: global_var.j_avion_ultimohorometroapu, sincronizado: 0, ultimoaterrizaje:  (NSNumber(value: global_var.j_avion_ultimoaterrizaje.intValue + 1)), ultimociclo: (NSNumber(value: global_var.j_avion_ultimociclo.intValue + 1)))
                    
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
        
       
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func GuardarInstrumentos(){
        
        
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        
        var n1 : NSNumber = 0, n1_motor2: NSNumber = 0
        var n2 : NSNumber = 0, n2_motor2: NSNumber = 0
        var itt: NSNumber = 0, itt_motor2: NSNumber = 0
        var fflow:NSNumber = 0, fflow_motor2: NSNumber = 0
        var ftemp:NSNumber = 0, ftemp_motor2: NSNumber = 0
        var oiltemp : NSNumber = 0, oiltemp_motor2 : NSNumber = 0
        var oilpress : NSNumber = 0, oilpress_motor2 : NSNumber = 0
        var hydvol : NSNumber = 0, hydvol_motor2: NSNumber = 0
        var amp: NSNumber = 0, amp_motor2: NSNumber = 0
        var dcac: NSNumber = 0, dcac_motor2: NSNumber = 0
        var dc: NSNumber = 0
        var ias: NSNumber = 0
        var oat: NSNumber = 0
        var altimetrocapitan : NSNumber = 0
        var altimetrooficial : NSNumber = 0
        
        var avion_serie : String = ""
        var motor1_serie : String = ""
        var motor2_serie : String = ""
        var apu : String = ""
        
        var avion_ciclos : NSNumber = 0
        var motor1_ciclos : NSNumber = 0
        var motor2_ciclos : NSNumber = 0
        var apu_ciclos : NSNumber = 0
        
        var avion_turm : NSNumber = 0
        var motor1_turm : NSNumber = 0
        var motor2_turm : NSNumber = 0
        var apu_turm : NSNumber = 0
        
        var avion_tt : NSNumber = 0
        var motor1_tt : NSNumber = 0
        var motor2_tt : NSNumber = 0
        var apu_tt : NSNumber = 0
        
        
        if(!txtn1.text!.isEmpty){
            txtn1.text = txtn1.text!.replacingOccurrences(of: ",", with: "")
            if let _n1 = formatter.number(from: txtn1.text! as String)?.floatValue {
                n1 = NSNumber(value: _n1)
                Formatear(textField: txtn1)
            }else{
                txtn1.text = ""
                txtn1.becomeFirstResponder()
            }
        }
        
        if(!txtn1_motor2.text!.isEmpty){
            txtn1_motor2.text = txtn1_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _n1_motor2 = formatter.number(from: txtn1_motor2.text! as String)?.floatValue {
                n1_motor2 = NSNumber(value:_n1_motor2)
                Formatear(textField:txtn1_motor2)
            }else{
                txtn1_motor2.text = ""
                txtn1_motor2.becomeFirstResponder()
            }
        }
        
        
        if(!txtn2.text!.isEmpty){
            txtn2.text = txtn2.text!.replacingOccurrences(of: ",", with: "")
            if let _n2 = formatter.number(from: txtn2.text! as String)?.floatValue {
                n2 = NSNumber(value:_n2)
                Formatear(textField:txtn2)
            }
            else{
                txtn2.text = ""
                txtn2.becomeFirstResponder()
            }
        }
        
        if(!txtn2_motor2.text!.isEmpty){
            txtn2_motor2.text = txtn2_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _n2_motor2 = formatter.number(from: txtn2_motor2.text! as String)?.floatValue {
                n2_motor2 = NSNumber(value:_n2_motor2)
                Formatear(textField:txtn2_motor2)
            }else{
                txtn2_motor2.text = ""
                txtn2_motor2.becomeFirstResponder()
            }
        }
        
        
        if(!txtitt.text!.isEmpty){
            txtitt.text = txtitt.text!.replacingOccurrences(of: ",", with: "")
            if let _itt = formatter.number(from: txtitt.text! as String)?.floatValue {
                itt = NSNumber(value:_itt)
                Formatear(textField:txtitt)
            }else{
                txtitt.text = ""
                txtitt.becomeFirstResponder()
            }
        }
        
        if(!txtitt_motor2.text!.isEmpty){
            txtitt_motor2.text = txtitt_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _itt_motor2 = formatter.number(from: txtitt_motor2.text! as String)?.floatValue {
                itt_motor2 = NSNumber(value:_itt_motor2)
                Formatear(textField:txtitt_motor2)
            }else{
                txtitt_motor2.text = ""
                txtitt_motor2.becomeFirstResponder()
            }
        }
        
        if(!txtfflow.text!.isEmpty){
            txtfflow.text = txtfflow.text!.replacingOccurrences(of: ",", with: "")
            if let _fflow = formatter.number(from: txtfflow.text! as String)?.floatValue
            {
                fflow = NSNumber(value:_fflow)
                Formatear(textField:txtfflow)
            }else{
                txtfflow.text = ""
                txtfflow.becomeFirstResponder()
            }
            
        }
        if(!txtfflow_motor2.text!.isEmpty){
            txtfflow_motor2.text = txtfflow_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _fflow_motor2 = formatter.number(from: txtfflow_motor2.text! as String)?.floatValue
            {
                fflow_motor2 = NSNumber(value:_fflow_motor2)
                Formatear(textField:txtfflow_motor2)
            }else{
                txtfflow_motor2.text = ""
                txtfflow_motor2.becomeFirstResponder()
            }
        }
        
        if(!txtftemp.text!.isEmpty){
            txtftemp.text = txtftemp.text!.replacingOccurrences(of: ",", with: "")
            if let _ftemp = formatter.number(from: txtftemp.text! as String)?.floatValue
            {
                ftemp = NSNumber(value:_ftemp)
                Formatear(textField:txtftemp)
            }else{
                txtftemp.text = ""
                txtftemp.becomeFirstResponder()
            }
           
        }
        if(!txtftemp_motor2.text!.isEmpty){
            txtftemp_motor2.text = txtftemp_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _ftemp_motor2 = formatter.number(from: txtftemp_motor2.text! as String)?.floatValue
            {
                ftemp_motor2 = NSNumber(value:_ftemp_motor2)
                Formatear(textField:txtftemp_motor2)
            }else{
                txtftemp_motor2.text = ""
                txtftemp_motor2.becomeFirstResponder()
            }
        }
        
        if(!txtoiltemp.text!.isEmpty){
            txtoiltemp.text = txtoiltemp.text!.replacingOccurrences(of: ",", with: "")
            if let _oiltemp = formatter.number(from: txtoiltemp.text! as String)?.floatValue
            {
                oiltemp = NSNumber(value:_oiltemp)
                Formatear(textField:txtoiltemp)
            }else{
                txtoiltemp.text = ""
                txtoiltemp.becomeFirstResponder()
            }
            
        }
        
        if(!txtoiltemp_motor2.text!.isEmpty){
            txtoiltemp_motor2.text = txtoiltemp_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _oiltemp_motor2 = formatter.number(from: txtoiltemp_motor2.text! as String)?.floatValue
            {
                oiltemp_motor2 = NSNumber(value:_oiltemp_motor2)
                Formatear(textField:txtoiltemp_motor2)
            }else{
                txtoiltemp_motor2.text = ""
                txtoiltemp_motor2.becomeFirstResponder()
            }
        }
        if(!txtoilpress.text!.isEmpty){
            txtoilpress.text = txtoilpress.text!.replacingOccurrences(of: ",", with: "")
            if let _oilpress = formatter.number(from: txtoilpress.text! as String)?.floatValue
            {
                oilpress = NSNumber(value:_oilpress)
                Formatear(textField:txtoilpress)
            }else{
                txtoilpress.text = ""
                txtoilpress.becomeFirstResponder()
            }
        }
        
        if(!txtoilpress_motor2.text!.isEmpty){
            txtoilpress_motor2.text = txtoilpress_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _oilpress_motor2 = formatter.number(from: txtoilpress_motor2.text! as String)?.floatValue
            {
                oilpress_motor2 = NSNumber(value:_oilpress_motor2)
                Formatear(textField:txtoilpress_motor2)
            }else{
                txtoilpress_motor2.text = ""
                txtoilpress_motor2.becomeFirstResponder()
            }
            
        }
        if(!txthydvol.text!.isEmpty){
            txthydvol.text = txthydvol.text!.replacingOccurrences(of: ",", with: "")
            if let _hydvol = formatter.number(from: txthydvol.text! as String)?.floatValue
            {
                hydvol = NSNumber(value:_hydvol)
                Formatear(textField:txthydvol)
            }else{
                txthydvol.text = ""
                txthydvol.becomeFirstResponder()
            }
        }
        if(!txthydvol_motor2.text!.isEmpty){
            txthydvol_motor2.text = txthydvol_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _hydvol_motor2 = formatter.number(from: txthydvol_motor2.text! as String)?.floatValue
            {
                hydvol_motor2 = NSNumber(value:_hydvol_motor2)
                Formatear(textField:txthydvol_motor2)
            }else{
                txthydvol.text = ""
                txthydvol.becomeFirstResponder()
            }
        }
        if(!txtamp.text!.isEmpty){
            txtamp.text = txtamp.text!.replacingOccurrences(of: ",", with: "")
            if let _amp = formatter.number(from: txtamp.text! as String)?.floatValue
            {
                amp = NSNumber(value:_amp)
                Formatear(textField:txtamp)
            }else{
                txtamp.text = ""
                txtamp.becomeFirstResponder()
            }
        }
        if(!txtamp_motor2.text!.isEmpty){
            txtamp_motor2.text = txtamp_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _amp_motor2 = formatter.number(from: txtamp_motor2.text! as String)?.floatValue
            {
                amp_motor2 = NSNumber(value:_amp_motor2)
                Formatear(textField:txtamp_motor2)
            }else{
                txtamp_motor2.text = ""
                txtamp_motor2.becomeFirstResponder()
            }
        }
        if(!txtdcac.text!.isEmpty){
            txtdcac.text = txtdcac.text!.replacingOccurrences(of: ",", with: "")
            if let _dcac = formatter.number(from: txtdcac.text! as String)?.floatValue
            {
                dcac = NSNumber(value:_dcac)
                Formatear(textField:txtdcac)
            }else{
                txtdcac.text = ""
                txtdcac.becomeFirstResponder()
            }
        }
        if(!txtdcac_motor2.text!.isEmpty){
            txtdcac_motor2.text = txtdcac_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _dcac_motor2 = formatter.number(from: txtdcac_motor2.text! as String)?.floatValue
            {
                dcac_motor2 = NSNumber(value:_dcac_motor2)
                Formatear(textField:txtdcac_motor2)
            }else{
                txtdcac_motor2.text = ""
                txtdcac_motor2.becomeFirstResponder()
            }
        }
        if(!txtias.text!.isEmpty){
            txtias.text = txtias.text!.replacingOccurrences(of: ",", with: "")
            if let _ias = formatter.number(from: txtias.text! as String)?.floatValue
            {
                ias = NSNumber(value:_ias)
                Formatear(textField:txtias)
            }else{
                txtias.text = ""
                txtias.becomeFirstResponder()
            }
        }
        if(!txtoat.text!.isEmpty){
            txtoat.text = txtoat.text!.replacingOccurrences(of: ",", with: "")
            if let _oat = formatter.number(from: txtoat.text! as String)?.floatValue
            {
                oat = NSNumber(value:_oat)
                Formatear(textField:txtoat)
            }else{
                txtoat.text = ""
                txtoat.becomeFirstResponder()
            }
        }
        if(!txtaltimetrocapitan.text!.isEmpty){
            txtaltimetrocapitan.text = txtaltimetrocapitan.text!.replacingOccurrences(of: ",", with: "")
            if let _altimetrocapitan = formatter.number(from: txtaltimetrocapitan.text! as String)?.floatValue
            {
                altimetrocapitan = NSNumber(value:_altimetrocapitan)
                Formatear(textField:txtaltimetrocapitan)
            }else{
                txtaltimetrocapitan.text = ""
                txtaltimetrocapitan.becomeFirstResponder()
            }
            
        }
        if(!txtaltimetrooficial.text!.isEmpty){
            txtaltimetrooficial.text = txtaltimetrooficial.text!.replacingOccurrences(of: ",", with: "")
            if let _altimetrooficial = formatter.number(from: txtaltimetrooficial.text! as String)?.floatValue
            {
                altimetrooficial = NSNumber(value:_altimetrooficial)
                Formatear(textField:txtaltimetrooficial)
            }else{
                txtaltimetrooficial.text = ""
                txtaltimetrooficial.becomeFirstResponder()
            }
           
        }
        if(!txtavionciclos.text!.isEmpty){
            txtavionciclos.text = txtavionciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _avion_ciclos = formatter.number(from: txtavionciclos.text! as String)?.floatValue
            {
                avion_ciclos = NSNumber(value:_avion_ciclos)
                Formatear(textField:txtavionciclos)
            }else{
                txtavionciclos.text = ""
                txtavionciclos.becomeFirstResponder()
            }
           
        }
        if(!txtmotor1ciclos.text!.isEmpty){
            txtmotor1ciclos.text = txtmotor1ciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _motor1_ciclos = formatter.number(from: txtmotor1ciclos.text! as String)?.floatValue
            {
                motor1_ciclos = NSNumber(value:_motor1_ciclos)
                Formatear(textField:txtmotor1ciclos)
            }else{
                txtmotor1ciclos.text = ""
                txtmotor1ciclos.becomeFirstResponder()
            }
        }
        if(!txtmotor2ciclos.text!.isEmpty){
            txtmotor2ciclos.text = txtmotor2ciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _motor2_ciclos = formatter.number(from: txtmotor2ciclos.text! as String)?.floatValue
            {
                motor2_ciclos = NSNumber(value:_motor2_ciclos)
                Formatear(textField:txtmotor2ciclos)
            }else{
                txtmotor2ciclos.text = ""
                txtmotor2ciclos.becomeFirstResponder()
            }
           
        }
        if(!txtapuciclos.text!.isEmpty){
            txtapuciclos.text = txtapuciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _apu_ciclos = formatter.number(from: txtapuciclos.text! as String)?.floatValue
            {
                apu_ciclos = NSNumber(value: _apu_ciclos)
                Formatear(textField:txtapuciclos)
            }else{
                txtapuciclos.text = ""
                txtapuciclos.becomeFirstResponder()
            }
           
        }
        if(!txtavionturm.text!.isEmpty){
            txtavionturm.text = txtavionturm.text!.replacingOccurrences(of: ",", with: "")
            if let _avion_turm = formatter.number(from: txtavionturm.text! as String)?.floatValue
            {
                avion_turm = NSNumber(value:_avion_turm)
                Formatear(textField:txtavionturm)
            }else{
                txtavionturm.text = ""
                txtavionturm.becomeFirstResponder()
            }
        
        }
        if(!txtmotor1turm.text!.isEmpty){
            txtmotor1turm.text = txtmotor1turm.text!.replacingOccurrences(of: ",", with: "")
            if let _motor1_turm = formatter.number(from: txtmotor1turm.text! as String)?.floatValue
            {
                motor1_turm = NSNumber(value:_motor1_turm)
                Formatear(textField:txtmotor1turm)
            }else{
                txtmotor1turm.text = ""
                txtmotor1turm.becomeFirstResponder()
            }
            
        }
        if(!txtmotor2turm.text!.isEmpty){
            txtmotor2turm.text = txtmotor2turm.text!.replacingOccurrences(of: ",", with: "")
            if let _motor2_turm = formatter.number(from: txtmotor2turm.text! as String)?.floatValue
            {
                motor2_turm = NSNumber(value:_motor2_turm)
                Formatear(textField:txtmotor2turm)
            }else{
                txtmotor2turm.text = ""
                txtmotor2turm.becomeFirstResponder()
            }
            
        }
        if(!txtamp_motor2.text!.isEmpty){
            txtamp_motor2.text = txtamp_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _amp_motor2 = formatter.number(from: txtamp_motor2.text! as String)?.floatValue
            {
                amp_motor2 = NSNumber(value:_amp_motor2)
                Formatear(textField:txtamp_motor2)
            }else{
                txtamp_motor2.text = ""
                txtamp_motor2.becomeFirstResponder()
            }
        }
        if(!txtdcac.text!.isEmpty){
            txtdcac.text = txtdcac.text!.replacingOccurrences(of: ",", with: "")
            if let _dcac = formatter.number(from: txtdcac.text! as String)?.floatValue
            {
                dcac = NSNumber(value:_dcac)
                Formatear(textField:txtdcac)
            }else{
                txtdcac.text = ""
                txtdcac.becomeFirstResponder()
            }
           
        }
        if(!txtdcac_motor2.text!.isEmpty){
            txtdcac_motor2.text = txtdcac_motor2.text!.replacingOccurrences(of: ",", with: "")
            if let _dcac_motor2 = formatter.number(from: txtdcac_motor2.text! as String)?.floatValue
            {
                dcac_motor2 = NSNumber(value:_dcac_motor2)
                Formatear(textField:txtdcac_motor2)
            }else{
                txtdcac_motor2.text = ""
                txtdcac_motor2.becomeFirstResponder()
            }
           
        }
        if(!txtias.text!.isEmpty){
            txtias.text = txtias.text!.replacingOccurrences(of: ",", with: "")
            if let _ias = formatter.number(from: txtias.text! as String)?.floatValue
            {
                ias = NSNumber(value:_ias)
                Formatear(textField:txtias)
            }else{
                txtias.text = ""
                txtias.becomeFirstResponder()
            }
            
        }
        if(!txtoat.text!.isEmpty){
            txtoat.text = txtoat.text!.replacingOccurrences(of: ",", with: "")
            if let _oat = formatter.number(from: txtoat.text! as String)?.floatValue
            {
                oat = NSNumber(value:_oat)
                Formatear(textField:txtoat)
            }else{
                txtoat.text = ""
                txtoat.becomeFirstResponder()
            }
           
        }
        
        if(!txtavionserie.text!.isEmpty){
            avion_serie = txtavionserie.text!
        }
        
        if(!txtmotor1serie.text!.isEmpty){
            motor1_serie = txtmotor1serie.text!
        }
        
        if(!txtmotor2serie.text!.isEmpty){
            motor2_serie = txtmotor2serie.text!
        }
        
        if(!txtapuserie.text!.isEmpty){
            apu = txtapuserie.text!
        }
        
        if(!txtavionciclos.text!.isEmpty){
            txtavionciclos.text = txtavionciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _avion_ciclos = formatter.number(from: txtavionciclos.text! as String)?.floatValue
            {
                avion_ciclos = NSNumber(value:_avion_ciclos)
                Formatear(textField:txtavionciclos)
            }else{
                txtavionciclos.text = ""
                txtavionciclos.becomeFirstResponder()
            }
        }
        
        if(!txtmotor1ciclos.text!.isEmpty){
            txtmotor1ciclos.text = txtmotor1ciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _motor1_ciclos = formatter.number(from: txtmotor1ciclos.text! as String)?.floatValue
            {
                motor1_ciclos = NSNumber(value:_motor1_ciclos)
                Formatear(textField:txtmotor1ciclos)
            }else{
                txtmotor1ciclos.text = ""
                txtmotor1ciclos.becomeFirstResponder()
            }
        }
        if(!txtmotor2ciclos.text!.isEmpty){
            txtmotor2ciclos.text = txtmotor2ciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _motor2_ciclos = formatter.number(from: txtmotor2ciclos.text! as String)?.floatValue
            {
                motor2_ciclos = NSNumber(value:_motor2_ciclos)
                Formatear(textField:txtmotor2ciclos)
            }else{
                txtmotor2ciclos.text = ""
                txtmotor2ciclos.becomeFirstResponder()
            }
        }
        if(!txtapuciclos.text!.isEmpty){
            txtapuciclos.text = txtapuciclos.text!.replacingOccurrences(of: ",", with: "")
            if let _apu_ciclos = formatter.number(from: txtapuciclos.text! as String)?.floatValue
            {
                apu_ciclos = NSNumber(value:_apu_ciclos)
                Formatear(textField:txtapuciclos)
            }else{
                txtapuciclos.text = ""
                txtapuciclos.becomeFirstResponder()
            }
        }
        if(!txtavionturm.text!.isEmpty){
            txtavionturm.text = txtavionturm.text!.replacingOccurrences(of: ",", with: "")
            if let _avion_turm = formatter.number(from: txtavionturm.text! as String)?.floatValue
            {
                avion_turm = NSNumber(value:_avion_turm)
                Formatear(textField:txtavionturm)
            }else{
                txtavionturm.text = ""
                txtavionturm.becomeFirstResponder()
            }
        }
        if(!txtmotor1turm.text!.isEmpty){
            txtmotor1turm.text = txtmotor1turm.text!.replacingOccurrences(of: ",", with: "")
            if let _motor1_turm = formatter.number(from: txtmotor1turm.text! as String)?.floatValue
            {
                motor1_turm = NSNumber(value:_motor1_turm)
                Formatear(textField:txtmotor1turm)
            }else{
                txtmotor1turm.text = ""
                txtmotor1turm.becomeFirstResponder()
            }
        }
        if(!txtmotor2turm.text!.isEmpty){
            txtmotor2turm.text = txtmotor2turm.text!.replacingOccurrences(of: ",", with: "")
            if let _motor2_turm = formatter.number(from: txtmotor2turm.text! as String)?.floatValue
            {
                motor2_turm = NSNumber(value:_motor2_turm)
                Formatear(textField:txtmotor2turm)
            }else{
                txtmotor2turm.text = ""
                txtmotor2turm.becomeFirstResponder()
            }
        }
        if(!txtaputurm.text!.isEmpty){
            txtaputurm.text = txtaputurm.text!.replacingOccurrences(of: ",", with: "")
            if let _apu_turm = formatter.number(from: txtaputurm.text! as String)?.floatValue
            {
                apu_turm = NSNumber(value:_apu_turm)
                Formatear(textField:txtaputurm)
            }else{
                txtaputurm.text = ""
                txtaputurm.becomeFirstResponder()
            }
        }
        if(!txtaviontt.text!.isEmpty){
            txtaviontt.text = txtaviontt.text!.replacingOccurrences(of: ",", with: "")
            if let _avion_tt = formatter.number(from: txtaviontt.text! as String)?.floatValue
            {
                avion_tt = NSNumber(value:_avion_tt)
                Formatear(textField:txtaviontt)
            }else{
                txtaviontt.text = ""
                txtaviontt.becomeFirstResponder()
            }
        }
        if(!txtmotor1tt.text!.isEmpty){
            txtmotor1tt.text = txtmotor1tt.text!.replacingOccurrences(of: ",", with: "")
            if let _motor1_tt = formatter.number(from: txtmotor1tt.text! as String)?.floatValue
            {
                motor1_tt = NSNumber(value:_motor1_tt)
                Formatear(textField:txtmotor1tt)
            }else{
                txtmotor1tt.text = ""
                txtmotor1tt.becomeFirstResponder()
            }
        }
        if(!txtmotor2tt.text!.isEmpty){
            txtmotor2tt.text = txtmotor2tt.text!.replacingOccurrences(of: ",", with: "")
            if let _motor2_tt = formatter.number(from: txtmotor2tt.text! as String)?.floatValue
            {
                motor2_tt = NSNumber(value:_motor2_tt)
                Formatear(textField:txtmotor2tt)
            }else{
                txtmotor2tt.text = ""
                txtmotor2tt.becomeFirstResponder()
            }
        }
        if(!txtaputt.text!.isEmpty){
            txtaputt.text = txtaputt.text!.replacingOccurrences(of: ",", with: "")
            if let _apu_tt = formatter.number(from: txtaputt.text! as String)?.floatValue
            {
                apu_tt = NSNumber(value:_apu_tt)
                Formatear(textField:txtaputt)
            }else{
                txtaputt.text = ""
                txtaputt.becomeFirstResponder()
            }
        }
        
        if(!txtdc.text!.isEmpty){
            txtdc.text = txtdc.text!.replacingOccurrences(of: ",", with: "")
            if let _apu_tt = formatter.number(from: txtdc.text! as String)?.floatValue
            {
                dc = NSNumber(value:_apu_tt)
                Formatear(textField:txtdc)
            }else{
                txtdc.text = ""
                txtdc.becomeFirstResponder()
            }
        }
        if( global_var.j_tramos_Id !=  0){
            
            if (global_var.j_instrumentos_Id == 0) {
                
                global_var.j_instrumentos_Id = coreDataStack.obtenerIdInstrumento()
                
                coreDataStack.agregarInstrumentos_Jet(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_instrumentos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, jet_amp: amp, jet_amp_motor2: amp_motor2, jet_dcac: dcac, jet_dcac_motor2: dcac_motor2, jet_fflow: fflow, jet_fflow_motor2: fflow_motor2, jet_fueltemp: ftemp, jet_fueltemp_motor2: ftemp_motor2, jet_hydvol: hydvol, jet_hydvol_motor2: hydvol_motor2, jet_itt: itt, jet_itt_motor2: itt_motor2, jet_n1: n1, jet_n1_motor2: n1_motor2, jet_n2: n2, jet_n2_motor2: n2_motor2, jet_oilpress: oilpress, jet_oilpress_motor2: oilpress_motor2, jet_oiltemp: oiltemp, jet_oiltemp_motor2: oiltemp_motor2, jet_lecturaaltimetro_capitan: altimetrocapitan, jet_lecturaaltimetro_primeroficial: altimetrooficial, jet_avion_serie: avion_serie, jet_motor1_serie: motor1_serie, jet_motor2_serie: motor2_serie, jet_apu_serie: apu, jet_avion_ciclos: avion_ciclos, jet_motor1_ciclos: motor1_ciclos, jet_motor2_ciclos: motor2_ciclos, jet_apu_ciclos: apu_ciclos, jet_avion_turm: avion_turm, jet_motor1_turm: motor1_turm, jet_motor2_turm: motor2_turm, jet_apu_turm: apu_turm, jet_avion_tt: avion_tt, jet_motor1_tt: motor1_tt, jet_motor2_tt: motor2_tt, jet_apu_tt: apu_tt, jet_ias: ias, jet_oat: oat, jet_dc: dc)
              
            }else {
                //Actualizacion
                
                coreDataStack.actualizaInstrumentos_Jet(idbitacora: global_var.j_bitacoras_Id, idlectura: global_var.j_instrumentos_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula, numbitacora: global_var.j_bitacora_num, jet_amp: amp, jet_amp_motor2: amp_motor2, jet_dcac: dcac, jet_dcac_motor2: dcac_motor2, jet_fflow: fflow, jet_fflow_motor2: fflow_motor2, jet_fueltemp: ftemp, jet_fueltemp_motor2: ftemp_motor2, jet_hydvol: hydvol, jet_hydvol_motor2: hydvol_motor2, jet_itt: itt, jet_itt_motor2: itt_motor2, jet_n1: n1, jet_n1_motor2: n1_motor2, jet_n2: n2, jet_n2_motor2: n2_motor2, jet_oilpress: oilpress, jet_oilpress_motor2: oilpress_motor2, jet_oiltemp: oiltemp, jet_oiltemp_motor2: oiltemp_motor2, jet_lecturaaltimetro_capitan: altimetrocapitan, jet_lecturaaltimetro_primeroficial: altimetrooficial, jet_avion_serie: avion_serie, jet_motor1_serie: motor1_serie, jet_motor2_serie: motor2_serie, jet_apu_serie: apu, jet_avion_ciclos: avion_ciclos, jet_motor1_ciclos: motor1_ciclos, jet_motor2_ciclos: motor2_ciclos, jet_apu_ciclos: apu_ciclos, jet_avion_turm: avion_turm, jet_motor1_turm: motor1_turm, jet_motor2_turm: motor2_turm, jet_apu_turm: apu_turm, jet_avion_tt: avion_tt, jet_motor1_tt: motor1_tt, jet_motor2_tt: motor2_tt, jet_apu_tt: apu_tt, jet_ias: ias, jet_oat: oat, jet_dc: dc)

            }
            
        }
        else{
            Util.invokeAlertMethod(strTitle: "", strBody: "Es necesario registrar información del vuelo para continuar con los instrumentos ", delegate: self)
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
                
            }
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

    @IBAction func btnGuardar(sender: AnyObject) {
        
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
    
    
}
