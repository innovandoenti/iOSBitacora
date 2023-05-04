//
//  Util.swift
//  DemoProject
//
//  Created by Krupa-iMac on 24/07/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let resizingMask: UIView.AutoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    
    
    class func getPath(fileName: String) -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + fileName
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: dbPath) { // fileExists(atPath: dbPath){
           
            let fromPath: String? = Bundle.main.resourcePath! + (fileName as String)
            do {
                try fileManager.copyItem(atPath: fromPath!, toPath: dbPath)
            } catch _ {
            }

        }
    }
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButton(withTitle: "Aceptar")
        alert.show()
    }
    
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
       func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
   
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func buildImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "Default.png"))
        imageView.frame = container.bounds
        imageView.autoresizingMask = self.resizingMask
        return imageView
    }
    
    func buildBlurView() -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: self.effect)
        blurView.frame = container.bounds
        blurView.autoresizingMask = self.resizingMask
        return blurView
    }
    
    func regresarABitacoras(){
        
        let window: UIWindow = UIWindow()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "vcBitacoras")
        let navController = UINavigationController(rootViewController: destViewController)
        
        window.rootViewController = navController
        
        window.makeKeyAndVisible()
    }
    
    func dateformatterDateString(dateString: NSString) -> NSDate?
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        return dateFormatter.date(from: dateString as String) as NSDate?
    }


    func calculaPesoCombustible(cantidadpeso: Float, unidadfuel: NSNumber, unidadpesofuel: NSNumber ) -> String {
        
        
        /* global_var.j_avion_pesofuel = 1
        global_var.j_avion_tipofuel = 1
        global_var.j_avion_unidadpesofuel = 0*/
        var regresar = "0"
        var total : Float = 0.0
        
        let formato : NumberFormatter = NumberFormatter()
        formato.numberStyle = .decimal
        formato.decimalSeparator = "."
        
        if(global_var.j_avion_tipofuel == 0){ //AVGAS
            if(unidadfuel == 0){ // LTS
                if(unidadpesofuel == 0){ //LBS
                    total =  (cantidadpeso * global_var.j_avgas_lts_lbs)
                }else{ //KGS
                    total = (cantidadpeso * global_var.j_avgas_lts_kgs)
                }
            }else{ //GLN
                if(unidadpesofuel == 0){ //LBS
                    total =  (cantidadpeso * global_var.j_avgas_gln_lbs)
                }else{ //KGS
                    total =  (cantidadpeso * global_var.j_avgas_gln_kgs)
                }
            }
        }else{
            //Calculo para el tipo de fuel JET A1
            
            if(unidadfuel == 0){ // LTS
                if(unidadpesofuel == 0){ //LBS
                    total =  (cantidadpeso * global_var.j_jet_lts_lbs)
                }else{ //KGS
                     total =  (cantidadpeso * global_var.j_jet_lts_kgs)
                }
                
            }else{ //GLN
                if(unidadpesofuel == 0){ //LBS
                     total =  (cantidadpeso * global_var.j_jet_gln_lbs)
                }else{ //KGS
                    total =  (cantidadpeso * global_var.j_jet_gln_kgs)
                }
            }
        }
        
        regresar = "\(total)"
        
       return regresar
        
    }
    
    class func validaTiempos(horacalzo: String, tiempovuelo: NSNumber) -> Bool {
        
        //Valida si los tiempos de calzo a calzo estan en un rango de 10 minutos en los horometros
        let splitTime = horacalzo.split(separator: ":")
        if splitTime.count > 1 {
            let horas  = splitTime[0]
            let minutos = (Double(splitTime[1])! / 60) + 0.16
            let total_decimal = Double(horas)! + minutos
            
            if(Double(tiempovuelo) > total_decimal){
                return false
            }
            
            if(Double(tiempovuelo) <= 0){
                return false
            }
        }
        
        return true
    }
}
