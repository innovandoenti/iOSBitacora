//
//  PistonMono_Vuelo_TableViewController.swift
//  Bitacoras
//
//  Created by Jaime Solis on 27/05/15.
//  Copyright (c) 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class PistonMono_Vuelo_TableViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate {
    
    let coreDataStack = CoreDataStack()
    let util = Util()
    let timeIndex = 2
    let timeHeight = 164
    var timePickerIsShowing : Bool = false
    var tagUTC = 0
    var combustibleSale : Float = 0
    var combustibleLLega : Float = 0
    var combustibleConsumo : Float = 0
    var pesoDespegue : Float = 0
    var pesoCombustible : Float = 0
    var pesoCarga : Float = 0
    var pesoOperacion : Float = (global_var.j_avion_pesooperacion).floatValue
    var tiempoVueloHorometro : Float = 0
    var IFR : Float = 1
    var totalArray : NSMutableArray = NSMutableArray()
    let formatter : NumberFormatter = NumberFormatter()
    var logica = Util()
    var datePickerView : UIDatePicker = UIDatePicker()
    var dt : NSMutableArray = NSMutableArray()
    var dateformatter : DateFormatter = DateFormatter()
    var time_set = 0
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    var date = Date();
    var dateFormatter = DateFormatter()
    
    //MARK: - TextBox
    @IBOutlet weak var txtNivelVuelo: UITextField!
    @IBOutlet weak var txtUTCSale: UITextField!
    @IBOutlet weak var txtUTCLlega: UITextField!
    @IBOutlet weak var txtSale: UITextField!
    @IBOutlet weak var txtLlega: UITextField!
    @IBOutlet weak var txtTV: UITextField!
    @IBOutlet weak var txtCalzos: UITextField!
    @IBOutlet weak var txtHorometroSale: UITextField!
    @IBOutlet weak var txtHorometroLlega: UITextField!
    @IBOutlet weak var txtCombustibleSale: UITextField!
    @IBOutlet weak var txtCombustibleLlega: UITextField!
    @IBOutlet weak var txtConsumo: UITextField!
    @IBOutlet weak var txtPesoOperacion: UITextField!
    @IBOutlet weak var txtPesoCarga: UITextField!
    @IBOutlet weak var txtPesoCombustible: UITextField!
    @IBOutlet weak var txtPesoDespegue: UITextField!
    @IBOutlet weak var lbMTOW: UILabel!
    @IBOutlet weak var txtMatricula: UITextField!
    @IBOutlet weak var txtBitacora: UITextField!
    @IBOutlet weak var txtFecha: UITextField!
    @IBOutlet weak var txtCliente: UITextField!
    @IBOutlet weak var SegmentoUnidadMedida: UISegmentedControl!
    @IBOutlet weak var SegmentoUnidadPeso: UISegmentedControl!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var txtIFR: UISwitch!
    @IBOutlet weak var lbIFR: UILabel!
    @IBOutlet weak var pickerFecha: UIDatePicker!
    
    
    let effect = UIBlurEffect(style: .dark)
    let resizingMask: UIViewAutoresizing = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:10, 10:11, 11:12, 12:13, 13:14, 14:17, 17:18, 18:19, 19:20, 20:0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtBitacora.delegate = self
        txtCliente.delegate = self
        txtFecha.delegate = self
        txtUTCLlega.delegate = self
        txtUTCSale.delegate = self
        txtTV.delegate = self
        txtNivelVuelo.delegate = self
        txtSale.delegate = self
        txtLlega.delegate = self
        txtTV.delegate = self
        txtCalzos.delegate = self
        txtHorometroSale.delegate = self
        txtHorometroLlega.delegate = self
        txtCombustibleLlega.delegate = self
        txtCombustibleSale.delegate = self
        txtConsumo.delegate = self
        txtPesoOperacion.delegate = self
        txtPesoCarga.delegate = self
        txtPesoCombustible.delegate = self
        txtPesoDespegue.delegate = self
        txtCliente.delegate = self
        txtNivelVuelo.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtHorometroSale.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtHorometroLlega.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtCombustibleLlega.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtCombustibleSale.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtPesoOperacion.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtPesoCarga.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtPesoCombustible.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtPesoDespegue.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        txtBitacora.addTarget(self, action: #selector(PistonMono_Vuelo_TableViewController.Formatear(_:)), forControlEvents: .editingChanged)
        
        
        UIMenuController.shared.menuItems = nil
        UIMenuController.shared.isMenuVisible = false
        
        
        configurarView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func DisableContextMenu(){
        UIMenuController.shared.menuItems = nil
        UIMenuController.shared.isMenuVisible = false
        
    }
    
    
    
    //MARK: Funciones Locales
    func configurarView(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PistonMono_Vuelo_TableViewController.DismissKeyboard))
        
        let taplong : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PistonMono_Vuelo_TableViewController.DisableContextMenu))
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(taplong)
        
        
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        txtPesoOperacion.text = formatter.string(from: global_var.j_avion_pesooperacion)
        txtPesoDespegue.text = formatter.string(from: global_var.j_avion_pesooperacion)
        lbMTOW.text! =  "MTOW: " + formatter.string(from: NSNumber(global_var.j_avion_mtow))!
        txtPesoDespegue.isEnabled = false
        txtMatricula.isEnabled = false
        txtMatricula.text = global_var.j_avion_matricula
        let numbitacora = (global_var.j_avion_ultimabitacora.intValue + 1)
        txtBitacora.text = "\(numbitacora)"
        txtHorometroSale.text =  formatter.string(from: global_var.j_avion_ultimohorometro)
        SegmentoUnidadPeso.selectedSegmentIndex = Int(global_var.j_avion_unidadpesoavion)
        SegmentoUnidadMedida.selectedSegmentIndex = global_var.j_avion_pesofuel
        if(global_var.j_procedencia == 1){
            self.navigationItem.title = global_var.j_avion_matricula
            self.txtSale.text = global_var.j_avion_ultimodestino.uppercased()
        }
        else{
            
            if(global_var.j_bitacoras_Id != 0){
                //Editar la bitacora registrada
                cargarTramo()
            }else{
                self.navigationItem.title = global_var.j_avion_matricula
                print(global_var.j_vuelo_fecha)
                txtFecha.text = dateformatter.string(from: global_var.j_vuelo_fecha as Date)
                txtCliente.text = global_var.j_vuelo_customername
                txtSale.text = global_var.j_vuelo_aeropuertosale
                txtLlega.text = global_var.j_vuelo_aeropuertollega
                txtUTCSale.text = global_var.j_vuelo_horasale
                txtUTCLlega.text = global_var.j_vuelo_horallega
                calculaTiempoVuelo()
             }
        }
    }
    
    func calculaTiempoVuelo(){
        
        
        if(!txtUTCLlega.text!.isEmpty && !txtUTCSale.text!.isEmpty)
        {
            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "HH:mm"
            //dateFormatter.stringFromDate(date)
            
            let sale = dateFormatter.string(from: dateFormatter.date(from: txtUTCSale.text!)!)
            let llega = dateFormatter.string(from: dateFormatter.date(from: txtUTCLlega.text!)!)
            //let ssale = sale.substringToIndex(sale.startIndex.advancedBy(5))
            //let sllega = llega.substringToIndex(llega.startIndex.advancedBy(5))
            
            print(sale)
            print(llega)
            
            var HoraSaleSplit : [String] =  sale.split(":")
            var HoraLlegaSplit : [String] = llega.split(":")
            
            
            if(HoraSaleSplit.count > 1 && HoraLlegaSplit.count > 1){
                
                let horasSale = HoraSaleSplit[0]
                let minutosSale = HoraSaleSplit[1].substring(to: HoraSaleSplit[1].characters.index(HoraSaleSplit[1].startIndex, offsetBy: 2))
                
                let minutosLlega = HoraLlegaSplit[1].substring(to: HoraLlegaSplit[1].characters.index(HoraLlegaSplit[1].startIndex, offsetBy: 2))
                let horasLlega = HoraLlegaSplit[0]
                
                var DiferenciaHoras : Int = 0
                var DiferenciaMinutos : Int = 0
                
                if(Int(horasLlega) < Int(horasSale)){
                    
                    //Tengo que realizar un operaciones temporal
                    DiferenciaHoras = (24 - Int(horasSale)!) + Int(horasLlega)!
                    
                }else if (Int(horasLlega) >= Int(horasSale)){
                    
                    DiferenciaHoras = Int(horasLlega)! - Int(horasSale)!
                }
                
                if minutosLlega < minutosSale{
                    DiferenciaHoras -= 1
                    DiferenciaMinutos = (Int(minutosLlega)! - Int(minutosSale)!) + 60
                }
                else{
                    DiferenciaMinutos = Int(minutosLlega)! - Int(minutosSale)!
                }
                formatter.minimumIntegerDigits = 2
                txtCalzos.text = "\(formatter.string(from: NSNumber(DiferenciaHoras))!):\(formatter.string(from: DiferenciaMinutos)!)"
                
                txtHorometroLlega.becomeFirstResponder()
                
            }
        }
        
    }
    
    @IBAction func mostrarHora(_ sender: UITextField) {
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        datePickerView.backgroundColor = UIColor.white
        time_set = sender.tag
        
        let toolbar  : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PistonMono_Vuelo_TableViewController.cancelButtonPressed(_:)))
        let flexible : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: "")
        let doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(PistonMono_Vuelo_TableViewController.TimedoneButtonPressed(_:)))
        
        toolbar.setItems([cancelButton,flexible,doneButton], animated: true)
        
        
        sender.inputView = datePickerView
        
        sender.inputAccessoryView = toolbar
        
        
    }
    @IBAction func muestraFecha(_ sender: UITextField) {
        
        
        DatePickerDialog().show("Fecha del Vuelo", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:UIDatePickerMode.date) {
            (date) -> Void in
            sender.text = self.dateformatter.string(from: date)
            
        }
    }
    
    @IBAction func mostrarFecha(_ sender: UITextField) {
    
       	sender.resignFirstResponder()
        DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:UIDatePickerMode.date) {
            (date) -> Void in
            sender.text = self.dateformatter.string(from: date)
            
        }
    }

    func cancelButtonPressed(_ sender: UIDatePicker){
         self.view.endEditing(true)
    }
    
    func doneButtonPressed(_ sender: AnyObject){
        
        print(datePickerView.date)
        txtFecha.text = dateformatter.string(from: datePickerView.date)
        self.view.endEditing(true)
        txtCliente.becomeFirstResponder()
    }
    
    func TimedoneButtonPressed( _ sender: AnyObject){
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.dateFormat = "HH:mm"
        //let timeZone = NSTimeZone(name: "UTC")
        //timeFormatter.timeZone = timeZone
        
        
        print(timeFormatter.string(from: datePickerView.date))
        
        if time_set == 7 {
            txtUTCSale.text = timeFormatter.string(from: datePickerView.date)
        }
        else if time_set == 8{
            txtUTCLlega.text = timeFormatter.string(from: datePickerView.date)
        }
        self.view.endEditing(true)
        calculaTiempoVuelo()
    }
    
    @IBAction func txtHorometros(_ sender: UITextField) {
        
        if(!txtHorometroSale.text!.isEmpty && !txtHorometroLlega.text!.isEmpty){
            	calcularHorometro(false)
        }
    }
    
    @IBAction func calcularAlSalir(_ sender: AnyObject) {
        
        if(!txtHorometroSale.text!.isEmpty && !txtHorometroLlega.text!.isEmpty){
            calcularHorometro(false)
        }
        
    }
    
    
    @IBAction func txtTV(_ sender: UITextField) {
        if(!txtTV.text!.isEmpty){
            calcularHorometro(true)
        }
    }
    
    
    func calcularHorometro(_ tipo: Bool){
        
        self.tiempoVueloHorometro = 0
        
        var HorometroSale : Float = 0
        var HorometroLlega : Float = 0
        var TV : Float = 0
        
        txtHorometroSale.text = txtHorometroSale.text!.replacingOccurrences(of: ",", with: "")
        txtHorometroLlega.text = txtHorometroLlega.text!.replacingOccurrences(of: ",", with: "")
        
        
        if tipo == false {
            //Calcular Tiempo de Vuelo -> Restar Llegada - Salida
            if let horometrosale = formatter.number(from: txtHorometroSale.text! as String)?.floatValue{
                HorometroSale = horometrosale
            }else{
                HorometroSale = 0
            }
            
            
            if let horometrollega = formatter.number(from: txtHorometroLlega.text! as String)?.floatValue {
                HorometroLlega = horometrollega
            }else{
                HorometroLlega = 0
            }
            
            tiempoVueloHorometro = HorometroLlega - HorometroSale
            
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .decimal
            txtTV.text = ""
            txtTV.text = "\(formatter.string(from: NSNumber(tiempoVueloHorometro))!)"
            Formatear(txtHorometroSale)
            Formatear(txtHorometroLlega)
            
        }
        else{
            //Calcular Horometro de Llegada
            if let horometrosale = formatter.number(from: txtHorometroSale.text! as String)?.floatValue{
                HorometroSale = horometrosale
            }else{
                HorometroSale = 0
            }
            
            if let tv = formatter.number(from: txtTV.text! as String)?.floatValue {
                TV = tv
            }else{
                TV = 0
            }
            HorometroLlega = HorometroSale + TV
            
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .decimal
            txtHorometroLlega.text = ""
            txtHorometroLlega.text = "\(formatter.string(from: NSNumber(HorometroLlega))!)"
            Formatear(txtHorometroLlega)
            Formatear(txtHorometroSale)
        }
    }
    
    
    
    @IBAction func btnMostrarUTCSale(_ sender: AnyObject) {
        
        let timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        self.txtUTCSale.text! = dateFormatter.string(from: date)
        
    }
    
    @IBAction func btnMostrarUTCLlega(_ sender: AnyObject) {
        
        let timeZone = TimeZone(identifier: "UTC")
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "HH:mm"
        self.txtUTCLlega.text = dateFormatter.string(from: date)
        
        
        calculaTiempoVuelo()
    }
    
    
    //MARK: TextField Delegate

    override func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let nextTag = nextField[textField.tag]
        self.view.viewWithTag(nextTag!)?.becomeFirstResponder()
        GuardarInformacion()
        if(nextTag == 19){
            btnGuardar.sendActions(for: .touchUpInside)
        }
        return false

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       
        let cs : CharacterSet!
        let str: String = textField.text!
        let f : NumberFormatter = NumberFormatter();
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        
        if(textField.tag != 0 && textField.tag != 2 && textField.tag != 3 && textField.tag != 4 && textField.tag != 5 ){
            
            if textField.tag == 6{
                cs = CharacterSet(charactersIn: "1234567890.").inverted
            }
            else if(textField.tag == 7 && textField.tag == 8 && textField.tag == 9){
                
                cs = CharacterSet(charactersIn: "1234567890:").inverted
            }
            else{
                if str.characters.count < 1{
                    cs = CharacterSet(charactersIn: "1234567890").inverted
                }else{
                    cs = CharacterSet(charactersIn: "1234567890.").inverted
                }
            }
            
            let components = string.components(separatedBy: cs)
            let filtered = components.joined(separator: "")
            
            
            if filtered != "." {
                
                let oldText: NSString = textField.text! as NSString
                var newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
                
                newText = newText.replacingOccurrences(of: ",", with: "") as NSString
               
            }
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField === txtUTCSale){
            tagUTC = 0
            
        }else if(textField === txtUTCLlega){
            tagUTC = 1
            
        }
        else if(textField === txtCalzos){
            calculaTiempoVuelo()
        }
        else if(textField === txtPesoCombustible){
            txtCombustibleConsumo(textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var editable = false
  
        if(textField == txtCalzos || textField == txtConsumo || textField == txtPesoOperacion || textField == txtPesoDespegue){
            editable = false
        }else if(textField === txtFecha){
            textField.resignFirstResponder()
            DatePickerDialog().show("Fecha del Vuelo", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:UIDatePickerMode.date) {
                (date) -> Void in
                textField.text = self.dateformatter.string(from: date)
                self.GuardarInformacion()
                self.txtCliente.becomeFirstResponder()
            }
        }else if(textField === txtUTCSale || textField === txtUTCLlega){
            textField.resignFirstResponder()
            var titulo = ""
            if (textField === txtUTCSale){
                titulo = "Hora Local Salida"
            }
            else{
                titulo = "Hora Local Llegada"
            }
            DatePickerDialog().show(titulo, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:UIDatePickerMode.time) {
                (time) -> Void in
                let formatohora : DateFormatter = DateFormatter()
                formatohora.timeZone = TimeZone(identifier: "UTC")
                formatohora.dateFormat = "HH:mm"
                textField.text = formatohora.string(from: time)
            	self.calculaTiempoVuelo()
                self.GuardarInformacion()
                
            }
        }
        else{
            editable = true
        }
        return editable
    }
    
    @IBAction func mostrarMenu(_ sender: AnyObject) {
        
        let mensaje = "Se cerrará la bitácora con el folio: ** " + txtBitacora.text! + " ** "
        
        let alertController = UIAlertController(title: "Aerotron", message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .,default){ action -> Void in
        
            if (global_var.j_bitacora_abierta == 1){
             
                self.GuardarInformacion()
                
                if(global_var.j_bitacoras_Id == 0){
                    //La esta cerrando sin registrar otros vistas
                    self.GuardarTramo()
                }
                
                let Status = self.coreDataStack.verificaBitacoraPorCerrar(global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                
                //Cierro la bitacora para la sincronizacion
                if(Status == "Sin Error"){
                    
                    self.GuardarInformacion()
                    
                    self.coreDataStack.cerrarBitacora(global_var.j_bitacoras_Id, matricula: global_var.j_avion_matricula)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "sincronizarBitacoras"), object: nil)
                    Util.invokeAlertMethod("Bitacora Cerrada", strBody: "Estara en proceso de sincronización.", delegate: self)
                    self.regresarABitacoras()
                }else{
                    Util.invokeAlertMethod("Error", strBody: "Verifica \(Status)", delegate: self)
                    if let tabBarController = self.tabBarController {
                        tabBarController.selectedIndex = 0
                    }
                    
                }
            }
            else{
                
                 Util.invokeAlertMethod("Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler: nil)
        
        //alertController.addAction(saveAction)
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: Combustibles
    
    //Calcula consumo de combustible
    
    func txtCombustibleConsumo(_ sender: AnyObject) {
        self.combustibleSale = 0
        self.combustibleLLega = 0
        self.combustibleConsumo = 0
        
        if(!txtCombustibleSale.text!.isEmpty){
            txtCombustibleSale.text =  txtCombustibleSale.text!.replacingOccurrences(of: ",", with: "")
            if let cs = formatter.number(from: txtCombustibleSale.text! as String)?.floatValue {
                self.combustibleSale = cs
            }else{
                self.combustibleSale = 0
            }
            
        }
        
        if(!txtCombustibleLlega.text!.isEmpty){
            txtCombustibleLlega.text =  txtCombustibleLlega.text!.replacingOccurrences(of: ",", with: "")
            if let cl = formatter.number(from: txtCombustibleLlega.text! as String)?.floatValue {
                self.combustibleLLega = cl
            }
            else{
                self.combustibleLLega = 0
            }
        }
        
        calculaConsumoCombustible()
        
        
        txtPesoCombustible.text! = util.calculaPesoCombustible(self.combustibleSale, unidadfuel: SegmentoUnidadMedida.selectedSegmentIndex, unidadpesofuel: global_var.j_avion_unidadpesoavion)
        
        txtPesos(txtPesoCombustible)
    }
    
    func calculaConsumoCombustible(){

        if (combustibleLLega > combustibleSale) {
            
            Util.invokeAlertMethod("Error", strBody: "Combustible de llegada no puede ser mayor a al combustible de salida", delegate: self)
            txtCombustibleLlega.text = ""
            txtCombustibleLlega.becomeFirstResponder()
            
        }
        else{
            
            self.combustibleConsumo = self.combustibleSale - self.combustibleLLega
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .decimal
            txtConsumo.text = "\(formatter.string(from: NSNumber(self.combustibleConsumo))!)"
            
        }
        
    }
    
    func SegmentoUnidadMedida(_ sender: AnyObject) {
        if(self.combustibleSale>0){
            txtPesoCombustible.text! = util.calculaPesoCombustible(self.combustibleSale, unidadfuel: SegmentoUnidadMedida.selectedSegmentIndex, unidadpesofuel: Int(global_var.j_avion_unidadpesoavion))
            
            txtPesos(txtPesoCombustible)
            
            
        }else{
            txtPesoCombustible.text! = "0"
        }
    }
    
    func SegmentoUnidadPeso(_ sender: AnyObject) {
        if(self.combustibleSale>0){
            txtPesoCombustible.text = util.calculaPesoCombustible(self.combustibleSale, unidadfuel: SegmentoUnidadMedida.selectedSegmentIndex, unidadpesofuel: global_var.j_avion_unidadpesoavion)
            
           txtPesos(txtPesoCombustible)
            
        }else{
            txtPesoCombustible.text = "0"
        }
    }
    
    //MARK: - Pesos
    
    func txtPesos(_ sender: AnyObject) {
        
        self.pesoDespegue  = 0
        
        calcularPeso()
        
    }
    
    func calcularPeso(){
        
        
        self.pesoOperacion = 0
        self.pesoCombustible = 0
        self.pesoCarga = 0
        self.pesoDespegue = 0
        
        if(!txtPesoOperacion.text!.isEmpty){
                if let po = formatter.number(from: txtPesoOperacion.text! as String)?.floatValue {
                    self.pesoOperacion = po
                }
        }
        
        if(!txtPesoCombustible.text!.isEmpty){
            if let pc = formatter.number(from: txtPesoCombustible.text! as String)?.floatValue {
                    self.pesoCombustible = pc
            }
        }
        
        if(!txtPesoCarga.text!.isEmpty){
            if let pc = formatter.number(from: txtPesoCarga.text! as String)?.floatValue {
                self.pesoCarga = pc
            }
        }
        
        if global_var.j_avion_matricula.uppercased() == "XAUQK" {
            
            self.pesoDespegue =  ((self.pesoOperacion) + (self.pesoCarga) + (self.pesoCombustible)) - 15
        }
        else{
        
            self.pesoDespegue =  (self.pesoOperacion) + (self.pesoCarga) + (self.pesoCombustible)
            
        }
        let f : NumberFormatter = NumberFormatter()
        f.decimalSeparator = "."
        f.maximumFractionDigits = 1
        f.numberStyle = .decimal
        txtPesoDespegue.backgroundColor = UIColor.white
        txtPesoDespegue.text = "\(f.string(from: NSNumber(self.pesoDespegue))!)"
        
    }
    
    
    
    
    //MARK: Tramos

    func cargarTramo(){
        
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        
        let fetchRequest = NSFetchRequest(entityName: "BitacorasLegs")
        let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [global_var.j_bitacoras_Id, global_var.j_avion_matricula])
        fetchRequest.predicate = predicate
        
        
        do{
            let fetchResults =  try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [BitacorasLegs]
            if let aviones = fetchResults{
                for row in aviones{
                    txtSale.text = row.origen!.uppercased()
                    txtLlega.text = row.destino!.uppercased()
                    let _nivelvuelo = row.nivelvuelo
                    txtNivelVuelo.text =  formatter.string(from: _nivelvuelo!)
                    txtUTCSale.text! = row.horasalida!
                    txtUTCLlega.text! = row.horallegada!
                    let _calzos = row.calzoacalzo
                    txtCalzos.text = "\(_calzos!)"
                    let _hsale = row.horometrodespegue
                    let _hllega = row.horometroaterrizaje
                    txtHorometroLlega.text = formatter.string(from: _hllega!)
                    txtHorometroSale.text = formatter.string(from: _hsale!)
                    let _tv = row.tv
                    txtTV.text = formatter.string(from: _tv!)
                    let _combSale = row.combustibledespegue
                    let _combLlega = row.combustibleaterrizaje
                    let _combConsumido = row.combustibleconsumido
                    txtCombustibleSale.text = formatter.string(from: _combSale!)
                    txtCombustibleLlega.text = formatter.string(from: _combLlega!)
                    txtConsumo.text = formatter.string(from: _combConsumido!)
                    let _pesocarga = row.pesocarga
                    let _pesocombustible = row.pesocombustible
                    let _pesoDespegue = row.pesodespegue
                    txtPesoCarga.text = formatter.string(from: _pesocarga!)
                    txtPesoCombustible.text =  formatter.string(from: _pesocombustible!)
                    txtPesoDespegue.text =  formatter.string(from: _pesoDespegue!)
                    txtBitacora.text = "\(global_var.j_bitacora_num)"
                    txtFecha.text = dateformatter.string(from: global_var.j_bitacora_fecha)
                    txtCliente.text = global_var.j_bitacora_cliente
                    global_var.j_tramos_Id = row.idtramo!
                    IFR = (global_var.j_bitacoras_ifr).floatValue
                    calcularPeso()
                }
                
                
                if global_var.j_bitacoras_ifr == 1 {
                    self.txtIFR.setOn(true, animated: true)
                    IFRChanged(self.txtIFR)
                }else{
                    self.txtIFR.setOn(false, animated: true)
                    IFRChanged(self.txtIFR)
                }
                
            }
        }catch let error as NSError{
            Util.invokeAlertMethod("Error2", strBody: error.description, delegate: self)
        }
    }
    
    func GuardarTramo(){
        
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        
        var _calzos : String =  "0000"
        var _combustiblellega : NSNumber = 0
        var _combustiblesale : NSNumber = 0
        var _combustibleconsumo : NSNumber = 0
        var _horometrosale :NSNumber = 0
        var _horometrollega : NSNumber = 0
        var _nivelvuelo  : NSNumber = 0
        var _pesodespegue : NSNumber = 0
        var _pesooperacion :NSNumber = 0
        var _pesocombustible : NSNumber = 0
        var _pesocarga : NSNumber = 0
        var _TV : NSNumber = 0
        
        var _ultimohorometro : NSNumber = 0
        var _ultimohorometroapu : NSNumber = 0
        var _ultimabitacora : NSNumber = 0
        
        
        if(!txtHorometroLlega.text!.isEmpty){
            if let cc = formatter.number(from: txtHorometroLlega.text! as String)?.floatValue {
                _ultimohorometro = NSNumber(cc)
            }else{
                txtHorometroLlega.text = "0"
            }
        }
        
        if(!txtBitacora.text!.isEmpty){
            if let cc = formatter.number(from: txtBitacora.text! as String)?.floatValue {
                _ultimabitacora = NSNumber(cc)
            }else{
                txtBitacora.text = "0"
            }
        }
        
        if(!txtCalzos.text!.isEmpty){
            _calzos = (txtCalzos.text! as NSString) as String
        }
        if(!txtCombustibleLlega.text!.isEmpty){
            if let cc = formatter.number(from: txtCombustibleLlega.text! as String)?.floatValue {
                _combustiblellega = NSNumber(cc)
            }else{
                txtCombustibleLlega.text = ""
            }
        }
        if(!txtCombustibleSale.text!.isEmpty){
            if let cc = formatter.number(from: txtCombustibleSale.text! as String)?.floatValue {
                _combustiblesale = NSNumber(cc)
            }else{
                txtCombustibleSale.text = ""
            }
        }
        if(!txtConsumo.text!.isEmpty){
            if let cc = formatter.number(from: txtConsumo.text! as String)?.floatValue {
                _combustibleconsumo = NSNumber(cc)
            }else{
                txtConsumo.text = ""
            }
        }
        if(!txtHorometroLlega.text!.isEmpty){
            if let cc = formatter.number(from: txtHorometroLlega.text! as String)?.floatValue {
                _horometrollega = NSNumber(cc)
            }else{
                txtHorometroLlega.text = ""
            }
        }
        if(!txtHorometroSale.text!.isEmpty){
            if let cc = formatter.number(from: txtHorometroSale.text! as String)?.floatValue {
                _horometrosale = NSNumber(cc)
            }else{
                txtHorometroSale.text = ""
            }
        }
        if(!txtNivelVuelo.text!.isEmpty){
            if let cc = formatter.number(from: txtNivelVuelo.text! as String)?.floatValue {
                _nivelvuelo = NSNumber(cc)
            }else{
                txtNivelVuelo.text = ""
            }
        }
        if(!txtPesoCombustible.text!.isEmpty){
            if let cc = formatter.number(from: txtPesoCombustible.text! as String)?.floatValue {
                _pesocombustible = NSNumber(cc)
            }else{
                txtPesoCombustible.text = ""
            }
        }
        if(!txtPesoDespegue.text!.isEmpty){
            if let cc = formatter.number(from: txtPesoDespegue.text! as String)?.floatValue {
                _pesodespegue = NSNumber(cc)
            }else{
                txtPesoDespegue.text = ""
            }
        }
        if(!txtPesoOperacion.text!.isEmpty){
            if let cc = formatter.number(from: txtPesoOperacion.text! as String)?.floatValue {
                _pesooperacion = NSNumber(cc)
            }else{
                txtPesoOperacion.text = ""
            }
        }
        if(!txtPesoCarga.text!.isEmpty){
            if let cc = formatter.number(from: txtPesoCarga.text! as String)?.floatValue {
                _pesocarga = NSNumber(cc)
            }else{
                txtPesoCarga.text = ""
            }
        }
        if(!txtTV.text!.isEmpty){
            if let cc = formatter.number(from: txtTV.text! as String)?.floatValue {
                _TV = NSNumber(cc)
            }else{
                txtTV.text = ""
            }
        }
        
        
        
        
        if(self.pesoDespegue > global_var.j_avion_mtow){
            
            self.txtPesoDespegue.text = "\(self.pesoDespegue)"
            
            let diferencia = self.pesoDespegue   - global_var.j_avion_mtow
            
            txtPesoDespegue.backgroundColor = UIColor.red
            
            Util.invokeAlertMethod("Alerta", strBody: "Excedes MTOW ( \(diferencia) ), verifica la información", delegate: self)
            
        }else{
            
            GuardarBitacora()
            
            if(global_var.j_bitacoras_Id != 0){
                
                if(global_var.j_tramos_Id == 0){
                    
                    global_var.j_tramos_Id = coreDataStack.obtenerIdTramo()
                    
                    coreDataStack.agregarTramo(0, aceitecargadoapu: 0, calzoacalzo: _calzos, capitan_altimetrorvsm: 0, combustibleaterrizaje: _combustiblellega, combustiblecargado: 0, combustibleconsumido: _combustibleconsumo, combustibledespegue: _combustiblesale, coordenadasregistradas: "", destino: txtLlega.text!.uppercased(), destinociudad: txtLlega.text!.uppercased(), horallegada: txtUTCLlega.text!, horasalida: txtUTCSale.text!, horometroaterrizaje: _horometrollega, horometrodespegue: _horometrosale, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nivelvuelo: _nivelvuelo, numbitacora: Int((txtBitacora.text!))!, oat: 0, origen: txtSale.text!.uppercased(), origenciudad: txtSale.text!.uppercased(), pesoaterrizaje: 0 , pesocarga: _pesocarga, pesocombustible: _pesocombustible, pesodespegue: _pesodespegue, pesoperacion: _pesooperacion, primeroficialaltimetrorvsm: "", tv: _TV, combustibleunidadmedida: "\(SegmentoUnidadMedida.selectedSegmentIndex)", combustibleunidadpeso: "\(global_var.j_avion_unidadpesofuel)", matricula: global_var.j_avion_matricula)
                    
                    //Agregar los pax de la tabla de vuelos a la tabla de bitacoras
                    coreDataStack.agregarPasajeroDeVuelosABitacoras(global_var.j_bitacora_legid, idbitacora: global_var.j_bitacoras_Id, idtramo: global_var.j_tramos_Id, matricula: global_var.j_avion_matricula)
                    
                }else{
                    
                    coreDataStack.actualizaTramo(0, aceitecargadoapu: 0, calzoacalzo: _calzos, capitan_altimetrorvsm: 0, combustibleaterrizaje: _combustiblellega, combustiblecargado: 0, combustibleconsumido: _combustibleconsumo, combustibledespegue: _combustiblesale, coordenadasregistradas: "", destino: txtLlega.text!.uppercased(), destinociudad: txtLlega.text!.uppercased(), horallegada: txtUTCLlega.text!, horasalida: txtUTCSale.text!, horometroaterrizaje: _horometrollega, horometrodespegue: _horometrosale, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nivelvuelo: _nivelvuelo, numbitacora: Int((txtBitacora.text!))!, oat: 0, origen: txtSale.text!.uppercased(), origenciudad: txtSale.text!.uppercased(), pesoaterrizaje: 0 , pesocarga: _pesocarga, pesocombustible: _pesocombustible, pesodespegue: _pesodespegue, pesoperacion: _pesooperacion, primeroficialaltimetrorvsm: "", tv: _TV,combustibleunidadmedida: "\(SegmentoUnidadMedida.selectedSegmentIndex)", combustibleunidadpeso: "\(global_var.j_avion_unidadpesofuel)", matricula: global_var.j_avion_matricula)
                }
                
                //coreDataStack.actualizaUltimaInformacion(txtMatricula.text!, ultimabitacora: _ultimabitacora, ultimodestino: txtLlega.text!, ultimohorometro: _ultimohorometro, ultimohorometroapu: _ultimohorometroapu, sincronizado: 0)
            }
            else{
                Util.invokeAlertMethod("Error", strBody: "Es necesario primero registrar la bitácora, consulta al administrador", delegate: self)
            }
        }
    }
     	
    //MARK: - Bitacora
    
    func GuardarBitacora(){
        
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let FechaRegistro = date
        var FechaVuelo = date
        
        if (!txtFecha.text!.isEmpty){
            FechaVuelo = dateformatter.date(from: txtFecha.text!)!
        }
        
        
        global_var.j_avion_ultimabitacora = Int(txtBitacora.text!)!
        
        if global_var.j_bitacoras_Id == 0 { //Agregar nueva bitacora
            
            global_var.j_bitacoras_Id = NSNumber((txtBitacora.text! as NSString).integerValue)
            
            if(!coreDataStack.obtenerIdBitacora(global_var.j_avion_matricula, numbitacora: (txtBitacora.text! as NSString).integerValue)){
                
                coreDataStack.agregarBitacora("", aterrizajes: 0, capitan: String(global_var.j_usuario_idPiloto), capitannombre: global_var.j_usuario_nombre, ciclos: 0, ciclosapu: 0, cliente: txtCliente.text!, copiloto: "", copilotonombre: "", fecharegistro: FechaRegistro, fechavuelo:  FechaVuelo, horometroapu: 0, horometrollegada: 0, horometrosalida: 0, hoy: 0, idbitacora: global_var.j_bitacoras_Id , idservidor: 0, ifr: IFR, legid: (global_var.j_vuelo_legid as NSString).integerValue, licenciatecnico: "", mantenimientodgac: "", mantenimientointerno: "", matricula: global_var.j_avion_matricula, nocturno: "", nombretecnico: "", numbitacora: (txtBitacora.text! as NSString).integerValue, quienprevuelo: "", reportes: "", serie: "", sincronizado: 0, status: 1, totalaterrizaje: 0, tv: 0, modificada: global_var.j_bitacora_modificada, modificadatotal: global_var.j_bitacora_nummodificada, prevuelolocal:  0)

                global_var.j_bitacora_num = NSNumber((txtBitacora.text! as NSString).integerValue)
                global_var.j_bitacora_abierta = 1
                print("Se registro Bitacora con  ID: \(global_var.j_bitacoras_Id)")
                
                //Actualizo el vuelo a realizado
                coreDataStack.actualizaVueloRealizado(global_var.j_vuelo_legid)
            }else{
                Util.invokeAlertMethod("Error", strBody: "El numero de bitacora ya existe, verifica los datos", delegate: self)
                global_var.j_bitacoras_Id  = 0
                
            }
            
        }else{
            
            print("Se actualizo Bitacora con ID: \(global_var.j_bitacoras_Id)")
            
            coreDataStack.actualizarBitacora("", aterrizajes: 0, capitan: String(global_var.j_usuario_idPiloto), capitannombre: global_var.j_usuario_nombre, ciclos: 0, ciclosapu: 0, cliente: txtCliente.text!, copiloto: "", copilotonombre: "", fecharegistro: FechaRegistro, fechavuelo: dateformatter.date(from: txtFecha.text!)!, horometroapu: 0, horometrollegada: 0, horometrosalida: 0, hoy: 0, idbitacora: global_var.j_bitacoras_Id , idservidor: 0, ifr: IFR, legid: (global_var.j_vuelo_legid as NSString).integerValue, licenciatecnico: "", mantenimientodgac: "", mantenimientointerno: "", matricula: global_var.j_avion_matricula, nocturno: "", nombretecnico: "", numbitacora: (txtBitacora.text! as NSString).integerValue, quienprevuelo: "", reportes: "", serie: "", sincronizado: 0, status: 1, totalaterrizaje: 0, tv: 0, modificada: global_var.j_bitacora_modificada, modificadatotal:  global_var.j_bitacora_nummodificada, prevuelolocal:  0)
            
        }
        
    }

    func btnCancelar(_ sender: AnyObject) {
        regresarABitacoras()
    }
    
    func regresarABitacoras() {
        
        let destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destviewcontroller : UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.present(destviewcontroller, animated: true, completion: nil)
        
    }
    
    
    func btnGuardar(_ sender: AnyObject) {
        
        GuardarInformacion()
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    func GuardarInformacion(){
        if global_var.j_bitacora_abierta == 1 {
            self.GuardarTramo()
            self.btnCancelar.title = "Ir a Bitácoras"
        }else{
            Util.invokeAlertMethod("Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
        }
    }
    
    func IFRChanged(_ sender: AnyObject) {
        if txtIFR.isOn {
            lbIFR.text = "I.F.R.:"
            IFR = 1
        }
        else{
            lbIFR.text = "V.F.R.:"
            IFR = 0
        }
    }
    
    func Formatear(_ textField: UITextField){
        
        textField.text = textField.text!.replacingOccurrences(of: ",", with: "")
        let f : NumberFormatter = NumberFormatter();
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        
        let str = textField.text!
        
        if (str != ""){
            
            let lastChar = str.characters.last!
            if(textField.text!.characters.count < 11){
                
                if(textField === txtBitacora){
                    
                    if(lastChar >= "0" && lastChar <= "9"){
                        print("solo numero")
                    }else{
                        textField.text = textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                    }
                    
                }else{
                    if (lastChar != "." && lastChar != "-") {
                        
                        if (textField.text! as String).range(of: ".0") != nil {
                            print(textField.text!)
                            if (lastChar != "0"){
                                if let formateado = f.number(from: textField.text!) {
                                    textField.text = f.string(from: formateado)!
                                }
                                else{
                                    textField.text = textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                                }
                            }
                        }else{
                            
                            if let formateado = f.number(from: textField.text!) {
                                textField.text = f.string(from: formateado)!
                            }else{
                                textField.text = textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                            }
                            
                        }
                    }
                }
            }
            else{
                
                textField.text = textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                
                if(textField != txtBitacora){
                    if let formateado = f.number(from: textField.text!) {
                        textField.text = f.string(from: formateado)!
                    }else{
                        textField.text = textField.text!.substring(to: textField.text!.characters.index(before: textField.text!.endIndex))
                    }
                }
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let titulo = ""
        var kglbs = ""
        print("Unidad :\(global_var.j_avion_unidadpesoavion)")
        if global_var.j_avion_unidadpesoavion == 0 {
            kglbs = "LBS"
        }
        else{
            kglbs = "KG"
        }
        
        switch(section){
        case 0:
            return "VUELO"
        case 1:
            return "RUTA"
        case 2:
            return "TIEMPOS"
        case 3:
            return "COMBUSTIBLES"
        case 4:
            return "PESOS EN " + kglbs
        default:
            break
        }
        
        return titulo
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var altura : CGFloat = 0
        if DeviceType.IS_IPAD{
            altura =  90
        }else if DeviceType.IS_IPHONE_6{
            altura =  60
        }
        
        return altura
    }
}
