//
//  PistonMono_Pasajeros_ViewController.swift


import UIKit
import CoreData

class PistonMono_Pasajeros_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var dictionary : NSDictionary!
    var dataSource : NSDictionary!
    var dt : Array<AnyObject> = []
    var searchResultados : NSArray!
    var searchActive : Bool = false
    var logica = Util()
    var coreDataStack = CoreDataStack()
    var menu : UIBarButtonItem = UIBarButtonItem()
    var agregar : UIBarButtonItem = UIBarButtonItem()
    
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let resizingMask: UIView.AutoresizingMask = [.flexibleWidth , .flexibleHeight]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(global_var.j_bitacoras_Id)
        
        configurarNavegacion()
        cargarPax()
        
        if(global_var.j_bitacoras_Id != 0){
            //Quiere decir que ya se capturo la bitacora y ya no puede cancelar
            btnCancelar.title = "Cancelar"
        }
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configurarNavegacion(){
        
        menu = UIBarButtonItem(title: "Cerrar Bitácora", style: .done, target: self, action: #selector(PistonMono_Pasajeros_ViewController.mostrarMenu))
        agregar = UIBarButtonItem(title: "Agregar", style: .done, target: self, action: #selector(PistonMono_Pasajeros_ViewController.addPax))
        //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "mostrarMenu")
        //let agregar : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: ., target: self, action: "addPax")
        
        self.navigationItem.rightBarButtonItems = [menu, agregar]
    }
    
    //MARK - Table View Delegate
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dt.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var altura : CGFloat = 0
        if DeviceType.IS_IPAD {
            altura = 90
        }else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            altura = 60
        }else{
            altura = 90
        }
        return altura
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! Pasajeros_TableViewCell
        cell.backgroundColor = UIColor.clear
        
        if let row = dt[(indexPath as NSIndexPath).row] as? BitacorasPax {
            
            print(row.nombre!)
            cell.Nombre.text = row.nombre!
            
        }
        
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let pax = dt[(indexPath as NSIndexPath).row] as! BitacorasPax
        
        if editingStyle == .delete {
            
            if global_var.j_bitacora_abierta == 1{
                
                
                coreDataStack.eliminarPasajero(idpax: pax.idpax!, bitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                
                self.cargarPax()
            }
            else{
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexpath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Quitar", handler:{action, indexpath in
            
            if global_var.j_bitacora_abierta == 1 {
                let pax = self.dt[(indexpath as NSIndexPath).row] as! BitacorasPax
                self.coreDataStack.eliminarPasajero(idpax: pax.idpax!, bitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                self.cargarPax()
            }
            else{
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
        });
        
        return [deleteRowAction];
    }
    
    /*
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Quitar", handler:{action, indexpath in
            
            if global_var.j_bitacora_abierta == 1 {
                let pax = self.dt[indexPath.row] as! BitacorasPax
                self.coreDataStack.eliminarPasajero(pax.idpax!, bitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                self.cargarPax()
            }
            else{
                Util.invokeAlertMethod("Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
        });
        
        return [deleteRowAction];
        
    }*/
    
    @IBAction func btnCancelar(sender: AnyObject) {
        
        regresarABitacoras()
        
    }
    
    @objc func addPax(){
      
        if(global_var.j_bitacoras_Id != 0){
            
            var inputTextField: UITextField?
            inputTextField?.text = ""
            inputTextField?.delegate = self
            
            let alertController = UIAlertController(title: "Agregar Pasajero", message: "", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { (action) -> Void in
                
                let pasajeronombre  = inputTextField!.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
                
                if (!inputTextField!.text!.isEmpty &&  pasajeronombre != ""){
                
                global_var.j_pasajeros_Id = self.coreDataStack.obtenerIdPax(bitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                
                self.coreDataStack.agregarBitacoraPasajero(idbitacora: global_var.j_bitacoras_Id, idpax: global_var.j_pasajeros_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nombre: inputTextField!.text!, matricula: global_var.j_avion_matricula)
                    
                    self.cargarPax()
                    if(self.dt.count < (global_var.j_avion_totalpax) as! Int){
                        self.addPax()
                    }
                }else{
                    Util.invokeAlertMethod(strTitle: "Error", strBody: "Debes ingresar un nombre valido", delegate: self)
                    self.addPax()
                }
                
            })
            let cancel = UIAlertAction(title: "Cancelar", style: .destructive) { (action) -> Void in
            }
            
            alertController.addTextField(configurationHandler: {
                (textField) -> Void in
                inputTextField = textField
                inputTextField?.autocapitalizationType = UITextAutocapitalizationType.words
                inputTextField?.placeholder = "Nombre del pasajero"
                inputTextField?.font = UIFont(name: "Helvetica", size: 18)
                inputTextField?.returnKeyType = .continue
            
            })
            
            alertController.addAction(cancel)
            alertController.addAction(ok)
            
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            Util.invokeAlertMethod(strTitle: "", strBody: "Debes registrar primero el tramo para ingresar los pasajeros", delegate: self)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("registrar el pasajero")
       
        return false
        
    }
    
    @objc func mostrarMenu(){
        
        let mensaje = "Se cerrará la bitácora con el folio: ** \(global_var.j_bitacora_num) ** "
        
        let alertController = UIAlertController(title: "", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let _: UIAlertAction = UIAlertAction(title: "Guardar y Continuar", style: .default) { action -> Void in
            
            if global_var.j_bitacora_abierta == 2 {
                
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
                
            }
            
        }
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .default){ action -> Void in
            
            if global_var.j_bitacora_abierta == 1 {
               
                let Status = self.coreDataStack.verificaBitacoraPorCerrar(idbitacora: global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                
                //Cierro la bitacora para la sincronizacion
                if(Status == "Sin Error"){
                    
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
            }else{
                
                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
        
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        //alertController.addAction(saveAction)
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    func cargarPax(){
        
        if(global_var.j_bitacoras_Id != 0){
            
            dt.removeAll(keepingCapacity: false)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
            request.predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id, global_var.j_avion_matricula])
            
            dt = try! coreDataStack.managedObjectContext.fetch(request) as Array<AnyObject>
            
            print("Total Pax: \(dt.count)")
            
            print("Total Pax permitido: \(global_var.j_avion_totalpax)")
            if(dt.count >= (global_var.j_avion_totalpax) as! Int){
                self.agregar.isEnabled = false
            }else{
                
                agregar.isEnabled = true
            }
            
            tableView.reloadData()
            
        }
    }
    
    
    
    //MARK: - Funciones Locales
    
    func regresarTramos(){
        self.parent!.navigationController?.setNavigationBarHidden(true, animated: true)
        self.parent!.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Busquedas
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchText.isEmpty {
            searchActive = false
        }
        else{
            searchActive = true
        }
        
        //filtrarContenido(searchText)
        
        tableView.reloadData()
    }
    
    func filtrarContenido(searchText: String) {
        // Filter the array using the filter method
        _ = NSPredicate(format: "Nombre contains[c] %@", searchText)
        //self.searchResultados = NSMutableArray(array: self.dt.filteredArrayUsingPredicate(resultPredicate))
        
        print("Item en resultado \(self.searchResultados.count)")
    }
    
    func regresarABitacoras(){
        
               
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.present(destviewcontroller, animated: true, completion: nil)
    }

}
