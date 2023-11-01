//
//  LoginViewController.swift


import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var viewcontroles: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = resizingMask
        
        
        
        configurarView()
    }
    
    func configurarView(){
        self.txtUser.delegate = self
        self.txtPass.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnValidar(sender: AnyObject) {
        validar()
    }
    
    func validar()
    {
        var OK = false
        let login = Login()
        
        if Conexion.isConnectedToNetwork(){
            
            if !txtUser.text!.isEmpty{
                
                _ = SwiftSpinner.show("Validating credentials...")
                
                let queue = TaskQueue()
                
                queue.tasks +=~ { result, next in
                    
                  //  login.checkUser(user: self.txtUser.text!, password: self.txtPass.text!)
                    
                    let wsURL = "https://webbitacora.innovandoenti.com/json.aspx?asp=verificausuariopiloto&usuario=\(self.txtUser.text!)"
                    
                    let url_temp = wsURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

                    let url = URL(string: url_temp!)
                    print("URL: \(url!)")
                    
                    let configuration = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuration)
                    let dataTask = session.dataTask(with: url!, completionHandler: {(data, urlResponse, error) in
                        
                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                            print(httpResponde.statusCode)
                            if httpResponde.statusCode == 200 {
                                
                                if data != nil {
                                    
                                    if let json =  try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary  {
                                        if(json!.count > 0){
                                            _ = SwiftSpinner.show("Validating credentials..", animated: true)
                                            self.dataSource =  json
                                            self.results = json!["Usuarios"] as? NSArray
                                            if (self.results.count > 0){
                                                OK = true
                                                print("Usuario")
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
                                                SwiftSpinner.hide({
                                                    AlertView.instance.showAlert(title: "Failure", message: "Verify your username and / or password.", alertType: .failure)
                                                })
                                            }
                                        }
                                        else{
                                            
                                            
                                        }
                                    }
                                }
                            }
                        }else{
                            SwiftSpinner.hide({
                                AlertView.instance.showAlert(title: "Failure", message: "You are not registered into the system.", alertType: .failure)
                                
                            })
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
                        SwiftSpinner.hide({
                            AlertView.instance.showAlert(title: "Failure", message: "Verify your username and / or password.", alertType: .failure)
                        })
                    }
                    
                }
                
                queue.run{
                    
                    SwiftSpinner.hide()
                    
                }
            }
            else{
                SwiftSpinner.hide({
                    AlertView.instance.showAlert(title: "Failure", message: "Verify your username and / or password.", alertType: .failure)
                })
                
                
            }
        }
        else{
            AlertView.instance.showAlert(title: "Failure", message: "Verify your conexion.", alertType: .failure)
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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    
    

}
