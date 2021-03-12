//
//  AjustesTableViewController.swift


import UIKit
import MessageUI
import CoreData

enum MIMEType: String {
    case jpg = "image/jpeg"
    case png = "image/png"
    case sql = "application/x-sqlite3"
    case pdf = "application/pdf"

    init?(type:String){
        switch type.lowercased(){
        case "jpg" : self = .jpg
        case "png" : self = .png
        case "sql" : self = .sql
        case "pdf" : self = .pdf
        default : return nil
        }
    }
}

class AjustesTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    
    //MFMailComposeViewControllerDelegate
    let coreDataStack = CoreDataStack()
    @IBOutlet weak var lbConexion: UILabel!
    @IBOutlet weak var lbFechaSincronizado: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var bntSincronizarAvion: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(AjustesTableViewController.verificaStatuss(_:)), name: NSNotification.Name(rawValue: "verificaStatus"), object: nil)
        
        lbVersion.text = "\(global_var.j_version)"
        
        verificaStatus()
        
        cargarAjustes()
    }
    
    func verificaStatus(){
        if global_var.j_statusconexion == "En Linea"{
            lbConexion.text = global_var.j_statusconexion
            lbConexion.textColor = UIColor.green
      }else{
            lbConexion.text = global_var.j_statusconexion
            lbConexion.textColor = UIColor.red
      }
    }
    
    @objc func verificaStatuss(_: NSNotification){
        if global_var.j_statusconexion == "En Linea"{
            lbConexion.text = global_var.j_statusconexion
            lbConexion.textColor = UIColor.green
      }else{
            lbConexion.text = global_var.j_statusconexion
            lbConexion.textColor = UIColor.red
        }
    }
   
    override func viewDidAppear(_  animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AjustesTableViewController.verificaStatuss(_:)), name: NSNotification.Name(rawValue: "verificaStatus"), object: nil)
        
        verificaStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargarAjustes() {
        
        let formato : DateFormatter = DateFormatter()
        formato.dateFormat = "dd/MM/yyyy"
        formato.dateStyle = .short  
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ajustes")
        
        do{
            let fetchResults =  try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [Ajustes]
            if let aviones = fetchResults{
                for row in aviones{
                   
                    if row.ultimasincronizacion != nil{
                        if let fecha = row.ultimasincronizacion! as? NSDate {
                            lbFechaSincronizado.text = formato.string(from: fecha as Date)
                        }else{
                            lbFechaSincronizado.text = "ND"
                        }
                    }
                    
                }
            }
        }catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch (section){
        case 0:
            return 1
            
        case 1:
            return 2
            
        case 2:
            return 2
            
        default:
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var altura : CGFloat = 0
        
        if DeviceType.IS_IPAD {
            altura = 90
        }else {
            altura = 60
        }
        
        return altura
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section ==  1{
            if indexPath.row == 1{
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["email"])
                    mail.setMessageBody("--> No borrar el archivo adjunto <--", isHTML: true)
                    mail.title = "Enviar"
                    mail.setSubject("Contacto bitácora app")
                    let url_file  = coreDataStack.applicationDocumentsDirectory.appendingPathComponent("taxiaereo.sqlite")
                    do{
                        if let fileData = try Data.init(contentsOf: url_file!) as? Data {
                            
                            
                            mail.addAttachmentData(fileData, mimeType: "application/x-sqlite3", fileName: "Feedback")
                        }
                    }
                    catch{
                        print("error al obtener la base de datos")
                    }
                    
                    
                    present(mail, animated: true)
                } else {
                    // show failure alert
                }
            }
        }
        /*
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                let mailComposeViewController = configuredMailComposeViewController()
                
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
        }*/
        
    	
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
   
    @IBAction func btnCerrarSesion(_ sender: Any) {
    
        let alertController = UIAlertController(title: "", message: " ¿Deseas cerrar sesión? ", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: .default) { action -> Void in
            
            self.coreDataStack.cerrarSesion()
            self.regresarLogin()
            
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    
    }
    
    
    func regresarLogin() {
        
        let destino = "vc_iniciar"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: destino)
        
        self.present(destviewcontroller, animated: true, completion: nil)
        
    }
    
}
