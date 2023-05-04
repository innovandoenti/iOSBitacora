//
//  TVC_InformacionVueloViewController.swift
//  Bitacoras
//
//  Created by Jaime Solis on 21/05/16.
//  Copyright © 2016 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit
import CoreData

class TVC_InformacionVueloViewController: UIViewController {

    let coreDataStack : CoreDataStack = CoreDataStack()
    
    
    @IBOutlet weak var lbMatricula: UILabel!
    
    @IBOutlet weak var lbCliente: UILabel!
    
    @IBOutlet weak var lbRuta: UILabel!
    
    @IBOutlet weak var lbFecha: UILabel!
    
    @IBOutlet weak var lbHora: UILabel!
    
    @IBOutlet weak var lbTV: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async(){
             self.cargarVuelo()
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cerrar(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func cargarVuelo(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vuelos")
        let predicate = NSPredicate(format: "legid = %@", argumentArray: [global_var.j_vuelo_legid])
        fetchRequest.predicate = predicate
        
        let fecha_formato : DateFormatter = DateFormatter()
        fecha_formato.dateStyle = .short
        fecha_formato.timeStyle = .none
        fecha_formato.dateFormat = "dd/MM/yyy"
        
        do{
            let fetchResults =  try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [Vuelos]
            if let fly = fetchResults{
                for row in fly{
                   lbMatricula.text = row.tailnumber!
                    lbCliente.text = row.customername!
                    lbRuta.text = row.aeropuertosale! + "  -  " +  row.aeropuertollega!
                    lbFecha.text =  fecha_formato.string(from: row.fecha! as Date)
                    lbHora.text = row.horasale!
                    lbTV.text = row.horavuelo!
                }
            }
        }catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error2", strBody: error.description as NSString, delegate: self)
        }
        
        
    }

}
