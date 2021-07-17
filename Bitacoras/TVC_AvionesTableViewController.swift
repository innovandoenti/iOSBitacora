//
//  TVC_AvionesTableViewController.swift
//  BItacoras
//
//  Created by Jaime Solis on 12/05/16.
//  Copyright © 2016 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit
import CoreData

class TVC_AvionesTableViewController: UITableViewController {

   
    var dataSource : NSDictionary!
    var results : NSArray!
    var dictionary : NSDictionary!
    var datatable : Array<AnyObject> = []
    var dt_bitacoras : NSMutableArray = NSMutableArray()
    var logica = Util()
    var coreDataStack = CoreDataStack()
    var formato : DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.navigationItem.title = "Aviones"
        
        cargarAviones()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Funciones Locales
    
    func cargarAviones(){
        let sortDescriptor = NSSortDescriptor(key: "matricula", ascending: true)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
        request.predicate = NSPredicate(format: "status==1")
        request.sortDescriptors = [sortDescriptor]
        
        do{
            datatable = try self.coreDataStack.managedObjectContext.fetch(request)
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
            
        }
        catch let erros as NSError {
            Util.invokeAlertMethod(strTitle: "Error", strBody: erros.description as NSString, delegate: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return datatable.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TVC_AvionesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TVC_AvionesTableViewCell
        
        if let bitacora = datatable[(indexPath as NSIndexPath).row] as? TaxiAereoMatriculas {
            
            cell.LbMatricula.text = bitacora.matricula!
            cell.lbBitacora.text = "Ultima bitacora: " +  (bitacora.ultimabitacora?.stringValue)!
            cell.lbDestino.text = "Último destino: " + bitacora.ultimodestino!
            cell.lbHorometro.text = "Último horometro: " +  (bitacora.ultimohorometro?.stringValue)!
            
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var altura : CGFloat = 0
        
        if DeviceType.IS_IPAD {
            altura = 161
        }else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            altura  =  119
        }else{
            altura = 161
        }
        
        return altura
        
    }
   
    @IBAction func btnActualizar(_ sender: Any) {
        self.coreDataStack.verificaHayAvionesPorSincronizar()
        self.coreDataStack.pilotosPorSincronizar()
    }
}


