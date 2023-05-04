//
//  Login_TableViewController.swift


import UIKit

class Login_TableViewController: UITableViewController, UITextFieldDelegate {
    
    
    let util = Util()
    let coreDataStack = CoreDataStack()
    var dictionary : NSDictionary!
    var dataSource : NSDictionary!
    var results : NSArray!
    let effect = UIBlurEffect(style: .dark)
    let resizingMask: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = true
        configurarView()
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
    
    
    
    func configurarView(){
        
        self.txtUser.delegate = self
        self.txtPass.delegate = self
        
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
        return 4
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.item{
        case 1:
            txtUser.becomeFirstResponder()
            break;
        case 2:
            txtPass.becomeFirstResponder()
            break
        default:
            print("Ocultar Teclado")
            self.view.endEditing(true)
            break
        }
       
    }
    
   
    
    
    
    @IBAction func BtnValidar(sender: AnyObject) {
        
       validar()
    }
    
    func validar()
    {
        var OK = false
        
        if Conexion.isConnectedToNetwork(){
            
            if !txtUser.text!.isEmpty && !txtPass.text!.isEmpty   {
                
                SwiftSpinner.show("Connecting...")
                
                let queue = TaskQueue()
                
                queue.tasks +=~ { result, next in
                    
                    let wsURL = "http://intranet.aerotron.com.mx/apps/json.aspx?asp=verificausuariopiloto&usuario=\(self.txtUser.text!)&contrasena=\(self.txtPass.text!)"
                    
                    let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) // stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let url = URL(string: url_temp!)
                    print("URL: \(url!)")
                    
                    let configuration = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuration)
                    let dataTask = session.dataTask(with: url!, completionHandler: {(data, urlResponse, error) in
                        
                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                        
                        if httpResponde.statusCode == 200 {
                            
                            if data != nil {
                                
                                if let json =  try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary  {
                                    
                                    if(json!.count > 0){
                                        
                                        SwiftSpinner.show("Authenticating user account..", animated: true)
                                        
                                        
                                        self.dataSource =  json
                                        self.results = json!["Usuarios"] as! NSArray
                                        
                                        print(self.results.count)
                                        
                                        if (self.results.count > 0){
                                            
                                            OK = true
                                            
                                            let row = self.results[0] as! NSDictionary
                                            
                                            global_var.j_usuario_clave = row["clave"] as! String
                                            global_var.j_usuario_nombre = row["nombre"] as! String
                                            global_var.j_usuario_perfil = row["perfil"] as! String
                                            let idpiloto = row["idpiloto"] as! NSString
                                            global_var.j_usuario_idPiloto = Int(idpiloto.intValue)
                                            global_var.j_piloto_licencia = row["licencia"] as! String
                                            
                                            
                                            self.coreDataStack.insertUsuario(clave: row["clave"] as! String, correo:  row["correo"] as! String , idpiloto: row["idpiloto"] as! String, licencia: row["licencia"] as! String, nombre: row["nombre"] as! String, perfil: row["perfil"] as! String, registrado: "1", telefono: row["telefono"] as! String, tokenregistrado: "0")
                                            
                                            
                                            self.coreDataStack.verificaHayAvionesPorSincronizar()
                                            self.coreDataStack.pilotosPorSincronizar()
                                            
                                            next(nil)
                                            
                                        }
                                        else{
                                            
                                            Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica tu usuario y/o contraseña", delegate: self)
                                            
                                            SwiftSpinner.hide()
                                        }
                                    }
                                    else{
                                        
                                        
                                    }
                                }
                            }
                        }
                        }else{
                            Util.invokeAlertMethod(strTitle: "Error", strBody: "No se pudo validar tus datos", delegate: self)
                            
                            SwiftSpinner.hide()
                        }
                        
                    })
                    
                    dataTask.resume()
                }
                
                queue.tasks +=! {
                    
                    if (OK == true){
                        
                        SwiftSpinner.hide({
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                            var destViewController : UIViewController
                            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                            self.present(destViewController, animated: true, completion: nil)
                        })
                    }
                    else{
                        Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica tu usuario y/o contraseña", delegate: self)
                        SwiftSpinner.hide()
                    }
                }
                
                queue.run{
                    SwiftSpinner.hide()
                }
            }
            else{
                Util.invokeAlertMethod(strTitle: "", strBody: "Verifica tu username y/o Password", delegate: self)
                SwiftSpinner.hide()
            }
        }
        else{
            Util.invokeAlertMethod(strTitle: "Error", strBody: "Verifica la conexion", delegate: self)
        }
    }
    
    func error(error: String!, code: Int32, severity: Int32) {
        print(error)
    }
    
    //MARK - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField === txtUser){
            txtPass.becomeFirstResponder()
        }else if(textField === txtPass){
            txtPass.resignFirstResponder()
            validar()
        }else{
            validar()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with withEvent: UIEvent?) {
        print("Ocultar Teclado")
        self.view.endEditing(true)
        super.touchesBegan(touches,  with: withEvent)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return true
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}

