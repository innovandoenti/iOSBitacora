//
//  BitacorasViewController.swift


import UIKit
import CoreData

class BitacorasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, NSFetchedResultsControllerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, XMLParserDelegate {

    var customAllowedSet =  CharacterSet.init(charactersIn: "()'&+=\"#%/<>?@\\^`{|}").inverted
    var sincronizado = false
    var activityIndicator: UIActivityIndicatorView!
    var indicador : UIActivityIndicatorView!
    var dataSource : NSDictionary!
    var results : NSArray!
    var logosArray : NSMutableArray = NSMutableArray()
    var searchResultados : NSArray!
    var searchActive : Bool = false
    
    var existeUsuario : Bool = false
    var dictionary : NSDictionary!
    var datatable  : Array<AnyObject> = []
    var datatable_filtered : Array<AnyObject> = []
    var dt_bitacoras : NSMutableArray = NSMutableArray()
    var logica = Util()
    var coreDataStack = CoreDataStack()
    var formato : DateFormatter   = DateFormatter()
    var resultSearchController = UISearchController()
    private var searchController: UISearchController!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSincronizar: UIBarButtonItem!
    
    let effect = UIBlurEffect(style: .dark)
    let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    let refreshControl:UIRefreshControl = UIRefreshControl()
    let notifacion : NSNotification = NSNotification(name: NSNotification.Name(rawValue: "volver"), object:  nil)
    
    //Vars sincronización
    var wsUrl : String = "http://intranet.aerotron.com.mx/apps/wsBitacoras.asmx"
    var mutableData:NSMutableData = NSMutableData.init()
    var currentElementName:NSString = ""
    var lastElementName:NSString = ""
    var MatriculaServer: NSString = ""
    var ultimodestino: String = ""
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        let fecha = NSSortDescriptor(key: "fechavuelo", ascending: false)
        let matricula = NSSortDescriptor(key: "matricula", ascending: false)
        let numero = NSSortDescriptor(key: "numbitacora", ascending: false)
        fetchRequest.sortDescriptors = [fecha,matricula,numero]
        let fetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: self.coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configSearch()
        //loadbitacoras("",scope: 0)
        cargarBitacoras()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BitacorasViewController.loadbitacoras(_: searchtext:scope:)), name: "cargaBitacoras", object: nil)
        //SincrinizaVueloSoap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cargarBitacoras()
    }
    
    func configSearch(){
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Buscar bitácora"
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.scopeButtonTitles = ["Matrícula","Bitácora"]
        self.tableView.tableHeaderView = self.searchController.searchBar
        
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cargarBitacoras(){
        
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
    }
    
    
    @objc func loadbitacoras(searchtext: String, scope: Int) {
        
        print(searchtext.count)
        if searchtext.count > 0 {
            var filtro = NSPredicate()
            switch (scope){
            case 0:
                filtro = NSPredicate(format: "(matricula contains[c] %@)", argumentArray: [searchtext])
                break
            case 1:
                filtro = NSPredicate(format: "(numbitacora == %@)", argumentArray: [searchtext])
                break
            default:
                break
            }
            fetchedResultsController.fetchRequest.predicate = filtro
        }else{
            fetchedResultsController.fetchRequest.predicate = nil
        }
        
        self.cargarBitacoras()
        
        
    }
    
    //MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Bitacoras_TableViewCell
        
        let formatofecha : DateFormatter = DateFormatter()
        formatofecha.dateStyle = .short
        formatofecha.dateFormat="dd/MM/yyy"
        
        
        if let bitacora = fetchedResultsController.object(at: indexPath) as? Bitacoras {
            
            cell.Matricula.text = bitacora.matricula!  + " - " + ("\(bitacora.numbitacora!)")
            cell.Cliente.text = bitacora.cliente
            cell.Fecha.text = formatofecha.string(from: (bitacora.fechavuelo! as NSDate) as Date) //"\(bitacora.legid!)" //
            cell.Ruta.text = coreDataStack.obtenerTramo(idbitacora: bitacora.idbitacora!, matricula: bitacora.matricula!)
            
            if bitacora.status == 1 {
                cell.Status.image = UIImage(named: "lock_open_32.png")
            }
            else{
                
                cell.Status.image = UIImage(named: "lock_32.png")
                
            }
            
            if bitacora.sincronizado == 0 {
                cell.Sincronizado.image = UIImage(named: "no_sync.png")
            }else{
                cell.Sincronizado.image = UIImage(named: "synced_ok.png")
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        
        var altura : CGFloat = 0
        
        if DeviceType.IS_IPAD {
            altura = 132
        }else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            altura  =  90
        }else{
            altura = 90
        }
        
        return altura
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let row = fetchedResultsController.object(at: indexPath) as? Bitacoras {
            var destino = " "
            print(row.matricula ?? "no tail")
            global_var.j_procedencia = 0
            global_var.j_bitacora_abierta = row.status!
            global_var.j_bitacoras_Id = row.idbitacora!
            global_var.j_bitacora_num = row.numbitacora!
            global_var.j_bitacora_fecha = row.fechavuelo!
            global_var.j_bitacora_cliente = row.cliente!
            global_var.j_bitacora_matricula = row.matricula!
            global_var.j_bitacoras_ifr = row.ifr!
            global_var.j_bitacora_ciclos = row.ciclos!
            global_var.j_bitacora_totalaterrizajes = row.totalaterrizajes!
            global_var.j_bitacora_nombrecopiloto = row.copilotonombre!
            global_var.j_bitacora_licenciacopiloto = row.copiloto! //Licencia
            global_var.j_bitacora_prevuelo = row.quienprevuelo!
            global_var.j_bitacora_ultimo_ciclo = row.ciclos!
            global_var.j_bitacora_ultimo_aterrizaje = row.totalaterrizajes!
            
            global_var.j_vuelo_legid = row.legid!.stringValue
            
            if let capitannombre = row.capitannombre{
                global_var.j_bitacora_nombrepiloto = capitannombre
            }else {
                global_var.j_bitacora_nombrepiloto = global_var.j_usuario_nombre
            }
            
            if let capitanlicencia = row.capitanlicencia{
                global_var.j_bitacora_licenciapiloto = capitanlicencia
            }else {
                global_var.j_bitacora_licenciapiloto = ""
            }
            
            global_var.j_bitacora_idpiloto = row.capitan!
            
            if let prevuelolocal = row.prevuelolocal {
                global_var.j_bitacora_prevuelolocal = prevuelolocal
            }else{
                global_var.j_bitacora_prevuelolocal = 0
            }
            
            
            if let modificada = row.modificada {
                global_var.j_bitacora_modificada = modificada
            }else{
                global_var.j_bitacora_modificada = 0
            }
            if let modificadatotal = row.modificadatotal {
                global_var.j_bitacora_nummodificada = modificadatotal
            }else{
                global_var.j_bitacora_nummodificada = 0
            }
            
            coreDataStack.buscaMatricula(matricula: row.matricula!)
            
            if (global_var.j_avion_tipomotor == "1")   {
                //JET
                destino="jet_view"
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
                if(global_var.j_avion_totalmotor == 2){
                    destino = "turbo_bimotor"
                }
                
            }
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            var destViewController : UIViewController
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: destino)
            destViewController.modalPresentationStyle = .fullScreen
            self.present(destViewController, animated: true, completion: nil)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        
        var AbrirRowAction = UITableViewRowAction()
        var ReenviarRowAction = UITableViewRowAction()
        var deleteRowAction = UITableViewRowAction()
        var id : NSNumber = 0
        var tailnumber : String = ""
        
        print(datatable.count)
        print((indexPath as NSIndexPath).row)
        if let row = fetchedResultsController.object(at: indexPath) as? Bitacoras {
        
            print(row.matricula ?? "ninguno")
        
            print(row.idbitacora ?? "ningun idbitácora")
            
            if row.matricula == nil{
                //self.loadbitacoras("",scope: 0)
                
                
            }else{
            
            tailnumber = row.matricula!
            id = row.idbitacora!
                
             AbrirRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Abrir", handler: { action, indexpath in
                
                var destino = " "
                
                DispatchQueue.main.async() {
                    if (self.coreDataStack.BitacoraStatus(idbitacora: row.idbitacora!, matricula: row.matricula!) != 1){
                        
                        //Verifica si la bitácora se esta sincronizando
                        if(self.coreDataStack.verificaSiHayBitacoraMatriculaSincronizando(matricula: row.matricula!)){
                            Util.invokeAlertMethod(strTitle: "Aviso", strBody: "No se puede abrir esta bitácora, esta en proceso de sincronización", delegate: self)
                            
                            self.loadbitacoras(searchtext: "",scope: 0)
                            
                        }else{
                            
                            //Se reactiva y se libera para que se pueda volver a sincronizar
                            var totalmodificaciones : NSNumber = 0
                            if let total = row.modificadatotal {
                                totalmodificaciones = NSNumber(value: total.intValue + 1)
                            }
                            else{
                                totalmodificaciones = 1
                            }
                            
                            let modificacion : NSNumber = 1
                            self.coreDataStack.abrirBitacora(idbitacora: row.idbitacora!, matricula: row.matricula!, modificada: modificacion, modificadatotal: totalmodificaciones)
                            
                            global_var.j_procedencia = 0
                            global_var.j_bitacora_abierta = row.status!
                            global_var.j_bitacoras_Id = row.idbitacora!
                            global_var.j_bitacora_num = row.numbitacora!
                            global_var.j_bitacora_fecha = row.fechavuelo!
                            global_var.j_bitacora_cliente = row.cliente!
                            global_var.j_bitacora_matricula = row.matricula!
                            global_var.j_bitacoras_ifr = row.ifr!
                            global_var.j_bitacora_modificada = 1
                            global_var.j_bitacora_nummodificada = totalmodificaciones
                            global_var.j_bitacora_abierta = 1
                            global_var.j_bitacora_nombrecopiloto = row.copilotonombre!
                            global_var.j_bitacora_licenciacopiloto = row.copiloto! //Licencia
                            
                            if let capitannombre = row.capitannombre{
                                global_var.j_bitacora_nombrepiloto = capitannombre
                            }else {
                                global_var.j_bitacora_nombrepiloto = global_var.j_usuario_nombre
                            }
                            
                            if let capitanlicencia = row.capitanlicencia{
                                global_var.j_bitacora_licenciapiloto = capitanlicencia
                            }else {
                                global_var.j_bitacora_licenciapiloto = ""
                            }
                            
                            global_var.j_bitacora_idpiloto = row.capitan!
                            
                            
                            self.coreDataStack.buscaMatricula(matricula: row.matricula!)
                            
                            if (global_var.j_avion_tipomotor == "1")   {
                                //JET
                                destino="jet_view"
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
                        }
                    }
                    DispatchQueue.main.async() {
                        // update some UI
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                        var destViewController : UIViewController
                        destViewController = mainStoryboard.instantiateViewController(withIdentifier: destino)
                        destViewController.modalPresentationStyle = .fullScreen
                        self.present(destViewController, animated: true, completion: nil)
                    }
                }
                
                
            });
            
            
            ReenviarRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Enviar Correo", handler:{action, indexpath in
                
                
                
                if(Conexion.isConnectedToNetwork()){
                    
                    _ = SwiftSpinner.show("Solicitando bitácora", animated: true)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    var alerta  : UIAlertController!
                    let aceptar : UIAlertAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    
                    DispatchQueue.main.async() {
                        
                        if(self.coreDataStack.BitacoraStatus(idbitacora: row.idbitacora!, matricula: row.matricula!) == 2){
                            
                            
                            
                            let wsURL = parametros.host + "/json?asp=bitacora_sincronizada_reenviarcorreo&idbitacora=\(row.idservidor!)"
                            let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            //stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                            let url = URL(string: url_temp!)
                            print("URL: \(url!)")
                            
                            let configuration = URLSessionConfiguration.default
                            let session = URLSession(configuration: configuration)
                            let dataTask = session.dataTask(with: url!, completionHandler: {(data, urlResponse, error) in
                                
                                if let response  = urlResponse as? HTTPURLResponse{
                                    print(response.statusCode)
                                    if response.statusCode == 200 {
                                        if data != nil {
                                            if let json = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??)  {
                                                print(json!.count)
                                                if(json!.count > 0){
                                                    alerta = UIAlertController(title: "", message: "Se ha enviado correctamente", preferredStyle: .alert)
                                                    DispatchQueue.main.async() {
                                                        // update some UI
                                                        SwiftSpinner.hide({
                                                            print(alerta)
                                                            alerta.addAction(aceptar)
                                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                            self.present(alerta, animated: true, completion: nil)
                                                            self.loadbitacoras(searchtext: "",scope: 0)
                                                        })
                                                    }
                                                    
                                                }
                                                else{
                                                    alerta = UIAlertController(title: "", message: "No se ha enviado, consulta a sistemas.", preferredStyle: .alert)
                                                }
                                            }
                                        }else{
                                            print(self.results.count)
                                            SwiftSpinner.hide()
                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "HTTP", delegate: self)
                                            
                                        }
                                    }else{
                                        if(self.results.firstObject == nil){
                                            DispatchQueue.main.async(){
                                                SwiftSpinner.hide()
                                                Util.invokeAlertMethod(strTitle:  "Error", strBody: "No se pudo generar la petición.", delegate: self)
                                                
                                            }
                                        }else{
                                            DispatchQueue.main.async(){
                                                SwiftSpinner.hide()
                                                Util.invokeAlertMethod(strTitle: "Error", strBody: "No se pudo generar la petición.", delegate: self)
                                                
                                            }
                                        }
                                    }
                                }else{
                                    DispatchQueue.main.async(){
                                        SwiftSpinner.hide()
                                        Util.invokeAlertMethod(strTitle: "Error", strBody: "No se pudo generar la petición.", delegate: self)
                                        
                                    }
                                }
                            })
                            
                            dataTask.resume()
                            
                            
                        }else{
                            
                            DispatchQueue.main.async() {
                                // update some UI
                                SwiftSpinner.hide({
                                    Util.invokeAlertMethod(strTitle: "Verifica", strBody: "Es necesario cerrar la bitacora para esta solicitud", delegate: self)
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.loadbitacoras(searchtext: "",scope: 0)
                                })
                            }
                            
                            
                            
                        }
                        
                    }
                }
                else{
                    Util.invokeAlertMethod(strTitle: "Verifica", strBody: "Requieres de conexión al servidor para esta solicitud", delegate: self)
                }
                print("Reenviar Bitácora")
                
            });
            
            deleteRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Quitar", handler:{action, indexpath in
                
                
                let alertController = UIAlertController(title: "", message: " ¿Deseas quitar la bitácora? ", preferredStyle: UIAlertController.Style.alert)
                
                let saveAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
                   
                    DispatchQueue.main.async() {
                       
                        let idbitacora = row.idbitacora
                        _ = row.matricula!
                        
                        self.coreDataStack.quitarTramos(idbitacora: idbitacora!)
                        self.coreDataStack.quitarInstrumentos(idbitacora: idbitacora!)
                        self.coreDataStack.quitarPasajeros(idbitacora: idbitacora!)
                        self.coreDataStack.quitarBitacora(idbitacora: idbitacora!)
                        
                        DispatchQueue.main.async() {
                            Util.invokeAlertMethod(strTitle: "", strBody: "Se ha quitado correctamente", delegate: self)
                            self.loadbitacoras(searchtext: "",scope: 0)
                            print("Quitar la bitacora")
                        }
                    }
                    
                    
                }
                
                let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
                
                alertController.addAction(cancelAction)
                alertController.addAction(saveAction)
                self.present(alertController, animated: true, completion: nil)
                
            });
            
            }
            AbrirRowAction.backgroundColor = UIColor.gray
            ReenviarRowAction.backgroundColor = UIColor.green
            deleteRowAction.backgroundColor = UIColor.red
           
        }
        
        if self.coreDataStack.BitacoraStatus(idbitacora: id, matricula: tailnumber) != 1 {
            return [deleteRowAction,ReenviarRowAction,AbrirRowAction];
        }else{
            return [deleteRowAction];
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
         return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
   
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with withEvent: UIEvent?) {
       super.touchesBegan(touches, with: withEvent)
        self.view.endEditing(true)
    }
    
    
    
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            break;
        case .update:
            if indexPath != nil {
                //let cell = tableView.cellForRowAtIndexPath(indexPath) as! Bitacoras_TableViewCell
                self.cargarBitacoras()
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .fade)
            }
            break;
        }
    }


    //MARK: - Busquedas
    
    
    // Called when the search bar's text or scope has changed or when the search bar becomes first responder.
    func updateSearchResults(for searchController: UISearchController) {
        
       /* // get typed string from the search bar
        let searchText = searchController.searchBar.text
        let scope = searchController.searchBar.selectedScopeButtonIndex
        print("searchText - \(searchText!)")
        print("scope - \(scope)")
        //filterContents(searchText, scope: scope)
        if searchText!.count > 0 {
            //searchController.searchBar.text = searchText!.uppercaseString*/
        
        
        //}
        
       // loadbitacoras(searchText!,scope: scope)
            loadbitacoras(searchtext: searchController.searchBar.text!,scope: searchController.searchBar.selectedScopeButtonIndex)
        
    }
    
    // Called when the user clicks on the cancel button of the search bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // normally, you should reset here the filter results based on the app logic
        searchActive = false;
        loadbitacoras(searchtext: "",scope: 0)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.updateSearchResults(for: self.searchController)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchText.isEmpty {
            searchActive = false
        }
        else{
            searchActive = true
        }
    }
    
    func filtrarContenido(searchText: String) {
        // Filter the array using the filter method
        //let filtro = NSPredicate(format: "Matricula contains[c] %@", searchText)
        print("Item en resultado \(self.searchResultados.count)")
        
    }
    
    //MARK: - Funciones Locales
    func sincronizacion() {

        //let queue = OperationQueue()
        //_ = SwiftSpinner.show("Sincronizando Bitácora", animated: true)
        self.navigationItem.title = "Sincronizando..."
        //let primero : BlockOperation = BlockOperation {
            
            if Conexion.isConnectedToNetwork() {
                
                global_var.j_statusSincronizacion = 0
                
                var totalArray : Array<AnyObject> = []
                
                totalArray.removeAll(keepingCapacity: false)
                
                let sortDescriptor = NSSortDescriptor(key: "idbitacora", ascending: true)
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
                request.predicate = NSPredicate(format: "sincronizado=%@ AND status=%@", argumentArray: [0,2])
                request.sortDescriptors = [sortDescriptor]
                
                do{
                    let fetchResults = try self.coreDataStack.managedObjectContext.fetch(request) as? [Bitacoras]
                    
                    if let bitacora = fetchResults{
                        
                        if bitacora.count > 0 {
                                
                            for tramo in bitacora{
                                global_var.j_existe_bitacora_por_sincronizar = true
                                if global_var.j_statusSincronizacion == 0 {
                                    if(Conexion.isConnectedToNetwork()){
                                        
                                        global_var.j_bitacoras_idservidor = 0
                                        
                                        var manto_interno = ""
                                        var manto_dgac = ""
                                        var motivo = ""
                                        var nombrecopiloto = ""
                                        var licenciacopiloto = ""
                                        var prevuelo = ""
                                        var legid : NSNumber = 0
                                        var prevuelolocal : NSNumber = 0
                                        var usuario = global_var.j_usuario_clave
                                        
                                        if tramo.mantenimientointerno != nil {
                                            manto_interno = tramo.mantenimientointerno!
                                        }
                                        
                                        if tramo.mantenimientodgac != nil {
                                            manto_dgac = tramo.mantenimientodgac!
                                        }
                                        
                                        if tramo.accioncorrectiva != nil {
                                            motivo = tramo.accioncorrectiva!
                                        }
                                        
                                        if tramo.copilotonombre != nil {
                                            nombrecopiloto = tramo.copilotonombre!
                                        }
                                        
                                        if tramo.copiloto != nil {
                                            licenciacopiloto = tramo.copiloto!
                                        }
                                        
                                        if tramo.quienprevuelo != nil {
                                            prevuelo = tramo.quienprevuelo!
                                        }
                                        
                                        if tramo.legid != nil {
                                            legid = tramo.legid!
                                        }
                                        
                                        if tramo.prevuelolocal != nil {
                                            prevuelolocal = tramo.prevuelolocal!
                                        }
                                        
                                        if tramo.usuario != nil {
                                            usuario = tramo.usuario!
                                        }
                                        
                                        self.coreDataStack.actualizaBitacoraSincronizando(idbitacora: tramo.idbitacora!, matricula: tramo.matricula!)
                                        
                                        print("piloto actualizar")
                                        print(tramo.numbitacora!)
                                        
                                        self.sincronizarVuelo(matricula: tramo.matricula!, numbitacora: tramo.numbitacora!, fechavuelo: tramo.fechavuelo!, capitan: tramo.capitan!, capitannombre: tramo.capitannombre!, cliente: tramo.cliente!, mantenimientointerno: manto_interno, manteniminentodgac: manto_dgac, nombretecnico: tramo.nombretecnico!, idbitacora: tramo.idbitacora!, ifr: tramo.ifr!,modificada: tramo.modificada!, modificadatotal:  tramo.modificadatotal!, aterrizajes: tramo.totalaterrizajes!, ciclos: tramo.ciclos!, hoy: tramo.hoy!, motivo: motivo, horometrollega: tramo.horometrollegada!, horometroapu: tramo.horometroapu!, nombrecopiloto: nombrecopiloto, licenciacopiloto: licenciacopiloto, prevuelo: prevuelo, prevuelolocal: prevuelolocal, legid: legid, usuario: usuario)
                                        
                                     /*   self.sincronizarBitacora(matricula: tramo.matricula!, numbitacora: tramo.numbitacora!, fechavuelo: tramo.fechavuelo!, capitan: tramo.capitan!, capitannombre: tramo.capitannombre!, cliente: tramo.cliente!, mantenimientointerno: manto_interno, manteniminentodgac: manto_dgac, nombretecnico: tramo.nombretecnico!, idbitacora: tramo.idbitacora!, ifr: tramo.ifr!,modificada: tramo.modificada!, modificadatotal:  tramo.modificadatotal!, aterrizajes: tramo.totalaterrizajes!, ciclos: tramo.ciclos!, hoy: tramo.hoy!, motivo: motivo, horometrollega: tramo.horometrollegada!, horometroapu: tramo.horometroapu!, nombrecopiloto: nombrecopiloto, licenciacopiloto: licenciacopiloto, prevuelo: prevuelo, prevuelolocal: prevuelolocal, legid: legid, usuario: usuario) */
                                    }
                                }
                            }
                        }else{
                            self.navigationItem.title = "Bitácoras"
                            
                            //DispatchQueue.main.async() {
                                global_var.j_existe_bitacora_por_sincronizar = false
                                self.coreDataStack.regresarBitacorasSincronizar()
                                self.cargarBitacoras()
                                let destino = "tabBarcontroller"
                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                                let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
                                destviewcontroller.selectedIndex = 1
                            destviewcontroller.modalPresentationStyle = .fullScreen
                                self.present(destviewcontroller, animated: true, completion: nil)
                                
                            //}
                        }
                    }
                }
                catch let error as NSError{
                    Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
                }
            }else{
                 self.navigationItem.title = "Bitácoras"
            }
        //}
        
        //queue.addOperation(primero)
        
    }
    
    
    @IBAction func sincronizar(_sender: AnyObject) {
      
        self.sincronizacion()
        
    }
    
    func sincronizarBitacoras(_: NSNotification) {
        
        self.sincronizacion()
    }
    
    func BitacorasPorSincronizar(){
        
    }
    
    //MARK: Sincronizacion
    
    func sincronizarVuelo(matricula: String, numbitacora: NSNumber, fechavuelo: NSDate, capitan: String, capitannombre: String, cliente: String, mantenimientointerno: String, manteniminentodgac: String, nombretecnico:String, idbitacora: NSNumber, ifr: NSNumber, modificada: NSNumber, modificadatotal: NSNumber, aterrizajes: NSNumber, ciclos: NSNumber, hoy: NSNumber, motivo : String, horometrollega: NSNumber, horometroapu: NSNumber, nombrecopiloto: String, licenciacopiloto: String, prevuelo: String, prevuelolocal: NSNumber, legid: NSNumber, usuario: String) {
        
        
        var _ultimodestino : String = ""
        
        let formatofecha : DateFormatter = DateFormatter()
        formatofecha.dateFormat = "dd/MM/yyyy"
        let formatonumber : NumberFormatter = NumberFormatter()
        formatonumber.decimalSeparator = "."
        formatonumber.maximumFractionDigits = 2
        
        if(Conexion.isConnectedToNetwork()){
            
            global_var.j_statusSincronizacion = 1
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            coreDataStack.buscaMatricula(matricula: matricula)
            
            let queue = TaskQueue()
            
            queue.tasks += { result, next in
               
                let wsURL = parametros.host + "/json?asp=bitacora_agregar&matricula=\(matricula)&numbitacora=\(numbitacora)&fechavuelo=\(formatofecha.string(from: fechavuelo as Date))&capitanid=\(capitan)&capitannombre=\(capitannombre)&cliente=\(cliente.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&mantenimientointerno=\(mantenimientointerno.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&mantenimientodgac=\(manteniminentodgac.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&nombretecnico=\(nombretecnico)&iddispositivo=\(idbitacora)&ifr=\(formatonumber.string(from: ifr)!)&modificacion=\(modificada)&nummodificacion=\(modificadatotal)&aterrizajes=\(aterrizajes)&ciclos=\(ciclos)&hoy=\(hoy)&motivo=\(motivo)&nombrecopiloto=\(nombrecopiloto)&licenciacopiloto=\(licenciacopiloto)&prevuelolocal=\(prevuelolocal)&prevuelo=\(prevuelo.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&legid=\(legid)&usuario=\(usuario)"
                
                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                //stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let url = URL(string: url_temp!)
                print("URL: \(url!)")
                
                let configuracion = URLSessionConfiguration.default
                let session = URLSession(configuration: configuracion)
                let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                    if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                        print(httpResponde.statusCode)
                        if httpResponde.statusCode == 200 {
                            if data != nil {
                                if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                    if json!.count > 0 {
                                        self.dataSource =  json
                                        self.results = self.dataSource["Bitacora"] as! NSArray
                                        print(self.results.count)
                                        if (self.results.count > 0){
                                            let item = self.results[0] as! NSDictionary
                                            print("IFR: \(item["iddispositivo"] as! String)")
                                            global_var.j_bitacoras_idservidor = formatonumber.number(from: item["idservidor"] as! String)!
                                            //Int((item["idservidor"] as! String))!
                                            
                                            
                                            if(global_var.j_bitacoras_idservidor == 0){
                                                self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: (url?.absoluteString)!, error: true)
                                            }
                                            self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: (url?.absoluteString)!, error: false)
                                            next(nil)
                                        }
                                    }else{
                                        
                                        next(nil)
                                    }
                                }
                                else{
                                    if let unwrappedError = jsonError {
                                        Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                        next(nil)
                                    }
                                }
                            }
                        }
                        else{
                            self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: (url?.absoluteString)!, error: true)
                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                            next(nil)
                        }
                    }else{
                        self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: "No contesto el webservice", error: true)
                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                        next(nil)
                    }
                })
                dataTask.resume()
                
            }
            queue.tasks += { result, next in
                
                //Tarea para inserta el tramo
                
                print("Agregar Tramos")
                
                if (global_var.j_bitacoras_idservidor != 0){
                var totalTramos : Array<AnyObject> = []
                totalTramos.removeAll(keepingCapacity: false)
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
                request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasLegs]
               
                if let bitacora = fetchResults{
                    for tramo in bitacora{
                        
                        _ultimodestino = tramo.destino!
                        
                        let wsURL = parametros.host + "/json?asp=bitacora_agregar_tramo&idintercambio=0&idbitacora=\(global_var.j_bitacoras_idservidor)&fechasalida=\(formatofecha.string(from: fechavuelo as Date))&horasalida=\(tramo.horasalida!)&aeropuertosalida=\(tramo.origen!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&fechallegada=\(formatofecha.string(from: fechavuelo as Date))&horallegada=\(tramo.horallegada!)&aeropuertollegada=\(tramo.destino!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&calzoacalzo=\(tramo.calzoacalzo!)&tiempovuelo=\(tramo.tv!)&horas=0&minutos=0&calzos=\(tramo.calzoacalzo!)&capitan=\(global_var.j_usuario_idPiloto)&copiloto=1&folio_s=0&tipovuelo=1&ferry=false&raite=false&pax=0&socio=0&numbitacora=\(numbitacora)&matricula=\(matricula)&hsalida=\(tramo.horometrodespegue!)&hllegada=\(tramo.horometroaterrizaje!)&fuellitros=\(tramo.combustibledespegue!)&fuelprecio=0&aceitecargado=\(tramo.aceitecargado!)&aceitecargadoapu=0&capitanaltimetrorvsm=\(tramo.capitan_altimetrorvsm!)&combustibleaterrizaje=\(tramo.combustibleaterrizaje!)&combustiblecargado=\(tramo.combustiblecargado!)&combustibleconsumido=\(tramo.combustibleconsumido!)&combustibledespegue=\(tramo.combustibledespegue!)&coordenadasregistro=0&nivelvuelo=\(tramo.nivelvuelo!)&oat=\(tramo.oat!)&pesoaterrizaje=\(tramo.pesoaterrizaje!)&pesocarga=\(tramo.pesocarga!)&pesocombustible=\(tramo.pesocombustible!)&pesodespegue=\(tramo.pesodespegue!)&pesooperacion=\(tramo.pesooperacion!)&primeroficialaltimetrorvsm=\(tramo.primeroficialaltimetrorvsm!)&combustibleunidadmedida=\(tramo.combustibleunidadmedida!)&combustibleunidadpeso=\(tramo.combustibleunidadpeso!)"
                        
                         let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        let url = URL(string: url_temp!)
                        print("URL: \(url!)")
                        let configuracion = URLSessionConfiguration.default
                        let session = URLSession(configuration: configuracion)
                        let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                            if urlResponse != nil {
                                if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse{
                                    print(httpResponde.statusCode)
                                    if httpResponde.statusCode == 200 {
                                        if data != nil {
                                            if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                if json!.count > 0 {
                                                    self.dataSource =  json
                                                    self.results = self.dataSource["Tramo"] as! NSArray
                                                    if (self.results.count > 0){
                                                        let item = self.results[0] as! NSDictionary
                                                        let eliminado = item["insertado"] as! String
                                                        let idServidorTramo = item["idservidor"] as! String
                                                        if(Int(eliminado) != 0){
                                                            self.coreDataStack.actualizaTramoSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorTramo)!)
                                                            next(nil)
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                if let unwrappedError = jsonError {
                                                    Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        next(nil)
                                    }
                                }else{
                                    self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                    next(nil)
                                }
                            }else{
                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                next(nil)
                            }
                        })
                        
                        dataTask.resume()
                    }
                    }
                }
                else{
                    next(nil)
                }
                
            }
            
            queue.tasks += { result, next in
                
                
                if (global_var.j_bitacoras_idservidor != 0) {
                
                //Tarea para inserta los instrumentos
                print("Agregar Instrumentos")
                
                print(global_var.j_avion_tipomotor)
                
                print(global_var.j_avion_totalmotor)
                
                if (global_var.j_avion_tipomotor == "1")   {
                    //JET
                    print("jet")
                    
                    var totalpiston_mono : Array<AnyObject> = []
                    
                    totalpiston_mono.removeAll(keepingCapacity: false)
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
                    request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                    
                    let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasInstrumentos]
                    
                    if(fetchResults!.count > 0){
                        if let bitacora = fetchResults{
                            for tramo in bitacora{
                                let wsURL = parametros.host + "/json?asp=bitacora_agregar_instrumentos_jet&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&matricula=\(tramo.matricula!)&jet_amp=\(tramo.jet_amp!)&jet_amp_motor2=\(tramo.jet_amp_motor2!)&jet_apu_ciclos=\(tramo.jet_apu_ciclos!)&jet_apu_serie=\(tramo.jet_apu_serie!)&jet_apu_tt=\(tramo.jet_apu_tt!)&jet_apu_turm=\(tramo.jet_apu_turm!)&jet_avion_ciclos=\(tramo.jet_avion_ciclos!)&jet_avion_serie=\(tramo.jet_avion_serie!)&jet_avion_tt=\(tramo.jet_avion_tt!)&jet_avion_turm=\(tramo.jet_avion_turm!)&jet_dcac=\(tramo.jet_dcac!)&jet_dcac_motor2=\(tramo.jet_dcac_motor2!)&jet_fflow=\(tramo.jet_fflow!)&jet_fflow_motor2=\(tramo.jet_fflow_motor2!)&jet_fueltemp=\(tramo.jet_fueltemp!)&jet_fueltemp_motor2=\(tramo.jet_fueltemp_motor2!)&jet_hydvol=\(tramo.jet_hydvol!)&jet_hydvol_motor2=\(tramo.jet_hydvol_motor2!)&jet_ias=\(tramo.jet_ias!)&jet_itt=\(tramo.jet_itt!)&jet_itt_motor2=\(tramo.jet_itt_motor2!)&jet_lecturaaltimetro_capitan=\(tramo.jet_lecturaaltimetro_capitan!)&jet_lecturaaltimetro_primeroficial=\(tramo.jet_lecturaaltimetro_primeroficial!)&jet_motor1_ciclos=\(tramo.jet_motor1_ciclos!)&jet_motor1_serie=\(tramo.jet_motor1_serie!)&jet_motor1_tt=\(tramo.jet_motor1_tt!)&jet_motor1_turm=\(tramo.jet_motor1_turm!)&jet_motor2_ciclos=\(tramo.jet_motor2_ciclos!)&jet_motor2_serie=\(tramo.jet_motor2_serie!)&jet_motor2_tt=\(tramo.jet_motor2_tt!)&jet_motor2_turm=\(tramo.jet_motor2_turm!)&jet_n1=\(tramo.jet_n1!)&jet_n1_motor2=\(tramo.jet_n1_motor2!)&jet_n2=\(tramo.jet_n2!)&jet_n2_motor2=\(tramo.jet_n2_motor2!)&jet_oat=\(tramo.jet_oat!)&jet_oilpress=\(tramo.jet_oilpress!)&jet_oilpress_motor2=\(tramo.jet_oilpress_motor2!)&jet_oiltemp=\(tramo.jet_oiltemp!)&jet_oiltemp_motor2=\(tramo.jet_oiltemp_motor2!)&jet_dc=\(tramo.jet_dc!)"
                                
                                
                                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                let url = URL(string: url_temp!)
                                print("URL: \(url!)")
                                let configuracion = URLSessionConfiguration.default
                                let session = URLSession(configuration: configuracion)
                                let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                                    if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                        print(httpResponde.statusCode)
                                        if httpResponde.statusCode == 200 {
                                            if data != nil {
                                                if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                    if json!.count > 0 {
                                                        self.dataSource =  json
                                                        self.results = self.dataSource["Lectura"] as! NSArray
                                                        
                                                        print(self.results.count)
                                                        
                                                        if (self.results.count > 0){
                                                            
                                                            let item = self.results[0] as! NSDictionary
                                                            
                                                            let insertado = item["insertado"] as! String
                                                            let idServidorInstrumento = item["idservidor"] as! String
                                                            
                                                            if(Int(insertado) != 0){
                                                                
                                                                self.coreDataStack.actualizarInstrumentosSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorInstrumento)!)
                                                                
                                                                next(nil)
                                                            }
                                                        }
                                                    } //Fin JSON Count
                                                } // Fin JSON
                                            } // Fin data
                                        } // Fin Status Code
                                    }else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                        next(nil)
                                    }
                                    
                                })
                                
                                dataTask.resume()
                            }
                        }
                    }
                    else{
                        next(nil)
                    }
                }else if(global_var.j_avion_tipomotor == "2"){
                    //Piston
                    
                    if(global_var.j_avion_totalmotor == 1){
                        var totalpiston_mono : Array<AnyObject> = []
                        totalpiston_mono.removeAll(keepingCapacity: false)
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
                        request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                        let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasInstrumentos]
                        print("Total Instrumentos Encontrados: \(String(describing: fetchResults?.count))")
                        if((fetchResults?.count)! > 0){
                            
                            if let bitacora = fetchResults{
                                
                                for tramo in bitacora{
                                    
                                    let wsURL = parametros.host + "/json?asp=bitacora_agregar_instrumentos_piston_mono&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&matricula=\(tramo.matricula!)&ampers=\(tramo.piston_ampers!)&cht=\(tramo.piston_cht!)&crucero=\(tramo.piston_crucero!)&egt=\(tramo.piston_egt!)&flow=\(tramo.piston_flow!)&fuelpress=\(tramo.piston_fuelpress!)&manpress=\(tramo.piston_manpress!)&oilpress=\(tramo.piston_oilpress!)&rpm=\(tramo.piston_rpm!)&temp=\(tramo.piston_temp!)&volts=\(tramo.piston_volts!)&oat=\(tramo.piston_oat!)&aceite_mas=\(tramo.piston_aceite_mas!)"
                                    
                                    
                                    let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                    let url = URL(string: url_temp!)
                                    print("URL: \(url!)")
                                    let configuracion = URLSessionConfiguration.default
                                    let session = URLSession(configuration: configuracion)
                                    let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                                        if urlResponse != nil {
                                            if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                                if httpResponde.statusCode == 200 {
                                                    if data != nil {
                                                        if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                            if json!.count > 0 {
                                                                self.dataSource =  json
                                                                self.results = self.dataSource["Lectura"] as! NSArray
                                                                print(self.results.count)
                                                                if (self.results.count > 0){
                                                                    let item = self.results[0] as! NSDictionary
                                                                    let insertado = item["insertado"] as! String
                                                                    let idServidorInstrumento = item["idservidor"] as! String
                                                                    if(Int(insertado) != 0){
                                                                        self.coreDataStack.actualizarInstrumentosSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorInstrumento)!)
                                                                        next(nil)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        else{
                                                            if let unwrappedError = jsonError {
                                                                Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                    next(nil)
                                                }
                                            }else{
                                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                               UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                next(nil)
                                            }
                                        }else{
                                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                           UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                            next(nil)
                                        }
                                    })
                                    dataTask.resume()
                                }
                            }
                        }
                        else{
                            next(nil)
                        }
                        
                    }else{
                        
                    }
                }else if(global_var.j_avion_tipomotor == "3"){
                    //Turbo Propulsor
                    var totalpiston_mono : Array<AnyObject> = []
                    totalpiston_mono.removeAll(keepingCapacity: false)
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
                    request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                    let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasInstrumentos]
                    
                    if((fetchResults?.count)! > 0){
                        
                        if let bitacora = fetchResults{
                            
                            for tramo in bitacora{
                                
                                let wsURL = parametros.host + "/json?asp=bitacora_agregar_instrumentos_turbo&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&matricula=\(tramo.matricula!)&turbo_fflow=\(tramo.turbo_fflow!)&turbo_rpmhelice=\(tramo.turbo_helicerpm!)&turbo_ias=\(tramo.turbo_ias!)&turbo_itt=\(tramo.turbo_itt!)&turbo_ng=\(tramo.turbo_ng!)&turbo_nivelvuelo=0&turbo_oat=\(tramo.turbo_oat!)&turbo_oilpress=\(tramo.turbo_oilpress!)&turbo_oiltemp=\(tramo.turbo_oiltemp!)&turbo_torque=\(tramo.turbo_torque!)&turbo_vi=\(tramo.turbo_vi!)&turbo_vv=\(tramo.turbo_vv!)&turbo_dcac=\(tramo.turbo_dcac!)&turbo_amp=\(tramo.turbo_amp!)&turbo_avion_serie=\(tramo.turbo_avion_serie!)&turbo_avion_ciclos=\(tramo.turbo_avion_ciclos!)&turbo_avion_turm=\(tramo.turbo_avion_turm!)&turbo_avion_tt=\(tramo.turbo_avion_tt!)&turbo_motor_serie=\(tramo.turbo_motor_serie!)&turbo_motor_ciclos=\(tramo.turbo_motor_ciclos!)&turbo_motor_turm=\(tramo.turbo_motor_turm!)&turbo_motor_tt=\(tramo.turbo_motor_tt!)&turbo_helice_serie=\(tramo.turbo_helice_serie!)&turbo_helice_ciclos=\(tramo.turbo_helice_ciclos!)&turbo_helice_turm=\(tramo.turbo_helice_turm!)&turbo_helice_tt=\(tramo.turbo_helice_tt!)&&turbo_fflow_motor2=\(tramo.turbo_fflow_motor2!)&turbo_rpmhelice_motor2=\(tramo.turbo_helicerpm_motor2!)&turbo_ias_motor2=\(tramo.turbo_ias_motor2!)&turbo_itt_motor2=\(tramo.turbo_itt_motor2!)&turbo_ng_motor2=\(tramo.turbo_ng_motor2!)&turbo_oilpress_motor2=\(tramo.turbo_oilpress_motor2!)&turbo_oiltemp_motor2=\(tramo.turbo_oiltemp_motor2!)&turbo_torque_motor2=\(tramo.turbo_torque_motor2!)&turbo_vi_motor2=\(tramo.turbo_vi_motor2!)&turbo_vv_motor2=\(tramo.turbo_vv_motor2!)&turbo_dcac_motor2=\(tramo.turbo_dcac_motor2!)&turbo_amp_motor2=\(tramo.turbo_amp_motor2!)&turbo_fflow_in=\(tramo.turbo_fflow_in!)&turbo_fflow_in_motor2=\(tramo.turbo_fflow_in_motor2!)&turbo_fflow_out=\(tramo.turbo_fflow_out!)&turbo_fflow_out_motor2=\(tramo.turbo_fflow_out_motor2!)"
                                
                                
                                 let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                let url = URL(string: url_temp!)
                                print("URL: \(url!)")
                                
                                let configuracion = URLSessionConfiguration.default
                                let session = URLSession(configuration: configuracion)
                                let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                                    if urlResponse != nil {
                                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                            print(httpResponde.statusCode)
                                            if httpResponde.statusCode == 200 {
                                                if data != nil {
                                                    if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                        if json!.count > 0 {
                                                            self.dataSource =  json
                                                            self.results = self.dataSource["Lectura"] as! NSArray
                                                            
                                                            print(self.results.count)
                                                            
                                                            if (self.results.count > 0){
                                                                
                                                                let item = self.results[0] as! NSDictionary
                                                                
                                                                let insertado = item["insertado"] as! String
                                                                let idServidorInstrumento = item["idservidor"] as! String
                                                                
                                                                if(Int(insertado) != 0){
                                                                    
                                                                    self.coreDataStack.actualizarInstrumentosSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorInstrumento)!)
                                                                    
                                                                    next(nil)
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    else{
                                                        if let unwrappedError = jsonError {
                                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                            next(nil)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            else{
                                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                next(nil)
                                            }
                                        }else{
                                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                            next(nil)
                                        }
                                    }else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                        next(nil)
                                    }
                                })
                                
                                dataTask.resume()
                            }
                        }
                    }
                    else{
                        next(nil)
                    }
                }
                }
                else{
                    next(nil)
                }
                
            }
            
            queue.tasks += { result, next in
                
                
                if(global_var.j_bitacoras_idservidor != 0){
                    print("Agregar Pasajeros")
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
                    request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                    
                    let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasPax]
                    
                    if let bitacora = fetchResults{
                        print("Totalpax: \(bitacora.count)")
                        if(bitacora.count>0) {
                            for tramo in bitacora {
                                let wsURL = parametros.host + "/json?asp=bitacora_agregar_pasajero&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&paxname=\(tramo.nombre!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)"
                                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                let url = URL(string: url_temp!)
                                print("URL: \(url!)")
                                let configuracion = URLSessionConfiguration.default
                                let session = URLSession(configuration: configuracion)
                                let dataTask = session.dataTask(with: url! as URL, completionHandler: { (data, urlResponse, jsonError) in
                                    if urlResponse != nil {
                                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                            if httpResponde.statusCode == 200 {
                                                if data != nil {
                                                    if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                        
                                                        if json!.count > 0 {
                                                            self.dataSource =  json
                                                            self.results = self.dataSource["Pasajero"] as! NSArray
                                                            
                                                            if (self.results.count > 0){
                                                                
                                                                let item = self.results[0] as! NSDictionary
                                                                
                                                                let insertado = item["insertado"] as! String
                                                                let idServidorPax = item["idservidor"] as! String
                                                                
                                                                if(Int(insertado) != 0){
                                                                    
                                                                    self.coreDataStack.actualizarPasajeroSincronizado(idpax: tramo.idpax!, idservidor: formatonumber.number(from: idServidorPax)!)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    else{
                                                        if let unwrappedError = jsonError {
                                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                            next(nil)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            else{
                                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                next(nil)
                                            }
                                        }else{
                                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                            next(nil)
                                        }
                                    }else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                        next(nil)
                                    }
                                })
                                dataTask.resume()
                            } //Fin For
                            next(nil)
                        } // Fin If > 0
                        else{
                            next(nil)
                        }
                    }
                    else{
                        next(nil)
                    }
                }else{
                    next(nil)
                }
            }
            
            queue.tasks += { result, next in
                
                print("el id del servidor es: \(global_var.j_bitacoras_idservidor)")
                
                
                if(global_var.j_bitacoras_idservidor != 0){
                    sleep(15)
                    //Avisar que se se actualizo todo para que envie el correo
                    
                    let total_aterrizajes = aterrizajes.intValue //+ 1
                    let total_ciclos = ciclos.intValue //+ 1
                    let wsURL = parametros.host + "/json?asp=bitacora_sincronizada&matricula=\(matricula)&idbitacora=\(global_var.j_bitacoras_idservidor)&ultimabitacora=\(numbitacora)&ultimohorometro=\(horometrollega)&ultimohorometroapu=\(horometroapu)&ultimodestino=\(_ultimodestino)&modificacion=\(modificada)&nummodificacion=\(modificadatotal)&totalaterrizajes=\(total_aterrizajes)&totalciclos=\(total_ciclos)&motivo=\(motivo)"
                    
                    let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let url = URL(string: url_temp!)
                    print("URL: \(url!)")
                    let configuracion = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuracion)
                    let dataTask = session.dataTask(with: url! as URL, completionHandler: { (data, urlResponse, jsonError) in
                        if urlResponse != nil {
                            if  let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                if httpResponde.statusCode == 200 {
                                    if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                        if json!.count > 0 {
                                            self.dataSource =  json
                                            self.results = self.dataSource["Bitacora"] as! NSArray
                                            if (self.results.count > 0){
                                                
                                                let formato : DateFormatter = DateFormatter()
                                                formato.dateFormat = "dd/MM/yyyy"
                                                formato.dateStyle = .short
                                                
                                                //Fecha
                                                if  let item = self.results[0] as? NSDictionary {
                                                    print(item["fecha"] as! String)
                                                    
                                                    //if let fecha : NSDate = formato.dateFromString(item["fecha"] as! String) {
                                                        self.coreDataStack.actualizaUltimaSincronizacion(idpiloto: global_var.j_usuario_idPiloto as NSNumber, ultimaactualizacion: Date() as NSDate)
                                                    //}
                                                }
                                                
                                                next(nil)
                                            }else{
                                                next(nil)
                                            }
                                        }else{
                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "Error al generar bitácora, consulta a sistemas." as NSString, delegate: self)
                                            next(nil)
                                        }
                                    }
                                    else{
                                        if let unwrappedError = jsonError {
                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                             next(nil)
                                        }
                                       
                                    }
                                }else{
                                    next(nil)
                                }
                            }else{
                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                next(nil)
                            }
                        }else{
                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            next(nil)
                        }
                    })
                    dataTask.resume()
                }else{
                    next(nil)
                }
            }
            
            queue.tasks += { result, next in
               
                if(global_var.j_bitacoras_idservidor != 0){
                    self.coreDataStack.actualizaBitacoraSincronizada(idbitacora: idbitacora, idservidor: global_var.j_bitacoras_idservidor)
                    self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                    global_var.j_statusSincronizacion = 0
                    DispatchQueue.main.async {
                        self.sincronizarBitacoras(self.notifacion)
                    }
                }else{
                    Util.invokeAlertMethod(strTitle: "Error", strBody: "Error en el servidor, contacta a sistemas.", delegate: self)
                }
                next(nil)
            }
            
            queue.run({
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.performSelector(onMainThread: #selector(BitacorasViewController.loadbitacoras(searchtext:scope:)), with: nil, waitUntilDone: true)
                    //self.loadbitacoras("",scope: 0)
                    self.navigationItem.title = "Bitácoras"
                    print("finished")
                    //SwiftSpinner.hide()
                }
                
              
            })
            
        } //Fin si hay conexion
        
    } //Fin de la funcion
    
    //MARK: Sincronización nueva
    func sincronizarBitacora(matricula: String, numbitacora: NSNumber, fechavuelo: NSDate, capitan: String, capitannombre: String, cliente: String, mantenimientointerno: String, manteniminentodgac: String, nombretecnico:String, idbitacora: NSNumber, ifr: NSNumber, modificada: NSNumber, modificadatotal: NSNumber, aterrizajes: NSNumber, ciclos: NSNumber, hoy: NSNumber, motivo : String, horometrollega: NSNumber, horometroapu: NSNumber, nombrecopiloto: String, licenciacopiloto: String, prevuelo: String, prevuelolocal: NSNumber, legid: NSNumber, usuario: String) {
        
        let formatofecha : DateFormatter = DateFormatter()
        formatofecha.dateFormat = "dd/MM/yyyy"
        let formatonumber : NumberFormatter = NumberFormatter()
        formatonumber.decimalSeparator = "."
        formatonumber.maximumFractionDigits = 2
        
        if(Conexion.isConnectedToNetwork()){
            
            global_var.j_statusSincronizacion = 1
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            coreDataStack.buscaMatricula(matricula: matricula)
            
            let queue = TaskQueue()
            
            queue.tasks += { result, next in
                
                let wsURL = parametros.host + "/json?asp=bitacora_agregar&matricula=\(matricula)&numbitacora=\(numbitacora)&fechavuelo=\(formatofecha.string(from: fechavuelo as Date))&capitanid=\(capitan)&capitannombre=\(capitannombre)&cliente=\(cliente.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&mantenimientointerno=\(mantenimientointerno.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&mantenimientodgac=\(manteniminentodgac.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&nombretecnico=\(nombretecnico)&iddispositivo=\(idbitacora)&ifr=\(formatonumber.string(from: ifr)!)&modificacion=\(modificada)&nummodificacion=\(modificadatotal)&aterrizajes=\(aterrizajes)&ciclos=\(ciclos)&hoy=\(hoy)&motivo=\(motivo)&nombrecopiloto=\(nombrecopiloto)&licenciacopiloto=\(licenciacopiloto)&prevuelolocal=\(prevuelolocal)&prevuelo=\(prevuelo.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&legid=\(legid)&usuario=\(usuario)"
                
                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                //stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                let url = URL(string: url_temp!)
                print("URL: \(url!)")
                
                let configuracion = URLSessionConfiguration.default
                let session = URLSession(configuration: configuracion)
                let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                    if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                        print(httpResponde.statusCode)
                        if httpResponde.statusCode == 200 {
                            if data != nil {
                                if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                    if json!.count > 0 {
                                        self.dataSource =  json
                                        self.results = self.dataSource["Bitacora"] as! NSArray
                                        print(self.results.count)
                                        if (self.results.count > 0){
                                            let item = self.results[0] as! NSDictionary
                                            print("IFR: \(item["iddispositivo"] as! String)")
                                            global_var.j_bitacoras_idservidor = formatonumber.number(from: item["idservidor"] as! String)!
                                            //Int((item["idservidor"] as! String))!
                                            
                                            
                                            if(global_var.j_bitacoras_idservidor == 0){
                                                self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: (url?.absoluteString)!, error: true)
                                            }
                                            else{
                                                self.SincronizaTramo(matricula: matricula, idbitacora: idbitacora, numbitacora: numbitacora, fechavuelo: fechavuelo)
                                                self.SincronizaInstrumentos(matricula: matricula, idbitacora: idbitacora)
                                                self.SincronizaPasajeros(matricula: matricula, idbitacora: idbitacora)
                                                self.SincronizaUltimosDatos(matricula: matricula, idbitacora: idbitacora, horometrollega: horometrollega, horometroapu: horometroapu, modificada: modificada, modificadatotal: modificadatotal, numbitacora: numbitacora, aterrizajes: aterrizajes, ciclos: ciclos, motivo : motivo)
                                            }
                                            self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: (url?.absoluteString)!, error: false)
                                            next(nil)
                                        }
                                    }else{
                                        
                                        next(nil)
                                    }
                                }
                                else{
                                    if let unwrappedError = jsonError {
                                        Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                        next(nil)
                                    }
                                }
                            }
                        }
                        else{
                            self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: (url?.absoluteString)!, error: true)
                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                            next(nil)
                        }
                    }else{
                        self.coreDataStack.addLogs(numbitacora: numbitacora, matricula: matricula, url: "No contesto el webservice", error: true)
                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                        next(nil)
                    }
                })
                dataTask.resume()
                
            }
            
            queue.tasks += { result, next in
                
                if(global_var.j_bitacoras_idservidor != 0){
                    self.coreDataStack.actualizaBitacoraSincronizada(idbitacora: idbitacora, idservidor: global_var.j_bitacoras_idservidor)
                    self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                    global_var.j_statusSincronizacion = 0
                    self.sincronizarBitacoras(self.notifacion)
                }else{
                    Util.invokeAlertMethod(strTitle: "Error", strBody: "Error en el servidor, contacta a sistemas.", delegate: self)
                }
                next(nil)
            }
            
            queue.run({
                self.FinalizaSincronizacion(matricula: matricula)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.performSelector(onMainThread: #selector(BitacorasViewController.loadbitacoras(searchtext:scope:)), with: nil, waitUntilDone: true)
                //self.loadbitacoras("",scope: 0)
                self.navigationItem.title = "Bitácoras"
                print("finished")
                //SwiftSpinner.hide()
            })
            
        } //Fin si hay conexion
        
    } //Fin de la funcion
    
    func SincronizaTramo(matricula: String, idbitacora: NSNumber, numbitacora: NSNumber, fechavuelo: NSDate){
        
        let formatofecha : DateFormatter = DateFormatter()
        formatofecha.dateFormat = "dd/MM/yyyy"
        let formatonumber : NumberFormatter = NumberFormatter()
        formatonumber.decimalSeparator = "."
        formatonumber.maximumFractionDigits = 2
        
            //Tarea para inserta el tramo
            
            print("Agregar Tramos")
            
            if (global_var.j_bitacoras_idservidor != 0){
                var totalTramos : Array<AnyObject> = []
                totalTramos.removeAll(keepingCapacity: false)
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
                request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasLegs]
                
                if let bitacora = fetchResults{
                    for tramo in bitacora{
                        
                        self.ultimodestino = tramo.destino!
                        
                        let wsURL = parametros.host + "/json?asp=bitacora_agregar_tramo&idintercambio=0&idbitacora=\(global_var.j_bitacoras_idservidor)&fechasalida=\(formatofecha.string(from: fechavuelo as Date))&horasalida=\(tramo.horasalida!)&aeropuertosalida=\(tramo.origen!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&fechallegada=\(formatofecha.string(from: fechavuelo as Date))&horallegada=\(tramo.horallegada!)&aeropuertollegada=\(tramo.destino!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)&calzoacalzo=\(tramo.calzoacalzo!)&tiempovuelo=\(tramo.tv!)&horas=0&minutos=0&calzos=\(tramo.calzoacalzo!)&capitan=\(global_var.j_usuario_idPiloto)&copiloto=1&folio_s=0&tipovuelo=1&ferry=false&raite=false&pax=0&socio=0&numbitacora=\(numbitacora)&matricula=\(matricula)&hsalida=\(tramo.horometrodespegue!)&hllegada=\(tramo.horometroaterrizaje!)&fuellitros=\(tramo.combustibledespegue!)&fuelprecio=0&aceitecargado=\(tramo.aceitecargado!)&aceitecargadoapu=0&capitanaltimetrorvsm=\(tramo.capitan_altimetrorvsm!)&combustibleaterrizaje=\(tramo.combustibleaterrizaje!)&combustiblecargado=\(tramo.combustiblecargado!)&combustibleconsumido=\(tramo.combustibleconsumido!)&combustibledespegue=\(tramo.combustibledespegue!)&coordenadasregistro=0&nivelvuelo=\(tramo.nivelvuelo!)&oat=\(tramo.oat!)&pesoaterrizaje=\(tramo.pesoaterrizaje!)&pesocarga=\(tramo.pesocarga!)&pesocombustible=\(tramo.pesocombustible!)&pesodespegue=\(tramo.pesodespegue!)&pesooperacion=\(tramo.pesooperacion!)&primeroficialaltimetrorvsm=\(tramo.primeroficialaltimetrorvsm!)&combustibleunidadmedida=\(tramo.combustibleunidadmedida!)&combustibleunidadpeso=\(tramo.combustibleunidadpeso!)"
                        
                        let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        let url = URL(string: url_temp!)
                        print("URL: \(url!)")
                        let configuracion = URLSessionConfiguration.default
                        let session = URLSession(configuration: configuracion)
                        let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                            if urlResponse != nil {
                                if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse{
                                    print(httpResponde.statusCode)
                                    if httpResponde.statusCode == 200 {
                                        if data != nil {
                                            if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                if json!.count > 0 {
                                                    self.dataSource =  json
                                                    self.results = self.dataSource["Tramo"] as! NSArray
                                                    if (self.results.count > 0){
                                                        let item = self.results[0] as! NSDictionary
                                                        let eliminado = item["insertado"] as! String
                                                        let idServidorTramo = item["idservidor"] as! String
                                                        if(Int(eliminado) != 0){
                                                            self.coreDataStack.actualizaTramoSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorTramo)!)
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                if let unwrappedError = jsonError {
                                                    Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    }
                                }else{
                                    self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                }
                            }else{
                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                            }
                        })
                        
                        dataTask.resume()
                    }
                }
            }
            else{
            }
    }
    
    func SincronizaInstrumentos(matricula: String, idbitacora: NSNumber){
        let formatonumber : NumberFormatter = NumberFormatter()
        formatonumber.decimalSeparator = "."
        formatonumber.maximumFractionDigits = 2
        
            if (global_var.j_bitacoras_idservidor != 0) {
                
                //Tarea para inserta los instrumentos
                print("Agregar Instrumentos")
                
                print(global_var.j_avion_tipomotor)
                
                print(global_var.j_avion_totalmotor)
                
                if (global_var.j_avion_tipomotor == "1")   {
                    //JET
                    print("jet")
                    
                    var totalpiston_mono : Array<AnyObject> = []
                    
                    totalpiston_mono.removeAll(keepingCapacity: false)
                    
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
                    request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                    
                    let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasInstrumentos]
                    
                    if(fetchResults!.count > 0){
                        if let bitacora = fetchResults{
                            for tramo in bitacora{
                                let wsURL = parametros.host + "/json?asp=bitacora_agregar_instrumentos_jet&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&matricula=\(tramo.matricula!)&jet_amp=\(tramo.jet_amp!)&jet_amp_motor2=\(tramo.jet_amp_motor2!)&jet_apu_ciclos=\(tramo.jet_apu_ciclos!)&jet_apu_serie=\(tramo.jet_apu_serie!)&jet_apu_tt=\(tramo.jet_apu_tt!)&jet_apu_turm=\(tramo.jet_apu_turm!)&jet_avion_ciclos=\(tramo.jet_avion_ciclos!)&jet_avion_serie=\(tramo.jet_avion_serie!)&jet_avion_tt=\(tramo.jet_avion_tt!)&jet_avion_turm=\(tramo.jet_avion_turm!)&jet_dcac=\(tramo.jet_dcac!)&jet_dcac_motor2=\(tramo.jet_dcac_motor2!)&jet_fflow=\(tramo.jet_fflow!)&jet_fflow_motor2=\(tramo.jet_fflow_motor2!)&jet_fueltemp=\(tramo.jet_fueltemp!)&jet_fueltemp_motor2=\(tramo.jet_fueltemp_motor2!)&jet_hydvol=\(tramo.jet_hydvol!)&jet_hydvol_motor2=\(tramo.jet_hydvol_motor2!)&jet_ias=\(tramo.jet_ias!)&jet_itt=\(tramo.jet_itt!)&jet_itt_motor2=\(tramo.jet_itt_motor2!)&jet_lecturaaltimetro_capitan=\(tramo.jet_lecturaaltimetro_capitan!)&jet_lecturaaltimetro_primeroficial=\(tramo.jet_lecturaaltimetro_primeroficial!)&jet_motor1_ciclos=\(tramo.jet_motor1_ciclos!)&jet_motor1_serie=\(tramo.jet_motor1_serie!)&jet_motor1_tt=\(tramo.jet_motor1_tt!)&jet_motor1_turm=\(tramo.jet_motor1_turm!)&jet_motor2_ciclos=\(tramo.jet_motor2_ciclos!)&jet_motor2_serie=\(tramo.jet_motor2_serie!)&jet_motor2_tt=\(tramo.jet_motor2_tt!)&jet_motor2_turm=\(tramo.jet_motor2_turm!)&jet_n1=\(tramo.jet_n1!)&jet_n1_motor2=\(tramo.jet_n1_motor2!)&jet_n2=\(tramo.jet_n2!)&jet_n2_motor2=\(tramo.jet_n2_motor2!)&jet_oat=\(tramo.jet_oat!)&jet_oilpress=\(tramo.jet_oilpress!)&jet_oilpress_motor2=\(tramo.jet_oilpress_motor2!)&jet_oiltemp=\(tramo.jet_oiltemp!)&jet_oiltemp_motor2=\(tramo.jet_oiltemp_motor2!)&jet_dc=\(tramo.jet_dc!)"
                                
                                
                                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                let url = URL(string: url_temp!)
                                print("URL: \(url!)")
                                let configuracion = URLSessionConfiguration.default
                                let session = URLSession(configuration: configuracion)
                                let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                                    if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                        print(httpResponde.statusCode)
                                        if httpResponde.statusCode == 200 {
                                            if data != nil {
                                                if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                    if json!.count > 0 {
                                                        self.dataSource =  json
                                                        self.results = self.dataSource["Lectura"] as! NSArray
                                                        
                                                        print(self.results.count)
                                                        
                                                        if (self.results.count > 0){
                                                            
                                                            let item = self.results[0] as! NSDictionary
                                                            
                                                            let insertado = item["insertado"] as! String
                                                            let idServidorInstrumento = item["idservidor"] as! String
                                                            
                                                            if(Int(insertado) != 0){
                                                                
                                                                self.coreDataStack.actualizarInstrumentosSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorInstrumento)!)
                                                            }
                                                        }
                                                    } //Fin JSON Count
                                                } // Fin JSON
                                            } // Fin data
                                        } // Fin Status Code
                                    }else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                    }
                                })
                                dataTask.resume()
                            }
                        }
                    }
                    else{
                    }
                }else if(global_var.j_avion_tipomotor == "2"){
                    //Piston
                    
                    if(global_var.j_avion_totalmotor == 1){
                        var totalpiston_mono : Array<AnyObject> = []
                        totalpiston_mono.removeAll(keepingCapacity: false)
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
                        request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                        let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasInstrumentos]
                        print("Total Instrumentos Encontrados: \(String(describing: fetchResults?.count))")
                        if((fetchResults?.count)! > 0){
                            
                            if let bitacora = fetchResults{
                                
                                for tramo in bitacora{
                                    
                                    let wsURL = parametros.host + "/json?asp=bitacora_agregar_instrumentos_piston_mono&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&matricula=\(tramo.matricula!)&ampers=\(tramo.piston_ampers!)&cht=\(tramo.piston_cht!)&crucero=\(tramo.piston_crucero!)&egt=\(tramo.piston_egt!)&flow=\(tramo.piston_flow!)&fuelpress=\(tramo.piston_fuelpress!)&manpress=\(tramo.piston_manpress!)&oilpress=\(tramo.piston_oilpress!)&rpm=\(tramo.piston_rpm!)&temp=\(tramo.piston_temp!)&volts=\(tramo.piston_volts!)&oat=\(tramo.piston_oat!)&aceite_mas=\(tramo.piston_aceite_mas!)"
                                    
                                    let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                    let url = URL(string: url_temp!)
                                    print("URL: \(url!)")
                                    let configuracion = URLSessionConfiguration.default
                                    let session = URLSession(configuration: configuracion)
                                    let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                                        if urlResponse != nil {
                                            if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                                if httpResponde.statusCode == 200 {
                                                    if data != nil {
                                                        if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                            if json!.count > 0 {
                                                                self.dataSource =  json
                                                                self.results = self.dataSource["Lectura"] as! NSArray
                                                                print(self.results.count)
                                                                if (self.results.count > 0){
                                                                    let item = self.results[0] as! NSDictionary
                                                                    let insertado = item["insertado"] as! String
                                                                    let idServidorInstrumento = item["idservidor"] as! String
                                                                    if(Int(insertado) != 0){
                                                                        self.coreDataStack.actualizarInstrumentosSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorInstrumento)!)

                                                                    }
                                                                }
                                                            }
                                                        }
                                                        else{
                                                            if let unwrappedError = jsonError {
                                                                Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                }
                                            }else{
                                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                            }
                                        }else{
                                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        }
                                    })
                                    dataTask.resume()
                                }
                            }
                        }
                        else{
                        }
                        
                    }else{
                        
                    }
                }else if(global_var.j_avion_tipomotor == "3"){
                    //Turbo Propulsor
                    var totalpiston_mono : Array<AnyObject> = []
                    totalpiston_mono.removeAll(keepingCapacity: false)
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
                    request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                    let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasInstrumentos]
                    
                    if((fetchResults?.count)! > 0){
                        
                        if let bitacora = fetchResults{
                            
                            for tramo in bitacora{
                                
                                let wsURL = parametros.host + "/json?asp=bitacora_agregar_instrumentos_turbo&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&matricula=\(tramo.matricula!)&turbo_fflow=\(tramo.turbo_fflow!)&turbo_rpmhelice=\(tramo.turbo_helicerpm!)&turbo_ias=\(tramo.turbo_ias!)&turbo_itt=\(tramo.turbo_itt!)&turbo_ng=\(tramo.turbo_ng!)&turbo_nivelvuelo=0&turbo_oat=\(tramo.turbo_oat!)&turbo_oilpress=\(tramo.turbo_oilpress!)&turbo_oiltemp=\(tramo.turbo_oiltemp!)&turbo_torque=\(tramo.turbo_torque!)&turbo_vi=\(tramo.turbo_vi!)&turbo_vv=\(tramo.turbo_vv!)&turbo_dcac=\(tramo.turbo_dcac!)&turbo_amp=\(tramo.turbo_amp!)&turbo_avion_serie=\(tramo.turbo_avion_serie!)&turbo_avion_ciclos=\(tramo.turbo_avion_ciclos!)&turbo_avion_turm=\(tramo.turbo_avion_turm!)&turbo_avion_tt=\(tramo.turbo_avion_tt!)&turbo_motor_serie=\(tramo.turbo_motor_serie!)&turbo_motor_ciclos=\(tramo.turbo_motor_ciclos!)&turbo_motor_turm=\(tramo.turbo_motor_turm!)&turbo_motor_tt=\(tramo.turbo_motor_tt!)&turbo_helice_serie=\(tramo.turbo_helice_serie!)&turbo_helice_ciclos=\(tramo.turbo_helice_ciclos!)&turbo_helice_turm=\(tramo.turbo_helice_turm!)&turbo_helice_tt=\(tramo.turbo_helice_tt!)&&turbo_fflow_motor2=\(tramo.turbo_fflow_motor2!)&turbo_rpmhelice_motor2=\(tramo.turbo_helicerpm_motor2!)&turbo_ias_motor2=\(tramo.turbo_ias_motor2!)&turbo_itt_motor2=\(tramo.turbo_itt_motor2!)&turbo_ng_motor2=\(tramo.turbo_ng_motor2!)&turbo_oilpress_motor2=\(tramo.turbo_oilpress_motor2!)&turbo_oiltemp_motor2=\(tramo.turbo_oiltemp_motor2!)&turbo_torque_motor2=\(tramo.turbo_torque_motor2!)&turbo_vi_motor2=\(tramo.turbo_vi_motor2!)&turbo_vv_motor2=\(tramo.turbo_vv_motor2!)&turbo_dcac_motor2=\(tramo.turbo_dcac_motor2!)&turbo_amp_motor2=\(tramo.turbo_amp_motor2!)&turbo_fflow_in=\(tramo.turbo_fflow_in!)&turbo_fflow_in_motor2=\(tramo.turbo_fflow_in_motor2!)&turbo_fflow_out=\(tramo.turbo_fflow_out!)&turbo_fflow_out_motor2=\(tramo.turbo_fflow_out_motor2!)"
                                
                                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                                let url = URL(string: url_temp!)
                                print("URL: \(url!)")
                                
                                let configuracion = URLSessionConfiguration.default
                                let session = URLSession(configuration: configuracion)
                                let dataTask = session.dataTask(with: url!, completionHandler: { (data, urlResponse, jsonError) in
                                    if urlResponse != nil {
                                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                            print(httpResponde.statusCode)
                                            if httpResponde.statusCode == 200 {
                                                if data != nil {
                                                    if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                        if json!.count > 0 {
                                                            self.dataSource =  json
                                                            self.results = self.dataSource["Lectura"] as! NSArray
                                                            
                                                            print(self.results.count)
                                                            if (self.results.count > 0){
                                                                
                                                                let item = self.results[0] as! NSDictionary
                                                                
                                                                let insertado = item["insertado"] as! String
                                                                let idServidorInstrumento = item["idservidor"] as! String
                                                                
                                                                if(Int(insertado) != 0){
                                                                    
                                                                    self.coreDataStack.actualizarInstrumentosSincronizado(idbitacora: idbitacora, matricula: matricula, idservidor: formatonumber.number(from: idServidorInstrumento)!)
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                    else{
                                                        if let unwrappedError = jsonError {
                                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                            }
                                        }else{
                                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                        }
                                    }else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                    }
                                })
                                dataTask.resume()
                            }
                        }
                    }
                    else{
                    }
                }
            }
            else{
            }
    }
    
    func SincronizaPasajeros(matricula: String, idbitacora: NSNumber){

        let formatonumber : NumberFormatter = NumberFormatter()
        formatonumber.decimalSeparator = "."
        formatonumber.maximumFractionDigits = 2
        
            if(global_var.j_bitacoras_idservidor != 0){
                print("Agregar Pasajeros")
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
                request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                
                let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasPax]
                
                if let bitacora = fetchResults{
                    print("Totalpax: \(bitacora.count)")
                    if(bitacora.count>0) {
                        for tramo in bitacora {
                            let wsURL = parametros.host + "/json?asp=bitacora_agregar_pasajero&idtramo=\(tramo.idtramo!)&idbitacora=\(global_var.j_bitacoras_idservidor)&paxname=\(tramo.nombre!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)"
                            let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let url = URL(string: url_temp!)
                            print("URL: \(url!)")
                            let configuracion = URLSessionConfiguration.default
                            let session = URLSession(configuration: configuracion)
                            let dataTask = session.dataTask(with: url! as URL, completionHandler: { (data, urlResponse, jsonError) in
                                if urlResponse != nil {
                                    if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                                        if httpResponde.statusCode == 200 {
                                            if data != nil {
                                                if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                                    
                                                    if json!.count > 0 {
                                                        self.dataSource =  json
                                                        self.results = self.dataSource["Pasajero"] as! NSArray
                                                        
                                                        if (self.results.count > 0){
                                                            
                                                            let item = self.results[0] as! NSDictionary
                                                            let insertado = item["insertado"] as! String
                                                            let idServidorPax = item["idservidor"] as! String
                                                            
                                                            if(Int(insertado) != 0){
                                                                
                                                                self.coreDataStack.actualizarPasajeroSincronizado(idpax: tramo.idpax!, idservidor: formatonumber.number(from: idServidorPax)!)
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    if let unwrappedError = jsonError {
                                                        Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                                    }
                                                }
                                            }
                                        }
                                        else{
                                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        }
                                    }else{
                                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                    }
                                }else{
                                    self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                                }
                            })
                            dataTask.resume()
                        } //Fin For
                    } // Fin If > 0
                    else{
                    }
                }
                else{
                }
            }else{
            }
    }
    
    func SincronizaUltimosDatos(matricula: String, idbitacora: NSNumber, horometrollega: NSNumber, horometroapu: NSNumber, modificada: NSNumber, modificadatotal: NSNumber, numbitacora: NSNumber, aterrizajes: NSNumber, ciclos: NSNumber, motivo : String){

            print("el id del servidor es: \(global_var.j_bitacoras_idservidor)")
            
            if(global_var.j_bitacoras_idservidor != 0){
                sleep(15)
                //Avisar que se se actualizo todo para que envie el correo
                
                let total_aterrizajes = aterrizajes.intValue //+ 1
                let total_ciclos = ciclos.intValue //+ 1
                let wsURL = parametros.host + "/json?asp=bitacora_sincronizada&matricula=\(matricula)&idbitacora=\(global_var.j_bitacoras_idservidor)&ultimabitacora=\(numbitacora)&ultimohorometro=\(horometrollega)&ultimohorometroapu=\(horometroapu)&ultimodestino=\(self.ultimodestino)&modificacion=\(modificada)&nummodificacion=\(modificadatotal)&totalaterrizajes=\(total_aterrizajes)&totalciclos=\(total_ciclos)&motivo=\(motivo)"
                
                let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                let url = URL(string: url_temp!)
                print("URL: \(url!)")
                let configuracion = URLSessionConfiguration.default
                let session = URLSession(configuration: configuracion)
                let dataTask = session.dataTask(with: url! as URL, completionHandler: { (data, urlResponse, jsonError) in
                    if urlResponse != nil {
                        if  let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                            if httpResponde.statusCode == 200 {
                                if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                    if json!.count > 0 {
                                        self.dataSource =  json
                                        self.results = self.dataSource["Bitacora"] as! NSArray
                                        if (self.results.count > 0){
                                            
                                            let formato : DateFormatter = DateFormatter()
                                            formato.dateFormat = "dd/MM/yyyy"
                                            formato.dateStyle = .short
                                            
                                            //Fecha
                                            if  let item = self.results[0] as? NSDictionary {
                                                print(item["fecha"] as! String)
                                                
                                                //if let fecha : NSDate = formato.dateFromString(item["fecha"] as! String) {
                                                self.coreDataStack.actualizaUltimaSincronizacion(idpiloto: global_var.j_usuario_idPiloto as NSNumber, ultimaactualizacion: Date() as NSDate)
                                                //}
                                            }
                                        }else{
                                        }
                                    }else{
                                        Util.invokeAlertMethod(strTitle: "Error", strBody: "Error al generar bitácora, consulta a sistemas." as NSString, delegate: self)
                                    }
                                }
                                else{
                                    if let unwrappedError = jsonError {
                                        Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                    }
                                    
                                }
                            }else{
                            }
                        }else{
                            self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }else{
                        self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                })
                dataTask.resume()
            }else{
            }
    }
    
    func FinalizaSincronizacion(matricula: String){
        
        if(global_var.j_bitacoras_idservidor != 0){
            sleep(15)
            //Avisar que se se actualizo todo para que envie el correo
            
            let wsURL = parametros.host + "/json?asp=finalizaSincronizacion&matricula=\(matricula)"
            
            let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let url = URL(string: url_temp!)
            print("URL: \(url!)")
            let configuracion = URLSessionConfiguration.default
            let session = URLSession(configuration: configuracion)
            let dataTask = session.dataTask(with: url! as URL, completionHandler: { (data, urlResponse, jsonError) in
                if urlResponse != nil {
                    if  let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                        if httpResponde.statusCode == 200 {
                            if let json =  ((try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary) as NSDictionary??) {
                                if json!.count > 0 {
                                    self.dataSource =  json
                                    self.results = self.dataSource["Bitacora"] as! NSArray
                                    if (self.results.count > 0){
                                        
                                    }else{
                                    }
                                }else{
                                    Util.invokeAlertMethod(strTitle: "Error", strBody: "Error al generar bitácora, consulta a sistemas." as NSString, delegate: self)
                                }
                            }
                            else{
                                if let unwrappedError = jsonError {
                                    Util.invokeAlertMethod(strTitle: "Error", strBody: "json error: \(unwrappedError)" as NSString, delegate: self)
                                }
                                
                            }
                        }else{
                        }
                    }else{
                    }
                }else{
                }
            })
            dataTask.resume()
        }else{
        }
    }
    //MARK: Soncronización SOAP
    func SincrinizaVueloSoap(matricula: String, numbitacora: NSNumber, fechavuelo: NSDate, capitan: String, capitannombre: String, cliente: String, mantenimientointerno: String, manteniminentodgac: String, nombretecnico:String, idbitacora: NSNumber, ifr: NSNumber, modificada: NSNumber, modificadatotal: NSNumber, aterrizajes: NSNumber, ciclos: NSNumber, hoy: NSNumber, motivo : String, horometrollega: NSNumber, horometroapu: NSNumber, nombrecopiloto: String, licenciacopiloto: String, prevuelo: String, prevuelolocal: NSNumber, legid: NSNumber, usuario: String){
        
        var _ultimodestino : String = ""
        
        let formatofecha : DateFormatter = DateFormatter()
        formatofecha.dateFormat = "dd/MM/yyyy"
        let formatonumber : NumberFormatter = NumberFormatter()
        formatonumber.decimalSeparator = "."
        formatonumber.maximumFractionDigits = 2

        if(Conexion.isConnectedToNetwork()){
            
            global_var.j_statusSincronizacion = 1
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            coreDataStack.buscaMatricula(matricula: matricula)
            
            //Tramos
            var TramoXML = ""
            var totalTramos : Array<AnyObject> = []
            totalTramos.removeAll(keepingCapacity: false)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
            request.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
            let fetchResults = try! self.coreDataStack.managedObjectContext.fetch(request) as? [BitacorasLegs]
            
            if let bitacora = fetchResults{
                for tramo in bitacora{
                    _ultimodestino = tramo.destino!
                    TramoXML = String(format: "<Tramo fechaSalida='%@' horaSalida='%@' aeropuertoSalida='%@' fechaLlegada='%@' horaLlegada='%@' aeropuertoLlegada='%@' horometroSale='' horometroLlega='' origen='' destino='' ifr='' modificacion='' nocturno='' tv='' horaSalida='' horaLlegada='' combSalida='' combLlegada='' combCargado='' pesoCarga='' pesoCombustible='' nivelVuelo='' />", formatofecha.string(from: fechavuelo as Date), tramo.horasalida!, tramo.origen!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!, formatofecha.string(from: fechavuelo as Date), tramo.horallegada!, tramo.destino!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)
                }
            }
            
            //Instrumentos
            var MotorXML = ""
            var totalpiston_mono : Array<AnyObject> = []
            totalpiston_mono.removeAll(keepingCapacity: false)
                
            let requestMotor = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
            requestMotor.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
                
            let fetchResultsMotor = try! self.coreDataStack.managedObjectContext.fetch(requestMotor) as? [BitacorasInstrumentos]
                
            if(fetchResultsMotor!.count > 0){
                if let bitacora = fetchResultsMotor{
                    for tramo in bitacora{
                        if (global_var.j_avion_tipomotor == "1")   {
                        //JET
                            MotorXML = String(format: "<InstrumentosJet amp='%@' ampM2='%@' dcac='%@' dcacM2='%@' fuelFlow='%@' fuelFlowM2='%@' fuelTemp='%@' fuelTempM2='%@' hydvol='%@' hydvolM2='%@' ias='%@' itt='%@' ittM2='%@' altRVSMCap='%@' altRVSMCop='%@' n1='%@' n1M2='%@' n2='%@' n2M2='%@' oat='%@' oilPress='%@' oilPressM2='%@' iolTemp='%@' iolTempM2='%@' dc='%@' />", tramo.jet_amp!, tramo.jet_amp_motor2!, tramo.jet_dcac!, tramo.jet_dcac_motor2!, tramo.jet_fflow!, tramo.jet_fflow_motor2!, tramo.jet_fueltemp!, tramo.jet_fueltemp_motor2!, tramo.jet_hydvol!, tramo.jet_hydvol_motor2!, tramo.jet_ias!, tramo.jet_itt!, tramo.jet_itt_motor2!, tramo.jet_lecturaaltimetro_capitan!, tramo.jet_lecturaaltimetro_primeroficial!, tramo.jet_n1!, tramo.jet_n1_motor2!, tramo.jet_n2!, tramo.jet_n2_motor2!, tramo.jet_oat!, tramo.jet_oilpress!, tramo.jet_oilpress_motor2!, tramo.jet_oiltemp!, tramo.jet_oiltemp_motor2!, tramo.jet_dc!)
                        }else if(global_var.j_avion_tipomotor == "2"){
                            //Piston
                            MotorXML = String(format: "<InstrumentosPiston amp='%@' cht='%@' crucero='%@' egt='%@' fuelFlow='%@' fuelPress='%@' manPress='%@' iolPress='%@' rpm='%@' oilTemp='%@' volts='%@' oat='%@' aceiteCargado='%@' />", tramo.piston_ampers!, tramo.piston_cht!, tramo.piston_crucero!, tramo.piston_egt!, tramo.piston_flow!, tramo.piston_fuelpress!, tramo.piston_manpress!, tramo.piston_oilpress!, tramo.piston_rpm!, tramo.piston_temp!, tramo.piston_volts!, tramo.piston_oat!, tramo.piston_aceite_mas!)
                            if(global_var.j_avion_totalmotor == 1){
                            }else{
                                
                            }
                        }else if(global_var.j_avion_tipomotor == "3"){
                            MotorXML = String(format: "<InstrumentosTurbo fuelFlow='%@' heliceRPM='%@' ias='%@' itt='%@' ng='%@' oat='%@' oilPress='%@' oilTemp='%@' torque='%@' vi='%@' vv='%@' dcac='%@' amp='%@' fuelFlowM2='%@' heliceRPMM2='%@' iasM2='%@' ittM2='%@' ngM2='%@' oilPressM2='%@' oilTempM2='%@' torqueM2='%@' viM2='%@' vvM2='%@' dcacM2='%@' ampM2='%@'  fflowIn='%@' fflowInM2='%@' fflowOut='%@' fflowOutM2='%@' />", tramo.turbo_fflow!, tramo.turbo_helicerpm!, tramo.turbo_ias!, tramo.turbo_itt!, tramo.turbo_ng!, tramo.turbo_oat!, tramo.turbo_oilpress!, tramo.turbo_oiltemp!, tramo.turbo_torque!, tramo.turbo_vi!, tramo.turbo_vv!, tramo.turbo_dcac!, tramo.turbo_amp!, tramo.turbo_fflow_motor2!, tramo.turbo_helicerpm_motor2!, tramo.turbo_ias_motor2!, tramo.turbo_itt_motor2!, tramo.turbo_ng_motor2!, tramo.turbo_oilpress_motor2!, tramo.turbo_oiltemp_motor2!, tramo.turbo_torque_motor2!, tramo.turbo_vi_motor2!, tramo.turbo_vv_motor2!, tramo.turbo_dcac_motor2!, tramo.turbo_amp_motor2!, tramo.turbo_fflow_in!, tramo.turbo_fflow_in_motor2!, tramo.turbo_fflow_out!, tramo.turbo_fflow_out_motor2!)
                        }
                    }
                }
            }
            
            //Pasajeros
            var PasajerosXML = ""
            let requestPax = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
            requestPax.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray: [idbitacora,matricula])
            
            let fetchResultsPax = try! self.coreDataStack.managedObjectContext.fetch(requestPax) as? [BitacorasPax]
            
            if let bitacora = fetchResultsPax{
                print("Totalpax: \(bitacora.count)")
                if(bitacora.count>0) {
                    PasajerosXML = "<Pasajeros>"
                    for tramo in bitacora {
                        PasajerosXML += String(format: "<Pasajero nombre='%@' />", tramo.nombre!.addingPercentEncoding(withAllowedCharacters: self.customAllowedSet)!)
                    }
                    PasajerosXML += "</Pasajeros>"
                }
            }
            
            let text = String(format: "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><SincronizaBitacora xmlns='http://intranet.aerotron.com.mx/apps'><xml><Bitacora matricula='' numBitacora='' fecha='' cliente=''><Tripulacion><Capitan nombre='' licencia='' id='' /><Copiloto nombre='' licencia='' id='' /></Tripulacion>%@ %@</Bitacora></xml></SincronizaBitacora></soap:Body></soap:Envelope>", MotorXML, PasajerosXML)
            
            var soapMessage = text
            let url = NSURL(string: wsUrl)
            let theRequest = NSMutableURLRequest(url: url! as URL)
            let msLength = String(soapMessage.count)
            
            theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            theRequest.addValue("http://intranet.aerotron.com.mx/apps/SincronizaBitacora", forHTTPHeaderField: "SOAPAction")
            theRequest.addValue(String(msLength), forHTTPHeaderField: "Content-Length")
            theRequest.httpMethod = "POST"
            theRequest.httpBody = soapMessage.data(using: .utf8)
            
            let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
            connection?.start()
            
            if ((connection) != nil){
                var mutableData : Void = NSMutableData.initialize()
                print(mutableData)
            }
        }
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData.length = 0;
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        print(String(data: data, encoding: .utf8) as Any)
        mutableData.append(data as Data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.shouldProcessNamespaces = false
        xmlParser.shouldReportNamespacePrefixes = false
        xmlParser.shouldResolveExternalEntities = false
        xmlParser.parse()
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if(elementName != nil){
            lastElementName = currentElementName
            currentElementName = elementName as NSString
            //print(String(format: "ElementName: %@", elementName))
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(String(format: "fondCharacters / value %@", string))
        if(string != nil){
            print(String(format: "CurrentElement: %@", currentElementName))
            if (currentElementName == "Matricula"){
                MatriculaServer = string as NSString
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Termino de leer el xml")
        
        print(MatriculaServer)
        
        if(global_var.j_bitacoras_idservidor != 0){
            //self.coreDataStack.actualizaBitacoraSincronizada(idbitacora: idbitacora, idservidor: global_var.j_bitacoras_idservidor)
            //self.coreDataStack.cerrarBitacora(idbitacora: idbitacora, matricula: matricula)
            global_var.j_statusSincronizacion = 0
            self.sincronizarBitacoras(self.notifacion)
        }else{
            Util.invokeAlertMethod(strTitle: "Error", strBody: "Error en el servidor, contacta a sistemas.", delegate: self)
        }
    }
}
