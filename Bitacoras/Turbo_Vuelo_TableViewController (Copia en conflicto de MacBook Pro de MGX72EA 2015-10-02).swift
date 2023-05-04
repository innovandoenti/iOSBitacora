//
//  Turbo_Vuelo_TableViewController.swift
//  Bitacoras
//
//  Created by Jaime Solis on 29/07/15.
//  Copyright (c) 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit
import CoreData

class Turbo_Vuelo_TableViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate {

    let coreDataStack = CoreDataStack()
    
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
    var totalArray : NSMutableArray = NSMutableArray()
    let formatter : NSNumberFormatter = NSNumberFormatter()
    var logica = Util()
    var datePickerView : UIDatePicker = UIDatePicker()
    var dt : NSMutableArray = NSMutableArray()
    var date = NSDate();
    var dateFormatter = NSDateFormatter()
    var dateformatter : NSDateFormatter = NSDateFormatter()
    
    @IBOutlet weak var btnCancelar: UIBarButtonItem!
    @IBOutlet weak var btnShowMenu: UIBarButtonItem!
    
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
    @IBOutlet weak var txtPesoAterrizaje: UITextField!
    @IBOutlet weak var txtCombustibleCargado: UITextField!
    
    
    @IBOutlet weak var SegmentoUnidadMedida: UISegmentedControl!
    @IBOutlet weak var SegmentoUnidadPeso: UISegmentedControl!
    let nextField = [0:1, 1:2, 2:3, 3:4, 4:5, 5:6, 6:7, 7:8, 8:9, 9:10, 10:11, 11:12, 12:13, 13:14, 14:15, 15:16, 16:17, 17:18, 18:19, 19:20, 20:21, 21:22, 22:23, 23:0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        global_var.j_tramos_Id = 0
        
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat = "dd/MM/yyyy"
        
        configurarView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Funciones Locales
    func configurarView(){
        
        
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
        txtPesoOperacion.text = formatter.stringFromNumber(global_var.j_avion_pesooperacion)
        txtPesoDespegue.text = formatter.stringFromNumber(global_var.j_avion_pesooperacion)
        txtCombustibleCargado.delegate = self
        
        lbMTOW.text =  "MTOW: \(global_var.j_avion_mtow)"
        
        txtMatricula.enabled = false
        txtMatricula.text = global_var.j_avion_matricula
        var numbitacora = (global_var.j_avion_ultimabitacora.integerValue + 1)
        txtBitacora.text = "\(numbitacora)"
        txtHorometroSale.text = "\(global_var.j_avion_ultimohorometro)"
        txtHorometroLlega.text = "0"
        
        
        if(global_var.j_procedencia == 1){
            self.navigationItem.title = "Vuelo"
            self.txtSale.text = global_var.j_avion_ultimodestino
            
        }
        else{
            
            if(global_var.j_bitacoras_Id != 0){
                
                //Editar la bitacora registrada
                cargarTramo()
                
                
            }else{
                
                self.navigationItem.title = global_var.j_avion_matricula
                
                
                txtFecha.text = dateformatter.stringFromDate(global_var.j_vuelo_fecha)
                txtCliente.text = global_var.j_vuelo_customername
                txtSale.text = global_var.j_vuelo_aeropuertosale
                txtLlega.text = global_var.j_vuelo_aeropuertollega
                txtUTCSale.text = global_var.j_vuelo_horasale
                txtUTCLlega.text = global_var.j_vuelo_horallega
                
                calculaTiempoVuelo()
            }
            
        }
    }
    
    @IBAction func mostrarFecha(sender: UITextField) {
        
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.backgroundColor = UIColor.whiteColor()
        
        
        var toolbar  : UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        
        
        
        var cancelButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelButtonPressed:"))
        var flexible : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: "")
        var doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("doneButtonPressed:"))
        
        toolbar.setItems([cancelButton,flexible,doneButton], animated: true)
        
        
        sender.inputView = datePickerView
        
        sender.inputAccessoryView = toolbar
        
    }
    
    func cancelButtonPressed(sender: UIDatePicker){
        self.view.endEditing(true)
    }
    
    func doneButtonPressed(sender: AnyObject){
        
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat = "dd/MM/yyyy"
        println(datePickerView.date)
        txtFecha.text = dateformatter.stringFromDate(datePickerView.date)
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    
    @IBAction func txtHorometros(sender: AnyObject) {
        
        if(!txtHorometroSale.text.isEmpty && !txtHorometroLlega.text.isEmpty){
            calcularHorometro()
        }
        
    }
    
    func calcularHorometro(){
        
        self.tiempoVueloHorometro = 0
        var horometrosale = (txtHorometroSale.text as NSString).floatValue
        var horometrollega = (txtHorometroLlega.text as NSString).floatValue
        
        tiempoVueloHorometro = horometrollega - horometrosale
        
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .DecimalStyle
        
        txtTV.text = "\(formatter.stringFromNumber(tiempoVueloHorometro)!)"
        
    }
    
    @IBAction func btnMostrarUTCSale(sender: AnyObject) {
        
        let timeZone = NSTimeZone(name: "UTC")
        
        dateFormatter.timeZone = timeZone
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle //Set date style
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        
        self.txtUTCSale.text = dateFormatter.stringFromDate(date)
        
        //calculaTiempoVuelo()
        
        
    }
    
    @IBAction func btnMostrarUTCLlega(sender: AnyObject) {
        
        let timeZone = NSTimeZone(name: "UTC")
        
        dateFormatter.timeZone = timeZone
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle //Set date style
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        
        self.txtUTCLlega.text = dateFormatter.stringFromDate(date)
        
        
        calculaTiempoVuelo()
    }
    
    
    //MARK: TextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        textField.backgroundColor = UIColor.whiteColor()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag = nextField[textField.tag]
        self.view.viewWithTag(nextTag!)?.becomeFirstResponder()
        
        return false
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var regreso : Bool = true
        
        if(textField.tag != 0 && textField.tag != 2 && textField.tag != 3 && textField.tag != 4 && textField.tag != 5 && textField.tag != 12 && textField.tag != 16 && textField.tag != 20 && textField.tag != 24 ){
            
            let cs : NSCharacterSet = NSCharacterSet(charactersInString: "1234567890.-").invertedSet
            
            let components = string.componentsSeparatedByCharactersInSet(cs)
            
            let filtered = join("", components)
            
            regreso = true
            
            return string == filtered
            
        }
        
        return regreso
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(textField === txtUTCSale){
            tagUTC = 0
            
        }else if(textField === txtUTCLlega){
            tagUTC = 1
            
        }
        else if(textField === txtCalzos){
            calculaTiempoVuelo()
        }
        
    }
    
    
    @IBAction func calcularTiempo(sender: UITextField) {
        
        calculaTiempoVuelo()
        
    }
    
    func calculaTiempoVuelo(){
        
        //Calcula Calzo a Calzo
        
        
        
        let MinutosDia = 1440
        var MinutosTiempoVuelo : Int = 0
        
        
        
        if(!txtUTCLlega.text.isEmpty && !txtUTCSale.text.isEmpty)
        {
            
            var HoraSaleSplit : [String] = txtUTCSale.text.split(":")
            var HoraLlegaSplit : [String] = txtUTCLlega.text.split(":")
            
            println(HoraSaleSplit[0])
            println(HoraSaleSplit[1])
            
            var horasSale = HoraSaleSplit[0]
            var minutosSale = HoraSaleSplit[1]
            
            println(horasSale)
            println(minutosSale)
            
            
            var minutosLlega = HoraLlegaSplit[1]
            var horasLlega = HoraLlegaSplit[0]
            
            println(horasLlega)
            println(minutosLlega)
            
            var totalHorasEnMinutos : Int = (horasSale.toInt()!) * 60
            var totalMinutosSale : Int = (minutosSale.toInt()!)
            var T_MinutosSale  = totalHorasEnMinutos + totalMinutosSale
            
            var totalHorasEnMinutosLlega : Int = (horasLlega.toInt()!) * 60
            var totalMinutosLlega : Int = (minutosLlega.toInt()!)
            var T_MinutosLlega  = totalHorasEnMinutosLlega + totalMinutosLlega
            
            
            var DiferenciaHoras : Int = 0
            var DiferenciaMinutos : Int = 0
            
            if(horasLlega.toInt() < horasSale.toInt()){
                
                //Tengo que realizar un operaciones temporal
                DiferenciaHoras = (24 - horasSale.toInt()!) + horasLlega.toInt()!
                
            }else if (horasLlega.toInt() >= horasSale.toInt()){
                
                DiferenciaHoras = horasLlega.toInt()! - horasSale.toInt()!
            }
            
            if minutosLlega < minutosSale{
                DiferenciaHoras -= 1
                DiferenciaMinutos = (minutosLlega.toInt()! - minutosSale.toInt()!) + 60
            }
            else{
                DiferenciaMinutos = minutosLlega.toInt()! - minutosSale.toInt()!
            }
            
            
            formatter.minimumIntegerDigits = 2
            txtCalzos.text = "\(formatter.stringFromNumber(DiferenciaHoras)!):\(formatter.stringFromNumber(DiferenciaMinutos)!)"
            
        }
        
    }
    
    
    @IBAction func mostrarMenu(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Aerotron", message: "Selecciona una opcion", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction: UIAlertAction = UIAlertAction(title: "Guardar y Continuar", style: .Default) { action -> Void in
            
            if global_var.j_bitacora_abierta == 1 {
                
                self.GuardarTramo()
                
            }else{
                
                Util.invokeAlertMethod("Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
            self.btnCancelar.title = "Ir a Bitácoras"
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
            }
            
            
        }
        
        let closeAction : UIAlertAction = UIAlertAction(title: "Cerrar Bitacora", style: .Default){ action -> Void in
            
            if (global_var.j_bitacora_abierta == 1){
                
                
                if(global_var.j_bitacoras_Id == 0){
                    //La esta cerrando sin registrar otros vistas
                    self.GuardarTramo()
                    
                }
                
                //Cierro la bitacora para la sincronizacion
                self.coreDataStack.cerrarBitacora(global_var.j_bitacoras_Id)
                
                NSNotificationCenter.defaultCenter().postNotificationName("sincronizarBitacoras", object: nil)
                
                
                Util.invokeAlertMethod("Bitacora Cerrada", strBody: "Estara en proceso de sincronización.", delegate: self)
                
                self.regresarABitacoras()
                
            }
            else{
                
                Util.invokeAlertMethod("Error", strBody: "No se puede modificar esta bitácora por que esta cerrada", delegate: self)
            }
            
            
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Destructive, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(closeAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    //MARK: Combustibles
    
    //Calcula consumo de combustible
    
    @IBAction func txtCombustibleConsumo(sender: AnyObject) {
        
        self.combustibleSale = (txtCombustibleSale.text as NSString).floatValue
        
        
        
        self.combustibleLLega = (txtCombustibleLlega.text as NSString).floatValue
        
        calculaConsumoCombustible()
        
        if(self.combustibleSale>0){
            txtPesoCombustible.text = logica.calculaPesoCombustible(self.combustibleSale, unidadfuel: SegmentoUnidadMedida.selectedSegmentIndex, unidadpesofuel: SegmentoUnidadPeso.selectedSegmentIndex)
            
            txtPesos(txtPesoCombustible)
            
        }else{
            txtPesoCombustible.text = "0"
        }

        
    }
    
    func calculaConsumoCombustible(){
        
        
        
        if (combustibleLLega > combustibleSale) {
            
            Util.invokeAlertMethod("Error", strBody: "Combustible de llegada no puede ser mayor a al combustible de salida", delegate: self)
            
            txtCombustibleLlega.resignFirstResponder()
            
        }
        else{
            
            self.combustibleConsumo = self.combustibleSale - self.combustibleLLega
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .DecimalStyle
            txtConsumo.text = "\(formatter.stringFromNumber(self.combustibleConsumo)!)"
            
        }
    }
    
    @IBAction func SegmentoUnidadMedida(sender: AnyObject) {
        if(self.combustibleSale>0){
            txtPesoCombustible.text = logica.calculaPesoCombustible(self.combustibleSale, unidadfuel: SegmentoUnidadMedida.selectedSegmentIndex, unidadpesofuel: SegmentoUnidadPeso.selectedSegmentIndex)
            
            txtPesos(txtPesoCombustible)
            
            
        }else{
            txtPesoCombustible.text = "0"
        }
    }
    
    @IBAction func SegmentoUnidadPeso(sender: AnyObject) {
        if(self.combustibleSale>0){
            txtPesoCombustible.text = logica.calculaPesoCombustible(self.combustibleSale, unidadfuel: SegmentoUnidadMedida.selectedSegmentIndex, unidadpesofuel: SegmentoUnidadPeso.selectedSegmentIndex)
            
            txtPesos(txtPesoCombustible)
            
        }else{
            txtPesoCombustible.text = "0"
        }
    }
    
    
    //MARK: - Pesos
    
    //Calcula pesos
    @IBAction func txtPesos(sender: AnyObject) {
        
        self.pesoDespegue  = 0
        
        calcularPeso()
        
        println(txtPesoCombustible.text as NSString)
        println(self.pesoDespegue)
        
        if(self.pesoDespegue > global_var.j_avion_mtow){
            
            self.txtPesoDespegue.text = "\(self.pesoDespegue)"
            
            self.pesoDespegue = self.pesoDespegue   - global_var.j_avion_mtow
            
            txtPesoDespegue.backgroundColor = UIColor.redColor()
            Util.invokeAlertMethod("Alerta", strBody: "Excedes MTOW ( \(self.pesoDespegue) ), verifica la información", delegate: self)
        }else{
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .DecimalStyle
            txtPesoDespegue.backgroundColor = UIColor.whiteColor()
            self.txtPesoDespegue.text = "\(formatter.stringFromNumber(self.pesoDespegue)!)"
        }
        
    }
    
    func calcularPeso(){
        
        self.pesoOperacion = (txtPesoOperacion.text as NSString).floatValue
        self.pesoCombustible = (formatter.numberFromString(txtPesoCombustible.text as String))!.floatValue
        self.pesoCarga = (txtPesoCarga.text as NSString).floatValue
        self.pesoDespegue =  (self.pesoOperacion) + (self.pesoCarga) + (self.pesoCombustible)
    }
    
    //MARK: Tramos
    
    func cargarTramo(){
        
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .DecimalStyle
        var error: NSError?
        
        let fetchRequest = NSFetchRequest(entityName: "BitacorasLegs")
        var predicate = NSPredicate(format: "idbitacora=='\(global_var.j_bitacoras_Id)'")
        fetchRequest.predicate = predicate
        
        let fetchResults = coreDataStack.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [BitacorasLegs]
        
        println(fetchResults)
        
        if let aviones = fetchResults{
            
            for row in aviones{
                
                
                txtSale.text = row.origen
                txtLlega.text = row.destino
                var _nivelvuelo = row.nivelvuelo
                txtNivelVuelo.text = formatter.stringFromNumber(_nivelvuelo)
                txtUTCSale.text = row.horasalida
                txtUTCLlega.text = row.horallegada
                txtCalzos.text = row.calzoacalzo
                var _hsale = row.horometrodespegue
                var _hllega = row.horometroaterrizaje
                txtHorometroLlega.text = formatter.stringFromNumber(_hllega)
                txtHorometroSale.text = formatter.stringFromNumber(_hsale)
                var _tv = row.tv
                txtTV.text = formatter.stringFromNumber(_tv)
                
                var _combcargado = row.combustiblecargado
                var _combSale = row.combustibledespegue
                var _combLlega = row.combustibleaterrizaje
                var _combConsumido = row.combustibleconsumido
                
                txtCombustibleCargado.text = formatter.stringFromNumber(_combcargado)
                txtCombustibleSale.text = formatter.stringFromNumber(_combSale)
                txtCombustibleLlega.text = formatter.stringFromNumber(_combLlega)
                txtConsumo.text = formatter.stringFromNumber(_combConsumido)
                
                var _pesocarga = row.pesocarga
                var _pesocombustible = row.pesocombustible
                var _pesoDespegue = row.pesodespegue
                var _pesoaterrizaje = row.pesoaterrizaje
                
                var _aceitecargadomotor = row.aceitecargado
                var _aceitecargadoapu = row.aceitecargadoapu
                
                self.combustibleSale = (_combSale).floatValue
                
                txtPesoCarga.text = formatter.stringFromNumber(_pesocarga)
                txtPesoCombustible.text =  formatter.stringFromNumber(_pesocombustible)
                txtPesoDespegue.text = formatter.stringFromNumber(_pesoDespegue)
                txtPesoAterrizaje.text = formatter.stringFromNumber(_pesoaterrizaje)
                txtBitacora.text = "\(global_var.j_bitacora_num)"
                txtFecha.text = dateformatter.stringFromDate(global_var.j_bitacora_fecha)
                txtCliente.text = global_var.j_bitacora_cliente
                
                println("tramo: \(row.idtramo)")
                
                global_var.j_tramos_Id = row.idtramo
                
            }
            
        }else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func obtenerUltimoTramo(){
        
        /*
        ModelManager.instance.database!.open()
        
        var dt : FMResultSet! = sharedInstance.database!.executeQuery("SELECT bitacoras_legs.Destino,bitacoras_legs.HorometroAterrizaje  FROM bitacoras inner join bitacoras_legs on bitacoras.idbitacora = bitacoras_legs.idbitacora  where bitacoras.matricula='\(global_var.j_avion_matricula)' Order BY bitacoras_legs.idtramo DESC LIMIT 1  ", withArgumentsInArray: nil)
        
        while(dt.next()){
        
        totalArray.addObject(dt.resultDictionary())
        }
        
        ModelManager.instance.database!.close()
        
        if self.totalArray.count > 0{
        
        let row = self.totalArray[0] as! NSDictionary
        
        global_var.j_avion_ultimodestino = row["Destino"] as! String
        global_var.j_avion_ultimohorometro = row["HorometroAterrizaje"] as! Float
        
        
        txtHorometroSale.text = "\(global_var.j_avion_ultimohorometro)"
        txtSale.text = global_var.j_avion_ultimodestino
        
        
        
        }
        */
    }
    
    func GuardarTramo(){
        
        var _calzos : String =  "0000"
        var _combustiblecargado : NSNumber = 0
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
        var _pesoaterrizaje : NSNumber = 0
        var _TV : NSNumber = 0
        var _aceitecargadomotor : NSNumber = 0
        var _aceitecargadoapu : NSNumber = 0
        
        if(!txtCalzos.text.isEmpty){
            _calzos = (txtCalzos.text as NSString) as String
        }
        if(!txtCombustibleCargado.text.isEmpty){
            _combustiblecargado = (txtCombustibleCargado.text as NSString).floatValue
        }
        if(!txtCombustibleLlega.text.isEmpty){
            _combustiblellega = (txtCombustibleLlega.text as NSString).floatValue
        }
        if(!txtCombustibleSale.text.isEmpty){
            _combustiblesale = (txtCombustibleSale.text as NSString).floatValue
        }
        if(!txtConsumo.text.isEmpty){
            _combustibleconsumo = (txtConsumo.text as NSString).floatValue
        }
        if(!txtHorometroLlega.text.isEmpty){
            _horometrollega = (txtHorometroLlega.text as NSString).floatValue
        }
        if(!txtHorometroSale.text.isEmpty){
            _horometrosale = (txtHorometroSale.text as NSString).floatValue
        }
        if(!txtNivelVuelo.text.isEmpty){
            _nivelvuelo = (txtNivelVuelo.text as NSString).floatValue
        }
        if(!txtPesoCombustible.text.isEmpty){
            _pesocombustible = (formatter.numberFromString(txtPesoCombustible.text as String))!.floatValue

        }
        if(!txtPesoDespegue.text.isEmpty){
            _pesodespegue = (txtPesoDespegue.text as NSString).floatValue
        }
        if(!txtPesoOperacion.text.isEmpty){
            _pesooperacion = (txtPesoOperacion.text as NSString).floatValue
        }
        if(!txtPesoCarga.text.isEmpty){
            _pesocarga = (txtPesoCarga.text as NSString).floatValue
        }
        if(!txtPesoAterrizaje.text.isEmpty){
            _pesoaterrizaje = (txtPesoAterrizaje.text as NSString).floatValue
        }
        if(!txtTV.text.isEmpty){
            _TV = (txtTV.text as NSString).floatValue
        }
        
        
        if(!txtSale.text.isEmpty && !txtLlega.text.isEmpty)
        {
            GuardarBitacora()
            
            if(global_var.j_bitacoras_Id != 0){
                
                if(global_var.j_tramos_Id == 0){
                    
                    global_var.j_tramos_Id = coreDataStack.obtenerIdTramo()
                    
                    coreDataStack.agregarTramo(_aceitecargadomotor, aceitecargadoapu: _aceitecargadoapu, calzoacalzo: _calzos, capitan_altimetrorvsm: 0, combustibleaterrizaje: _combustiblellega, combustiblecargado: 0, combustibleconsumido: _combustibleconsumo, combustibledespegue: _combustiblesale, coordenadasregistradas: "", destino: txtLlega.text.uppercaseString, destinociudad: txtLlega.text.uppercaseString, horallegada: txtUTCLlega.text, horasalida: txtUTCSale.text, horometroaterrizaje: _horometrollega, horometrodespegue: _horometrosale, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nivelvuelo: _nivelvuelo, numbitacora: (txtBitacora.text).toInt()!, oat: 0, origen: txtSale.text.uppercaseString, origenciudad: txtSale.text.uppercaseString, pesoaterrizaje: _pesoaterrizaje, pesocarga: _pesocarga, pesocombustible: _pesocombustible, pesodespegue: _pesodespegue, pesoperacion: _pesooperacion, primeroficialaltimetrorvsm: "", tv: _TV,combustibleunidadmedida: "\(SegmentoUnidadMedida.selectedSegmentIndex)", combustibleunidadpeso: "\(SegmentoUnidadPeso.selectedSegmentIndex)")
                    
                    //Agregar los pax de la tabla de vuelos a la tabla de bitacoras
                    coreDataStack.agregarPasajeroDeVuelosABitacoras(global_var.j_bitacora_legid, idbitacora: global_var.j_bitacoras_Id, idtramo: global_var.j_tramos_Id)
                    
                }else{
                    println(_pesocombustible)
                    coreDataStack.actualizaTramo(_aceitecargadomotor, aceitecargadoapu: _aceitecargadoapu, calzoacalzo: _calzos, capitan_altimetrorvsm: 0, combustibleaterrizaje: _combustiblellega, combustiblecargado: 0, combustibleconsumido: _combustibleconsumo, combustibledespegue: _combustiblesale, coordenadasregistradas: "", destino: txtLlega.text.uppercaseString, destinociudad: txtLlega.text.uppercaseString, horallegada: txtUTCLlega.text, horasalida: txtUTCSale.text, horometroaterrizaje: _horometrollega, horometrodespegue: _horometrosale, idbitacora: global_var.j_bitacoras_Id, idservidor: 0, idtramo: global_var.j_tramos_Id, nivelvuelo: _nivelvuelo, numbitacora: (txtBitacora.text).toInt()!, oat: 0, origen: txtSale.text.uppercaseString, origenciudad: txtSale.text.uppercaseString, pesoaterrizaje: _pesoaterrizaje, pesocarga: _pesocarga, pesocombustible: _pesocombustible, pesodespegue: _pesodespegue, pesoperacion: _pesooperacion, primeroficialaltimetrorvsm: "", tv: _TV, combustibleunidadmedida: "\(SegmentoUnidadMedida.selectedSegmentIndex)", combustibleunidadpeso: "\(SegmentoUnidadPeso.selectedSegmentIndex)")
                    
                    
                }
                
                coreDataStack.actualizaUltimaInformacion(txtMatricula.text, ultimabitacora: (txtBitacora.text).toInt()!, ultimodestino: txtLlega.text, ultimohorometro: (txtHorometroLlega.text as NSString).floatValue, ultimohorometroapu: global_var.j_avion_ultimohorometroapu, sincronizado: 0)
                
                
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 1
                }
                
                
                
            }
            else{
                Util.invokeAlertMethod("Error", strBody: "Es necesario primero registrar la bitacora, consulta al administrador", delegate: self)
            }
            
            
        }
        else{
            Util.invokeAlertMethod("Aerotron", strBody: "Es necesario indicar el origen y el destino del vuelo", delegate: self)
            
        }
        
        
    }
    
    //MARK: - Bitacora
    
    func GuardarBitacora(){
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle //Set date style
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        var FechaRegistro = date
        
        global_var.j_avion_ultimabitacora = txtBitacora.text.toInt()!
        
        if global_var.j_bitacoras_Id == 0 { //Agregar nueva bitacora
            
            global_var.j_bitacoras_Id = coreDataStack.obtenerIdBitacora()
            
            coreDataStack.agregarBitacora("", aterrizajes: 0, capitan: String(global_var.j_usuario_idPiloto), capitannombre: global_var.j_usuario_nombre, ciclos: 0, ciclosapu: 0, cliente: txtCliente.text, copiloto: "", copilotonombre: "", fecharegistro: FechaRegistro, fechavuelo:  dateformatter.dateFromString(txtFecha.text)!, horometroapu: 0, horometrollegada: 0, horometrosalida: 0, hoy: 0, idbitacora: global_var.j_bitacoras_Id , idservidor: 0, ifr: 0, legid: (global_var.j_vuelo_legid as NSString).integerValue, licenciatecnico: "", mantenimientodgac: "", mantenimientointerno: "", matricula: txtMatricula.text, nocturno: "", nombretecnico: "", numbitacora: (txtBitacora.text as NSString).integerValue, quienprevuelo: "", reportes: "", serie: "", sincronizado: 0, status: 1, totalaterrizaje: 0, tv: 0)
            
            
            
            global_var.j_bitacora_num = (txtBitacora.text as NSString).integerValue
            global_var.j_bitacora_abierta = 1
            println("Se registro Bitacora con  ID: \(global_var.j_bitacoras_Id)")
            
            //Actualizo el vuelo a realizado
            coreDataStack.actualizaVueloRealizado(global_var.j_vuelo_legid)
            
        }else{
            
            println("Se actualizo Bitacora con ID: \(global_var.j_bitacoras_Id)")
            
            coreDataStack.actualizarBitacora("", aterrizajes: 0, capitan: String(global_var.j_usuario_idPiloto), capitannombre: global_var.j_usuario_nombre, ciclos: 0, ciclosapu: 0, cliente: txtCliente.text, copiloto: "", copilotonombre: "", fecharegistro: FechaRegistro, fechavuelo: dateformatter.dateFromString(txtFecha.text)!, horometroapu: 0, horometrollegada: 0, horometrosalida: 0, hoy: 0, idbitacora: global_var.j_bitacoras_Id , idservidor: 0, ifr: 0, legid: (global_var.j_vuelo_legid as NSString).integerValue, licenciatecnico: "", mantenimientodgac: "", mantenimientointerno: "", matricula: txtMatricula.text, nocturno: "", nombretecnico: "", numbitacora: (txtBitacora.text as NSString).integerValue, quienprevuelo: "", reportes: "", serie: "", sincronizado: 0, status: 1, totalaterrizaje: 0, tv: 0)
            
        }

        
    }
    
    @IBAction func btnCancelar(sender: AnyObject) {
        regresarABitacoras()
    }
    
    func regresarABitacoras() {
        
        var destino = "tabBarcontroller"
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destviewcontroller : UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier(destino) as! UITabBarController
        destviewcontroller.selectedIndex = 1
        self.presentViewController(destviewcontroller, animated: true, completion: nil)
        
    }
    
    
}
