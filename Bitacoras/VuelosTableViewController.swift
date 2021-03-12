    //
//  VuelosTableViewController.swift

import UIKit
import EventKit
import CoreData

class VuelosTableViewController : UITableViewController {
    
    let coreDataStack = CoreDataStack()
    let notificacion = Notificationes()
    var dt2 : NSMutableArray = NSMutableArray()
    var logica = Util()
    var dictionary : NSDictionary!
    var dataSource : NSDictionary!
    var results : NSArray = NSArray()
    var totalArray : Array<AnyObject> = []
    var formato : DateFormatter = DateFormatter()
    var formatter : NumberFormatter = NumberFormatter()
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    @IBOutlet var myTable: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(VuelosTableViewController.refreshInvoked), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(VuelosTableViewController.cargarVuelos), name: NSNotification.Name(rawValue: "cargarVuelos"), object: self)
        
        if(Conexion.isConnectedToNetwork()){
            registarUDID()
            sincronizaVuelos()
        }
        else{
            cargarVuelos()
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
    
   
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
       return totalArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        
        let fecha_formato : DateFormatter = DateFormatter()
        fecha_formato.dateStyle = .short
        fecha_formato.timeStyle = .none
        fecha_formato.dateFormat = "dd/MM/yyy"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VuelosTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        if let vuelo = totalArray[(indexPath as NSIndexPath).row] as? Vuelos {
            
            cell.LbMatricula.text = vuelo.tailnumber!
            cell.LbRuta.text = vuelo.aeropuertosale! + " - " + vuelo.aeropuertollega!
            cell.LbCliente.text = vuelo.customername
            print("Es la fecha: \(vuelo.fecha!)")
            if let fecha = vuelo.fecha {
                 cell.LbFecha.text = fecha_formato.string(from: (fecha as NSDate) as Date)
            }
            
            cell.LbTV.text = vuelo.horavuelo!
            cell.LbTiempoVuelo.text = vuelo.horasale!
            cell.BtnPax.titleLabel?.text = vuelo.legid!
            
        }
       
        
        return cell

    }
    
    @IBAction func abrirPax(sender: UIButton) {
        DispatchQueue.main.async() {
            print(sender.titleLabel!.text!)
            global_var.j_vuelo_legid = sender.titleLabel!.text!
            print(global_var.j_vuelo_legid)
            self.performSegue(withIdentifier: "pasajeros", sender: sender)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        var destino = ""
        if let vuelo = totalArray[(indexPath as NSIndexPath).row] as? Vuelos {
            
            global_var.j_vuelo_tripnumber = vuelo.tripnumber!
            global_var.j_vuelo_tailnumber = vuelo.tailnumber!
            global_var.j_vuelo_customername = vuelo.customername!
            global_var.j_vuelo_fecha = vuelo.fecha!
            global_var.j_vuelo_aeropuertosale = vuelo.aeropuertosale!
            global_var.j_vuelo_aeropuertollega = vuelo.aeropuertollega!
            global_var.j_vuelo_horasale = vuelo.horasale!
            global_var.j_vuelo_horallega = vuelo.horallega!
            global_var.j_vuelo_distancia = vuelo.distancia!
            global_var.j_vuelo_prevuelo = vuelo.prevuelo!
            //global_var.j_vuelo_legnumber = vuelo.legnumber! // Es Copiloto
            
            if vuelo.copiloto! != "" {
                global_var.j_vuelo_copiloto = vuelo.copiloto!
            }else{
                global_var.j_vuelo_copiloto = ""
            }
            
            global_var.j_vuelo_legid = vuelo.legid!
            coreDataStack.obtenerTotalPaxVuelo(legid: global_var.j_vuelo_legid)
            global_var.j_vuelo_horavuelo = vuelo.horavuelo!
            global_var.j_vuelo_horavuelodecimal = vuelo.horavuelodecimal!
            global_var.j_procedencia = 0
            coreDataStack.buscaMatricula(matricula: vuelo.tailnumber!)
            global_var.j_bitacora_abierta = 1
            global_var.j_bitacoras_Id = 0
            global_var.j_tramos_Id = 0
            global_var.j_instrumentos_Id = 0
            global_var.j_bitacora_modificada = 0
            global_var.j_bitacora_nummodificada = 0
            
            
            print(global_var.j_avion_tipomotor)
            print(global_var.j_avion_totalmotor)
            
            if (global_var.j_avion_tipomotor == "1")   {
                //JET
                destino = "jet_view"
                global_var.j_avion_pesofuel = 1
                global_var.j_avion_tipofuel = 1
                
            }else if(global_var.j_avion_tipomotor == "2"){
                //Piston
                
                if(global_var.j_avion_totalmotor == 1){
                    destino = "piston_mono"
                    global_var.j_avion_pesofuel = 1
                    global_var.j_avion_tipofuel = 0
                }else{
                    destino = "piston_bimotor"
                    global_var.j_avion_pesofuel = 1
                    global_var.j_avion_tipofuel = 0
                    
                }
            }else if(global_var.j_avion_tipomotor == "3"){
                //Turbo Propulsor
                destino = "turbo"
                global_var.j_avion_pesofuel = 1
                global_var.j_avion_tipofuel = 0
            }
            
            if(!coreDataStack.verificaSiHayBitacoraMatricula(matricula: vuelo.tailnumber!)){
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                var destViewController : UIViewController
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: destino)
                
                self.present(destViewController, animated: true, completion: nil)
            }
            else{
                Util.invokeAlertMethod(strTitle: "Alerta", strBody: "Ya tienes una bitácora abíerta para este avión. Cierra dicha bitácora y podras continuar", delegate: self)
            }
        }
     
     
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        var AbrirRowAction = UITableViewRowAction()
        var ReenviarRowAction = UITableViewRowAction()
        var deleteRowAction = UITableViewRowAction()
        var id : String = "0"
        var tailnumber : String = ""
       
        print((indexPath as NSIndexPath).row)
        if let row = totalArray[(indexPath as NSIndexPath).row] as? Vuelos {
            
            print(row.tailnumber ?? "ninguno")
            
            print(row.legid ?? "ningun idvuelo")
            
                AbrirRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Abrir", handler: { action, indexpath in
                    
                    var destino = ""
                    if let vuelo = self.totalArray[(indexPath as NSIndexPath).row] as? Vuelos {
                        
                        global_var.j_vuelo_tripnumber = vuelo.tripnumber!
                        global_var.j_vuelo_tailnumber = vuelo.tailnumber!
                        global_var.j_vuelo_customername = vuelo.customername!
                        global_var.j_vuelo_fecha = vuelo.fecha!
                        global_var.j_vuelo_aeropuertosale = vuelo.aeropuertosale!
                        global_var.j_vuelo_aeropuertollega = vuelo.aeropuertollega!
                        global_var.j_vuelo_horasale = vuelo.horasale!
                        global_var.j_vuelo_horallega = vuelo.horallega!
                        global_var.j_vuelo_distancia = vuelo.distancia!
                        global_var.j_vuelo_prevuelo = vuelo.prevuelo!
                        //global_var.j_vuelo_legnumber = vuelo.legnumber! // Es Copiloto
                        
                        if vuelo.legnumber! != "" {
                            global_var.j_vuelo_copiloto = vuelo.legnumber!
                        }else{
                            global_var.j_vuelo_copiloto = ""
                        }
                        
                        global_var.j_vuelo_legid = vuelo.legid!
                        self.coreDataStack.obtenerTotalPaxVuelo(legid: global_var.j_vuelo_legid)
                        global_var.j_vuelo_horavuelo = vuelo.horavuelo!
                        global_var.j_vuelo_horavuelodecimal = vuelo.horavuelodecimal!
                        global_var.j_procedencia = 0
                        self.coreDataStack.buscaMatricula(matricula: vuelo.tailnumber!)
                        global_var.j_bitacora_abierta = 1
                        global_var.j_bitacoras_Id = 0
                        global_var.j_tramos_Id = 0
                        global_var.j_instrumentos_Id = 0
                        global_var.j_bitacora_modificada = 0
                        global_var.j_bitacora_nummodificada = 0
                        
                        
                        print(global_var.j_avion_tipomotor)
                        print(global_var.j_avion_totalmotor)
                        
                        if (global_var.j_avion_tipomotor == "1")   {
                            //JET
                            destino = "jet_view"
                            global_var.j_avion_pesofuel = 1
                            global_var.j_avion_tipofuel = 1
                            
                        }else if(global_var.j_avion_tipomotor == "2"){
                            //Piston
                            
                            if(global_var.j_avion_totalmotor == 1){
                                destino = "piston_mono"
                                global_var.j_avion_pesofuel = 1
                                global_var.j_avion_tipofuel = 0
                            }else{
                                destino = "piston_bimotor"
                                global_var.j_avion_pesofuel = 1
                                global_var.j_avion_tipofuel = 0
                                
                            }
                        }else if(global_var.j_avion_tipomotor == "3"){
                            //Turbo Propulsor
                            destino = "turbo"
                            global_var.j_avion_pesofuel = 1
                            global_var.j_avion_tipofuel = 0
                        }
                        
                        if(!self.coreDataStack.verificaSiHayBitacoraMatricula(matricula: vuelo.tailnumber!)){
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                            var destViewController : UIViewController
                            destViewController = mainStoryboard.instantiateViewController(withIdentifier: destino)
                            
                            self.present(destViewController, animated: true, completion: nil)
                        }
                        else{
                            Util.invokeAlertMethod(strTitle: "Alerta", strBody: "Ya tienes una bitácora abíerta para este avión. Cierra dicha bitácora y podras continuar", delegate: self)
                        }
                    }
                });
                
                deleteRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Quitar", handler:{action, indexpath in
                    
                    
                    let alertController = UIAlertController(title: "", message: " ¿Deseas quitar el vuelo? ", preferredStyle: UIAlertController.Style.alert)
                    
                    let saveAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
                        
                        DispatchQueue.main.async() {
                            self.coreDataStack.quitarVuelos(legid: row.legid!)
                             Util.invokeAlertMethod(strTitle: "", strBody: "Se ha quitado correctamente", delegate: self)
                            self.cargarVuelos()
                        }
                        
                        
                    }
                    
                    let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(saveAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                });
                
        }
            AbrirRowAction.backgroundColor = UIColor.green
            deleteRowAction.backgroundColor = UIColor.red
            return [deleteRowAction,AbrirRowAction];
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with withEvent: UIEvent?) {
        super.touchesBegan(touches, with: withEvent)
        self.view.endEditing(true)
    }
    
    
    
    //MARK: - Datos
    
    func sincronizaVuelos(){
        
        if Conexion.isConnectedToNetwork() {
        
            //_ = SwiftSpinner.show("Sincronizando", animated: true)
            self.navigationItem.title = "Cargando..."
            let queue = TaskQueue()
            
            queue.tasks += { result, next in
               
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                print("start")
                let wsURL = parametros.j_host + "json.aspx?asp=verificar_vuelos_sincronizar&usuario=\(global_var.j_usuario_clave)"
                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                //stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let url = URL(string: url_temp!)
                print("URL: \(url!)")
                
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 7
                configuration.timeoutIntervalForResource = 10
                let session = URLSession(configuration: configuration)
                let dataTask = session.dataTask(with: url!, completionHandler: {(data, urlResponse, error) in
                    
                    if let response  = urlResponse as? HTTPURLResponse{
                        print(response.statusCode)
                            if response.statusCode == 200 {
                                if data != nil {
                                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary  {
                                        print(json!.count)
                                        if(json!.count > 0){
                                            self.dataSource =  json
                                            self.results = json!["Vuelos"] as! NSArray
                                            print(self.results.count)
                                            if (self.results.count > 0){
                                                if(self.coreDataStack.borrarVuelos()){
                                                    self.notificacion.removeNotifications()
                                                    next(nil)
                                                }
                                            }
                                            else{
                                                next(nil)
                                            }
                                        }
                                        else{
                                            next(nil)
                                        }
                                    }
                                }else{
                                    print(self.results.count)
                                    Util.invokeAlertMethod(strTitle: "Error", strBody: "HTTP", delegate: self)
                                    next(nil)
                                }
                            }else{
                                if(self.results.firstObject == nil){
                                    DispatchQueue.main.async(){
                                    Util.invokeAlertMethod(strTitle: "Error", strBody: "No se pudo sincronizar los vuelos, verifica tu conexión a internet.", delegate: self)
                                        next(nil)
                                    }
                                }
                        }
                    }else{
                        //NO hubo respuesta
                        next(nil)
                    }
                })
                
                dataTask.resume()
            }
            
            queue.tasks += { result, next in
                if(self.results.firstObject != nil){
                    if(self.results.count > 0){
                       
                        for x in 0 ..< self.results.count {
                            print(x)
                            if let row = self.results[x] as? NSDictionary {
                                if(self.coreDataStack.existeVuelo(legid: row["legid"] as! String) == false){
                                    self.formato.dateStyle = .short
                                    self.formato.dateFormat = "dd/MM/yyyy"
                                   
                                    if let fechavuelo = self.formato.date(from: row["fecha"] as! String) {
                                        self.coreDataStack.agregarVuelo(aeropuertollega: row["aptollega"] as! String, aeropuertosale: row["aptosale"] as! String, customername: row["cliente"] as! String, distancia: row["distancia"] as! String, fecha: fechavuelo as NSDate, horallega: row["horallega"] as! String, horasale: row["horasale"] as! String, horavuelo: row["horavuelo"] as! String, horavuelodecimal: row["horavuelodecimal"] as! String, legid: row["legid"] as! String, legnumber: row["copiloto"] as! String, sincronizado: 0, status: 0, tailnumber: row["matricula"] as! String, tripnumber: row["tripnumber"] as! String, prevuelo: row["prevuelo"] as! String, copiloto: row["copiloto"] as! String)
                                        
                                        
                                        let fullName: String = row["pasajeros"] as! String
                                        var totalpax = 0
                                        if  (!fullName.isEmpty) {
                                            self.coreDataStack.borrarPasajerosVuelo(legid: row["legid"] as! String)
                                            let fullNameArr : [String] = fullName.split(separator: "-")
                                            print("Total Nombres : \(fullNameArr.count)")
                                            totalpax = fullNameArr.count
                                            if fullNameArr.count > 1 {
                                                for palabra in fullNameArr {
                                                    self.coreDataStack.agregarVueloPasajero(legid: row["legid"] as! String,nombre: palabra)
                                                }
                                            }else{
                                                self.coreDataStack.agregarVueloPasajero(legid: row["legid"] as! String,nombre: row["pasajeros"] as! String)
                                            }
                                        }
                                        
                                        //Agregar Notificación Local
                                        
                                        let ruta = "Matricula: \(row["matricula"] as! String) *** Ruta: \(row["aptosale"] as! String) - \(row["aptollega"] as! String) *** Pax: \(totalpax) "
                                        let calendar = NSCalendar.current
                                        let year =  calendar.component(.year, from: fechavuelo)
                                        let month =  calendar.component(.month, from: fechavuelo)
                                        let day =  calendar.component(.day, from: fechavuelo)
                                        
                                        let formatohora : DateFormatter = DateFormatter()
                                        formatohora.dateStyle = .none
                                        formatohora.dateFormat = "HH:mm"
                                        
                                        var hora = 0
                                        var minutos = 0
                                        
                                        if let horaVuelo = formatohora.date(from: row["horasale"] as! String) {
                                            hora = calendar.component(.hour, from: horaVuelo)
                                            minutos = calendar.component(.minute, from: horaVuelo)
                                        }
                                        
                                        self.notificacion.NotificacionLocal(title: "¡Comienza tu vuelo!", body: ruta , hour: hora, minutos: minutos, dia: day, mes: month, año: year, legid: row["legid"] as! String)
                                        
                                    }
                                }
                                else{
                                    //Actualizar el vuelo
                                    
                                }
                            }else{
                                print("error")
                            }
                        }
                    }
                }else{
                    next(nil)
                }
               DispatchQueue.main.async() {
                    print("finished")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.navigationItem.titleView = nil;
                    self.navigationItem.title = "Vuelos"
                    self.cargarVuelos()
                    //SwiftSpinner.hide()
                    next(nil)
                }
            }
            
            queue.run()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pasajeros" {
            let DestViewController = segue.destination as! UINavigationController
            _ = DestViewController.topViewController as! TVC_InformacionVueloViewController
        }
    }
    
    
    
    
    @IBAction func btnUpdate(sender: AnyObject) {
        sincronizaVuelos()
    }

    @objc func cargarVuelos() {
        
        //let moc : NSManagedObjectContext = coreDataStack.managedObjectContext
        let fecha_actual = NSDate()
        totalArray.removeAll(keepingCapacity: false)

        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: true)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Vuelos")
        //request.predicate = NSPredicate(format: "status=%@ and fecha >=%@", argumentArray: [0, fecha_actual as NSDate])
        request.predicate = NSPredicate(format: "status=%@", argumentArray: [0])
        request.sortDescriptors = [sortDescriptor]
        //request.fetchBatchSize = 20
        
        do {
            totalArray = try! self.coreDataStack.managedObjectContext.fetch(request) as Array<AnyObject>
                self.tableView.reloadData()
        }
        
    }
    
    @objc func refreshInvoked() {
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        sincronizaVuelos()
        registarUDID()
        if (viaPullToRefresh) {
            self.refreshControl!.endRefreshing()
        }
    }
    
    func registarUDID(){
        
        if Conexion.isConnectedToNetwork() {
             DispatchQueue.main.async() {
                print(global_var.j_usuario_token)
                
                if global_var.j_usuario_token != "" {
                    
                    let wsURL = parametros.j_host + "json.aspx?asp=device_registrar_token&token=\(global_var.j_usuario_token)&usuario=\(global_var.j_usuario_clave)"
                    
                    let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    //stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    let url = URL(string: url_temp!)
                    print("URL: \(url!)")
                    
                    let configuracion = URLSessionConfiguration.default
                    configuracion.timeoutIntervalForRequest = 7
                    configuracion.timeoutIntervalForResource = 10
                    let session = URLSession(configuration: configuracion)
                    let dataTask =  session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse { }
                        
                    })
                    dataTask.resume()
                }
            }
        }
    }
    
}
