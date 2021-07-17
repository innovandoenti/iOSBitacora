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
        let alertas = Alertas()
        if Conexion.isConnectedToNetwork(){
            
            if !txtUser.text!.isEmpty  {
                
                _ = SwiftSpinner.show("Validating credentials...")
                
                let queue = TaskQueue()
                
                queue.tasks +=~ { result, next in
                    
                    let wsURL = "http://webbitacora.innovandoenti.com/json?asp=verificausuariopiloto&usuario=\(self.txtUser.text!)"
                    let url = URL(string: wsURL)
                    print("URL: \(url!)")
                    
                    let configuration = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuration)
                    let dataTask = session.dataTask(with: url!, completionHandler: {(data, urlResponse, error) in
                        
                        if let httpResponde : HTTPURLResponse = urlResponse as? HTTPURLResponse {
                            
                            if httpResponde.statusCode == 200 {
                                
                                if data != nil {
                                    
                                    if let json =  try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary  {
                                        if(json.count > 0){
                                            _ = SwiftSpinner.show("Validating credentials..", animated: true)
                                            self.dataSource =  json
                                            self.results = json["Usuarios"] as? NSArray
                                            if (self.results.count > 0){
                                                OK = true
                                                let row = self.results[0] as! NSDictionary
                                                global_var.j_usuario_clave = row["clave"] as! String
                                                global_var.j_usuario_nombre = row["nombre"] as! String
                                                global_var.j_usuario_perfil = row["perfil"] as! String
                                                let idpiloto = row["idpiloto"] as! NSString
                                                global_var.j_usuario_idPiloto = Int(idpiloto.intValue)
                                                global_var.j_piloto_licencia = row["licencia"] as! String
                                                global_var.j_piloto_id = (idpiloto) as String
                                                self.coreDataStack.insertUsuario(clave: row["clave"] as! String, correo:  row["correo"] as! String , idpiloto: row["idpiloto"] as! String, licencia: row["licencia"] as! String, nombre: row["nombre"] as! String, perfil: row["perfil"] as! String, registrado: "1", telefono: row["telefono"] as! String, tokenregistrado: "0")
                                                self.coreDataStack.verificaHayAvionesPorSincronizar()
                                                self.coreDataStack.pilotosPorSincronizar()
                                                next(nil)
                                            }
                                            else{
                                                SwiftSpinner.hide({
                                                    alertas.displayAlert(title: "Failure", msg: "Verify your username and / or password")
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
                                
                                alertas.displayAlert(title: "Failure", msg: "You are not registered into the system.")
                                
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
                            
                            alertas.displayAlert(title: "Failure", msg: "Verify your username and / or password.")
                        })
                    }
                    
                }
                
                queue.run{
                    
                    SwiftSpinner.hide()
                    
                }
            }
            else{
                SwiftSpinner.hide({
                    alertas.displayAlert(title: "Failure", msg: "Verify your username and / or password.")
                })
                
                
            }
        }
        else{
            alertas.displayAlert(title: "Failure", msg: "Verify your conexion.")
        }
    }
    
    func error(error: String!, code: Int32, severity: Int32) {
        print(error)
    }
    
    //MARK - Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField === txtUser){
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
