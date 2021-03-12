//
//  EligeMatriculaViewController.swift
//  bitacoras
//
//  Created by Jaime Solis on 05/03/15.
//  Copyright (c) 2015 Jaime Solis. All rights reserved.
//

import UIKit
import CoreData

class EligeMatriculaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
   

    
    var dictionary : NSDictionary!
    var dataSource : NSDictionary!
    var results : NSArray!
    var items :  NSMutableArray!
    var searchResultados : NSArray!
    var totalArray : Array<AnyObject> = []
    var dic : NSMutableDictionary!
    var logica = Util()
   let coreDataStack = CoreDataStack()
    
    
    @IBOutlet weak var txtMatricula: UITextField!
    @IBOutlet weak var pickerMatriculas: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        global_var.j_avion_matricula = ""
        pickerMatriculas.delegate = self
        txtMatricula.delegate = self
        pickerMatriculas.isHidden = true
        
        var  frameRect : CGRect = txtMatricula.frame
        frameRect.size.height = 50
        txtMatricula.frame = frameRect
        obtenerMatriculas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func obtenerMatriculas(){
        
        totalArray.removeAll(keepingCapacity: false)
        
        let sortDescriptor = NSSortDescriptor(key: "matricula", ascending: true)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
        request.predicate = NSPredicate(format: "status==1")
        
        request.sortDescriptors = [sortDescriptor]
        request.fetchBatchSize = 20
        
        totalArray = try! coreDataStack.managedObjectContext.fetch(request) as Array<AnyObject>
        
    }
    
    //MARK: Data Source Picker VIew
    
    @IBAction func mostrarMatriculas(_ sender: UITextField) {
        
        let toolbar  : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EligeMatriculaViewController.cancelButtonPressed(sender:)))
        
        let doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(EligeMatriculaViewController.doneButtonPressed(sender:)))
        
        toolbar.setItems([cancelButton,doneButton], animated: true)
        
        
        sender.inputView = pickerMatriculas
        sender.inputAccessoryView = toolbar
    }
    
    @objc func cancelButtonPressed(sender: UIDatePicker){
        self.view.endEditing(true)
    }
    
    @objc func doneButtonPressed(sender: AnyObject){
        
        self.view.endEditing(true)
    }
    /*
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return totalArray.count
    }
   
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let item = totalArray[row] as! TaxiAereoMatriculas
        
        return item.matricula
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let row = totalArray[row] as! TaxiAereoMatriculas
        
        global_var.j_avion_matricula = row.matricula!
        global_var.j_avion_modelo = row.modelo!
        global_var.j_avion_tipomotor = row.tipomotor!
        global_var.j_avion_totalmotor = row.totalmotor!
        global_var.j_avion_totalpax = row.totalpax!
        global_var.j_avion_fabricante = row.fabricante!
        global_var.j_avion_ano = row.ano!
        global_var.j_avion_numeroserie = row.numeroserie!
        global_var.j_avion_pesooperacion = row.pesooperacion!
        global_var.j_avion_ultimabitacora = row.ultimabitacora!
        global_var.j_avion_ultimodestino = row.ultimodestino!
        global_var.j_avion_ultimohorometro = row.ultimohorometro!
        global_var.j_avion_mtow = row.mtow! as! Float
        global_var.j_avion_unidadpesoavion = row.unidadpesos!
        global_var.j_avion_ultimoaterrizaje = row.ultimoaterrizaje!
        global_var.j_avion_ultimociclo = row.ultimociclo!
        txtMatricula.text = global_var.j_avion_matricula
        
        print(global_var.j_avion_sincronizado)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            
        if totalArray.count > 0 {
            
            pickerMatriculas.isHidden = false
            
            let row = totalArray[0] as! TaxiAereoMatriculas
            
            global_var.j_avion_matricula = row.matricula!
            global_var.j_avion_modelo = row.modelo!
            global_var.j_avion_tipomotor = row.tipomotor!
            global_var.j_avion_totalmotor = row.totalmotor!
            global_var.j_avion_totalpax = row.totalpax!
            global_var.j_avion_fabricante = row.fabricante!
            global_var.j_avion_ano = row.ano!
            global_var.j_avion_numeroserie = row.numeroserie!
            global_var.j_avion_pesooperacion = row.pesooperacion!
            global_var.j_avion_ultimabitacora = row.ultimabitacora!
            global_var.j_avion_ultimodestino = row.ultimodestino!
            global_var.j_avion_ultimohorometro = row.ultimohorometro!
            global_var.j_avion_mtow = row.mtow! as! Float
            global_var.j_avion_unidadpesoavion = row.unidadpesos!
            global_var.j_avion_ultimoaterrizaje = row.ultimoaterrizaje!
            global_var.j_avion_ultimociclo = row.ultimociclo!
            txtMatricula.text = global_var.j_avion_matricula
            
            print(global_var.j_avion_sincronizado)
            
        }
        
        textField.resignFirstResponder()
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickerMatriculas.isHidden = true
        txtMatricula.resignFirstResponder()
    }

    @IBAction func btnDone(sender: AnyObject) {
        
        
        if (!global_var.j_avion_matricula.isEmpty){
            
            
            let existe = coreDataStack.verificaSiHayBitacoraMatricula(matricula: global_var.j_avion_matricula)
            
            if existe == false {
                
                global_var.j_bitacoras_Id = 0
                global_var.j_bitacora_abierta = 1
                global_var.j_procedencia = 1
                global_var.j_tramos_Id = 0
                global_var.j_instrumentos_Id = 0
                global_var.j_bitacora_mantenimientoInterno = ""
                global_var.j_bitacora_mantenimientoDGAC = ""
                global_var.j_bitacora_modificada = 0
                global_var.j_bitacora_nummodificada = 0
                global_var.j_bitacora_prevuelolocal = 0
                global_var.j_bitacora_prevuelo = ""
                
                /* No hay id de vuelo */
                global_var.j_vuelo_legid = "0"
                
                var menuAvion : String = ""
                
                /*  1- Jet
                 2.- Piston
                 3.- TurboPropulsor
                 */
                
                /*Peso Fuel
                 0 = LTS
                 1 = GLN
                 */
                
                /* Tipo Fuel
                 0 = AVGAS
                 1 = JET A1
                 */
                
                /* Unida Peso Fuel
                 
                 0 = LBS
                 1 = KGS
                 
                 */
                
                if (global_var.j_avion_tipomotor == "1")   {
                    //JET
                    menuAvion="jet_view"
                    global_var.j_avion_pesofuel = 1
                    global_var.j_avion_tipofuel = 1
                    
                    
                }else if(global_var.j_avion_tipomotor == "2"){
                    //Piston
                    
                    if(global_var.j_avion_totalmotor == 1){
                        menuAvion = "piston_mono"
                        global_var.j_avion_pesofuel = 1
                        global_var.j_avion_tipofuel = 0
                        
                    }else{
                        menuAvion = "piston_bimotor"
                        global_var.j_avion_pesofuel = 1
                        global_var.j_avion_tipofuel = 0
                        
                    }
                }else if(global_var.j_avion_tipomotor == "3"){
                    //Turbo Propulsor
                    global_var.j_avion_pesofuel = 1
                    global_var.j_avion_tipofuel = 0
                    if(global_var.j_avion_totalmotor == 2){
                        menuAvion = "turbo_bimotor"
                    }else{
                        menuAvion = "turbo"
                    }
                }
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                var destViewController : UIViewController
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: menuAvion)// instantiateViewControllerWithIdentifier(menuAvion)
                
                self.present(destViewController, animated: true, completion: nil)
            }
            else{
                Util.invokeAlertMethod(strTitle: "", strBody: "Es necesario cerrar bitácoras de la matrícula seleccionada", delegate: self)
                
                txtMatricula.text = ""
                
                txtMatricula.resignFirstResponder()
            }
        }
        else{
            Util.invokeAlertMethod(strTitle: "", strBody: "Necesitas seleccionar una matricula del taxi aereo", delegate: self)
            
            txtMatricula.text = ""
            
            txtMatricula.resignFirstResponder()
        }
    }

}
