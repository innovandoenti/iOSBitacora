//
//  ReportesTableViewController.swift


import UIKit
import CoreData

class ReportesTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var txtreportes: UITextView!
    @IBOutlet weak var txtobservaciones: UITextView!
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    @IBOutlet weak var btnShowMenu: UIBarButtonItem!
    @IBOutlet weak var txtmotivo: UITextView!
    @IBOutlet weak var txtprevuelo: UITextView!
    
    let coreDataStack = CoreDataStack()
    let formatter : NumberFormatter = NumberFormatter()
    let effect = UIBlurEffect(style: .dark)
    let resizingMask: UIView.AutoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReportesTableViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        if(global_var.j_bitacoras_Id != 0){
            self.verificaReportes()
        }else{
            txtprevuelo.text = global_var.j_bitacora_prevuelo
            if global_var.j_bitacora_prevuelolocal == 1 {
                txtprevuelo.backgroundColor = UIColor(white:0.9, alpha:1.0)
                
                txtprevuelo.isEditable = false
                
            }
        }
        
    }
    
    @objc func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func buildImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "Default.png"))
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
    
    
    
    func verificaReportes(){
       
        let formato : NumberFormatter = NumberFormatter()
        formato.numberStyle = .decimal
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id,global_var.j_bitacora_matricula])
        fetchRequest.predicate = predicate
        
        do{
            let fetchResults = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
            
            if let aviones = fetchResults{
                
                for row in aviones{
                    
                    txtreportes.text = row.mantenimientointerno
                    txtobservaciones.text = row.mantenimientodgac
                    txtmotivo.text = row.accioncorrectiva
                    txtprevuelo.text = row.quienprevuelo
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.q
        return 1
    }
    
    @IBAction func btnCancelar(sender: AnyObject) {
        regresarABitacoras()
    }
    
    @IBAction func mostrarMenu(sender: AnyObject) {
        
        let mensaje = "Se cerrará la bitácora con el folio: ** \(global_var.j_bitacora_num) ** "
        
        let alertController = UIAlertController(title: "", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .default){ action -> Void in
            
            if (global_var.j_bitacora_abierta == 1){
                
                
                if(global_var.j_bitacoras_Id == 0){ //No se ha registrado la bitacora
                    Util.invokeAlertMethod(strTitle: "Cuidado", strBody: "Es necesario primero registrar información del vuelo", delegate: self)
                    
                    if let tabBarController = self.tabBarController {
                        tabBarController.selectedIndex = 0
                        let vc : TVC_TramosTableViewController = TVC_TramosTableViewController()
                        vc.txtNombreCopiloto.resignFirstResponder()
                    }
                }else{
                    
                    self.GuardarReportes()
                    
                    let Status = self.coreDataStack.verificaBitacoraPorCerrar(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                    
                    //Cierro la bitacora para la sincronizacion
                    if(Status == "Sin Error"){
                        
                        self.GuardarReportes()
                        
                            self.coreDataStack.actualizaUltimaInformacion(matricula: global_var.j_avion_matricula, ultimabitacora: global_var.j_bitacora_ultima_bitacora, ultimodestino: global_var.j_bitacora_ultimo_destino, ultimohorometro: global_var.j_bitacora_ultimo_horometro, ultimohorometroapu: 0, sincronizado: 0, ultimoaterrizaje:  global_var.j_bitacora_ultimo_aterrizaje, ultimociclo: global_var.j_bitacora_ultimo_ciclo)
                            
                            
                            self.coreDataStack.cerrarBitacora(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                            
                            Util.invokeAlertMethod(strTitle: "Bitácora Cerrada", strBody: "Revisa tu información y sincroniza tu bitácora.", delegate: self)
                            
                            self.regresarABitacoras()
                        
                    }else{
                        Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica \(Status)" as NSString, delegate: self)
                        if let tabBarController = self.tabBarController {
                            tabBarController.selectedIndex = 0
                        }
                        
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
    
    func GuardarReportes(){
        
        
        var reportes =  ""
        var observaciones = ""
        var motivo = ""
        var prevuelo = ""
        
        if !txtreportes.text!.isEmpty {
            reportes = txtreportes.text!
        }
        
        if !txtobservaciones.text!.isEmpty {
            observaciones = txtobservaciones.text!
        }
        
        if !txtmotivo.text!.isEmpty {
            motivo = txtmotivo.text!
        }
        
        if !txtprevuelo.text!.isEmpty {
            prevuelo = txtprevuelo.text!
        }
        
        if txtprevuelo.isEditable {
            global_var.j_bitacora_prevuelolocal = 0
        }
        
        coreDataStack.agregarReportes(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_bitacora_matricula, mantenimientodgac: observaciones, mantenimientointerno: reportes, motivo: motivo, prevuelo: prevuelo, prevuelolocal: global_var.j_bitacora_prevuelolocal)
        
        print("Se actualizo la bitácora con sus reportes")
    }
    
    func regresarABitacoras() {
        
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.present(destviewcontroller, animated: true, completion: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.GuardarReportes()
    }
    
    @IBAction func btnGuardar(sender: AnyObject) {
        
        if global_var.j_bitacora_abierta == 1 {
            if(global_var.j_bitacoras_Id != 0){
                self.GuardarReportes()
                self.btnCancelar.title = "Cancelar"
            }
            else{
                Util.invokeAlertMethod(strTitle: "Cuidado", strBody: "Es necesario primero registrar datos del vuelo", delegate: self)
                
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 0
                }
            }
            
        }else{
            
            Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
        }
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
        
        
    }

   

}
