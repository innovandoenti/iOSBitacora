//
//  LauncViewController.swift


import UIKit

class LauncViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate, XMLParserDelegate {
    
    let coreDataStack = CoreDataStack()
    //let appdelegate = AppDelegate()
    let util = Util()
    var window: UIWindow?
    var dataSource : NSDictionary!
    var results : NSArray!
    
    @IBOutlet weak var lbProceso: UILabel!
    @IBOutlet weak var Progresso: UIProgressView!
    
    var wsUrl : String = "http://bitacora.innovandoenti.com"
    var mutableData:NSMutableData = NSMutableData.init()
    var currentElementName:NSString = ""
    var lastElementName:NSString = ""
    var VersionServer: NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // UpdateAircraftInformation()
        
        self.Progresso.setProgress(0, animated: true)
        lbProceso.text = "Verificando versión"
        self.Progresso.setProgress(0.1, animated: true)
        
        let tareas = TaskQueue()
        
        tareas.tasks += { result, next in
            global_var.j_statusconexion = "En Linea"
            
            self.Progresso.setProgress(0.5, animated: true)
            
            DispatchQueue.main.async {
                //self.revisaServidor()
                next(nil)
            }
            
            tareas.tasks += { result, next in
                global_var.j_statusconexion = "En Linea"
                
                self.Progresso.setProgress(1.0, animated: true)
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                    var destViewController : UIViewController
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                    
                    self.present(destViewController, animated: true, completion: nil)
                    next(nil)
                }
                
            }
        }
            tareas.run()
        
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
            if (currentElementName == "ObtieneVersionResult"){
                VersionServer = string as NSString
            }
        }
    }
    
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Termino de leer el xml")
        let versionInt = Float(String(VersionServer))
        if versionInt != global_var.j_version {
            coreDataStack.actualizando(idpiloto: NSNumber(value: global_var.j_usuario_idPiloto), actualizando: 1)
            global_var.j_mostrar_mensaje_actualizacion = true
            mostrarMensaje()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    func mostrarMensaje(){
        if coreDataStack.actualizando(idpiloto: NSNumber(value: global_var.j_usuario_idPiloto)) == true {
            UIApplication.shared.applicationIconBadgeNumber = 1
            global_var.j_mostrar_mensaje_actualizacion = false
            coreDataStack.actualizando(idpiloto: NSNumber(value: global_var.j_usuario_idPiloto), actualizando: 0)
            let alertController = DBAlertController(title: "Actualización disponible", message: "Hay una actualización disponible para instalar, ¿Deseas instalar?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                print("Ok Button Pressed")
                let urlString = "itms-services://?action=download-manifest&url=https://www.aerotron.com.mx/Bitacora/Bitacoras.plist"
                let url_temp = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                let url = URL(string: url_temp!)!
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            })
            
            let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler:  { action  in
                print("Cancel Button Pressed")
            })
            
            alertController.addAction(cancel)
            alertController.addAction(ok)
            alertController.show(animated: true, completion: nil)
        }
    }
    
    func UpdateAircraftInformation(){
        /*let queueBita = DispatchQueue(label: "mx.Bitacora.RegresaBitacoras", qos: DispatchQoS.utility)
        
        queueBita.async {
            print("------- Bitácoras -----")
            self.coreDataStack.regresarBitacorasSincronizar()
        }
        
        queueBita.async {
            print("------- Aviones -----")
            if global_var.j_existe_bitacora_por_sincronizar == false {
                self.coreDataStack.verificaHayAvionesPorSincronizar()
            }
        }
        queueBita.async {
            print("------- Pilotos -----")
            self.coreDataStack.pilotosPorSincronizar()
        }*/
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
