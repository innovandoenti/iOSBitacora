//
//  CoreDataStack.swift
//  BItacoras
//
//  Created by Jaime Solis on 26/06/15.
//  Copyright (c) 2015 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum BitacorasError {
    case sinError
    case utcSale
    case utcLlega
    case horometroSale
    case horometroLlega
    case combustibleSale
    case combustibleLlega
    case licenciaCopiloto
    case tiempovuelo
    case calzoacalzo
    
    static let facilities = [sinError, utcSale, utcLlega, horometroSale, horometroLlega, combustibleSale, combustibleLlega, tiempovuelo, calzoacalzo]
    
    func NombreError() -> String {
        switch self {
        case .sinError: return "Sin Error"
        case .utcSale: return "Hora Salida"
        case .utcLlega: return "Hora Llegada"
        case .horometroSale: return "Horometro Salida"
        case .horometroLlega: return "Horometro Llegada"
        case .combustibleSale: return "Combustible Salida"
        case .combustibleLlega: return "Combustible Llegada"
        case .licenciaCopiloto: return "Licencia Copiloto"
        case .tiempovuelo: return "Tiempo de vuelo"
        case .calzoacalzo: return "Calzo a calzo"
            
        }
    }
    
}

class CoreDataStack {
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "mx.aerotron.CoreData1" in the application's documents Application Support directory.
        //let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)//   NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        //return urls[urls.count-1]
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        var modelPath = Bundle.main.path(forResource: "Bitacoras", ofType: "momd")
        var modelURL = NSURL.fileURL(withPath: modelPath!)
        var model = NSManagedObjectModel(contentsOf: modelURL)!
        
        return model
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator : NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        //let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("flightbook.sqlite")
        let url = self.applicationDocumentsDirectory.appendingPathComponent("taxiaereo.sqlite")
        var options = Dictionary<NSObject, AnyObject>()
       // options[NSMigratePersistentStoresAutomaticallyOption] = true
       // options[NSInferMappingModelAutomaticallyOption] = true
       // options[NSSQLitePragmasOption] = ["journal_mode" : "DELETE"]
        
        options = [NSMigratePersistentStoresAutomaticallyOption as NSObject: true as AnyObject, NSInferMappingModelAutomaticallyOption as NSObject: true as AnyObject, NSSQLitePragmasOption as NSObject: ["journal_mode" : "DELETE"] as AnyObject]
       // options["journal_mode"] = "DELETE"
        //flightbook
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options) // (ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

  
    //MARK: - Ajustes
    
    
    
    func actualizaUltimaSincronizacion(idpiloto: NSNumber, ultimaactualizacion: NSDate){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        do {
            
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Ajustes", in: cdh.backgroundContext!)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "idpiloto = %@", idpiloto)
            request.propertiesToUpdate = [
                "ultimasincronizacion" : ultimaactualizacion
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType // updatedObjectsCountResultType
            
            //try managedObjectContext.execute(request) 
            try cdh.backgroundContext!.execute(request)
            
            print("Actualizado la ultima sincronización desde Batch")
            
            
        }catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }

    }
    
    func actualizando(idpiloto: NSNumber, actualizando: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        do {
            
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Ajustes", in: cdh.backgroundContext!)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "idpiloto = %@", idpiloto)
            request.propertiesToUpdate = [
                "actualizando" : actualizando
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
            
            try cdh.backgroundContext!.execute(request)
            
            print("Voy a iniciar la actualización")
            
            
        }catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    
    }
    
    func actualizando(idpiloto: NSNumber) -> Bool {
        
        var Existe = false
        let cdh : CoreDataHelper = CoreDataHelper()
        
        do{
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ajustes")
            fetchRequest.fetchBatchSize = 1
            fetchRequest.predicate = NSPredicate (format: "idpiloto = %@", idpiloto)
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Ajustes]
            
            if let persons = fetchResults{
                for person in persons{
                    if person.actualizando! == 1 {
                        Existe = true
                        break
                    }
                    
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return Existe
        
    }
   
    
    
    //MARK: - Usuarios Core Data Stack
    func insertUsuario(clave: String, correo: String, idpiloto: String, licencia: String, nombre: String, perfil: String, registrado: String, telefono: String, tokenregistrado: String){
        
        //let record = NSEntityDescription.insertNewObject(forEntityName: "Ajustes", in: self.managedObjectContext) as! Ajustes
         let cdh : CoreDataHelper = CoreDataHelper()
        
        
        let record : Ajustes = NSEntityDescription.insertNewObject(forEntityName: "Ajustes", into: cdh.backgroundContext!) as! Ajustes
        
        record.clave = clave
        record.correo = correo
        record.idpiloto = idpiloto
        record.licencia = licencia
        record.nombre = nombre
        record.perfil = perfil
        record.registrado = registrado
        record.telefono = telefono
        record.tokenregistrado = tokenregistrado
        
        print(record)
        
         cdh.saveContext(context: cdh.backgroundContext!)
        
    }
    
    func cerrarSesion() {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ajustes")
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Ajustes]
            
            for bas in fetchResults!
            {
                cdh.managedObjectContext.delete(bas)
            }
            
            cdh.saveContext(context:  cdh.managedObjectContext)
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func verificaHayUsuario() -> Int {
        var Existe = 0
        let cdh : CoreDataHelper = CoreDataHelper()
       
        do{
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ajustes")
            fetchRequest.fetchBatchSize = 1
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Ajustes]
            
            if let persons = fetchResults{
                
                
                for person in persons{
                    
                    Existe = 1
                    
                    global_var.j_usuario_clave = person.clave!
                    global_var.j_usuario_idPiloto = (person.idpiloto! as NSString).integerValue
                    global_var.j_piloto_licencia = person.licencia!
                    global_var.j_piloto_id = person.idpiloto!
                    global_var.j_usuario_nombre = person.nombre!
                    global_var.j_usuario_perfil = person.perfil!
                    global_var.j_usuario_yaregistro = true
                    global_var.j_piloto_nombre = person.nombre!
                    print(person.nombre!)
                    
                    break
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return Existe
        
    }
    
    
     //MARK: - Vuelos Core Data
    
    func existeVuelo(legid: String) -> Bool {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        var Existe = false
        
        
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vuelos")
                fetchRequest.predicate = NSPredicate(format: "legid = %@", argumentArray: [legid])
                
                let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Vuelos]
                
                if let persons = fetchResults{
                    
                    for person in persons{
                        
                        Existe = true
                        print(person.legid as Any)
                    }
                }
            }
            catch let error as NSError{
                Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
            }
        
        
         return Existe
    }
    
    func agregarVuelo(aeropuertollega: String, aeropuertosale: String, customername: String, distancia: String, fecha: NSDate, horallega: String, horasale: String, horavuelo: String, horavuelodecimal: String, legid: String, legnumber: String, sincronizado: NSNumber, status: NSNumber, tailnumber: String, tripnumber: String, prevuelo: String, copiloto: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "Vuelos", into: cdh.backgroundContext!) as! Vuelos
        
        let cliente = customername.replacingOccurrences(of: "-", with: " ")
        
        record.aeropuertollega = aeropuertollega
        record.aeropuertosale = aeropuertosale
        record.customername = cliente
        record.distancia = distancia
        record.fecha = fecha
        record.horallega = horallega
        record.horasale = horasale
        record.horavuelo = horavuelo
        record.horavuelodecimal = horavuelodecimal
        record.legid = legid
        record.legnumber = legnumber
        record.sincronizado = sincronizado
        record.status = status
        record.tailnumber = tailnumber
        record.tripnumber = tripnumber
        record.prevuelo = prevuelo
        record.copiloto = copiloto
        
        cdh.saveContext(context:  cdh.backgroundContext!)
        
        
        
        
    }
    
    func agregarVueloPasajero(legid:String, nombre:String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "VuelosPasajeros", into:  cdh.backgroundContext!) as! VuelosPasajeros
        
        record.legid = legid
        record.nombre = nombre
            
        print(nombre + legid)
        
        cdh.saveContext(context:  cdh.backgroundContext!)
        

    }
    
    func borrarPasajerosVuelo(legid:String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        var totalpiston_mono : Array<AnyObject> = []
        totalpiston_mono.removeAll(keepingCapacity: false)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VuelosPasajeros")
        request.predicate = NSPredicate(format: "legid=%@", argumentArray: [legid])
        let fetchResults = try! cdh.backgroundContext!.fetch(request) as? [VuelosPasajeros]
        
        print(fetchResults!)
        
        if((fetchResults?.count)! > 0){
            for bas in (fetchResults)!
            {
               cdh.backgroundContext!.delete(bas)
                
            }
            
            cdh.saveContext(context: cdh.backgroundContext!)
            
        }else{
           
        }
    }
    
    func quitarVuelos(legid: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vuelos")
        fetchRequest.predicate = NSPredicate(format: "legid=%@", argumentArray: [legid])
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [Vuelos]
            
            for bas in fetchResults
            {
                cdh.managedObjectContext.delete(bas)
                print("vuelo borrado: " +  legid)
            }
            
            cdh.saveContext(context: cdh.managedObjectContext)
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }

    func borrarVuelos() -> Bool {
        
        var borrado = false
        let cdh : CoreDataHelper = CoreDataHelper()
        var totalpiston_mono : Array<AnyObject> = []
        totalpiston_mono.removeAll(keepingCapacity: false)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Vuelos")
        request.predicate = NSPredicate(format: "status=%@", argumentArray: [0])
        let fetchResults = try! cdh.backgroundContext!.fetch(request) as! [Vuelos]
        
        print("Total Vuelos a borrar: \(fetchResults.count)")
        
        if(fetchResults.count > 0){
            for bas in fetchResults
            {
                cdh.backgroundContext!.delete(bas)
            }
            
            cdh.saveContext(context: cdh.backgroundContext!)
            
            borrado = true
            
        }else{
            borrado = true
        }
        
        return borrado
        
    }
    
    func actualizaVueloRealizado(legid: String) {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        do{
            
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Vuelos",  in: managedObjectContext)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "legid = %@", legid)
            request.propertiesToUpdate = [
                "status" : "1"
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
            
            //try cdh.backgroundContext!. 
            
             try cdh.backgroundContext!.execute(request) 
            
            print("Actualizado el vuelo : \(legid)")
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        
        
        
        
    }
    
    //MARK: - Matriculas Core Data
    
    
    func existeMatriculas(matricula: String) -> Bool {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        var Existe = false
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
            fetchRequest.predicate = NSPredicate(format: "matricula = %@", argumentArray: [matricula])
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [TaxiAereoMatriculas]
            if (fetchResults?.count)! > 0 {
                if let persons = fetchResults{
                    if persons.count > 0 {
                        for person in persons{
                            Existe = true
                            print(person.matricula!)
                        }
                    }
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        return Existe
        
    }
    
    func actualizarTodasMatriculas() {
        let cdh : CoreDataHelper = CoreDataHelper()
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "TaxiAereoMatriculas",  in: cdh.managedObjectContext)!
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.propertiesToUpdate = ["sincronizado" : 1]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        do {
             try cdh.backgroundContext!.execute(request) 
            print("Actualizada matricula para sincronizar")
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func buscaMatricula(matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
            let predicate = NSPredicate(format: "matricula=='\(matricula)'")
            fetchRequest.predicate = predicate
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [TaxiAereoMatriculas]
            
            if let aviones = fetchResults{
                
                for avion in aviones{
                    
                    global_var.j_avion_matricula = avion.matricula!
                    global_var.j_avion_modelo = avion.modelo!
                    global_var.j_avion_tipomotor = avion.tipomotor!
                    global_var.j_avion_totalmotor = avion.totalmotor!
                    global_var.j_avion_totalpax = avion.totalpax!
                    global_var.j_avion_fabricante = avion.fabricante!
                    global_var.j_avion_ano = avion.ano!
                    global_var.j_avion_numeroserie = avion.numeroserie!
                    global_var.j_avion_pesooperacion = avion.pesooperacion!
                    global_var.j_avion_ultimabitacora = avion.ultimabitacora!
                    global_var.j_avion_ultimodestino = avion.ultimodestino!
                    global_var.j_avion_ultimohorometro = avion.ultimohorometro!
                    global_var.j_avion_mtow = avion.mtow!.floatValue
                    global_var.j_avion_unidadpesoavion = avion.unidadpesos!
                    global_var.j_avion_sincronizado = avion.sincronizado!
                    global_var.j_avion_ultimociclo = avion.ultimociclo!
                    global_var.j_avion_ultimoaterrizaje = avion.ultimoaterrizaje!
                    
                    print("Tipo de Motor:\(String(describing: avion.tipomotor))")
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func agregarMatricula(ano: String, fabricante: String, matricula: String, modelo: String, mtow: NSNumber, numeroserie: String, pesoperacion: NSNumber, sincronizado: NSNumber, tipomotor: String, totalmotor: NSNumber, totalpax: NSNumber, ultimabitacora: NSNumber, ultimodestino: String, ultimohorometro: NSNumber, ultimohorometroapu: NSNumber, unidadpesos: NSNumber, ultimoaterrizaje: NSNumber, ultimociclo: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
 
        let record = NSEntityDescription.insertNewObject(forEntityName: "TaxiAereoMatriculas", into: cdh.backgroundContext!) as! TaxiAereoMatriculas
        
        record.ano = ano
        record.fabricante = fabricante
        record.matricula = matricula
        record.modelo = modelo
        record.mtow = mtow
        record.numeroserie = numeroserie
        record.pesooperacion = pesoperacion
        record.sincronizado = sincronizado
        record.tipomotor = tipomotor
        record.totalmotor = totalmotor
        record.totalpax = totalpax
        record.ultimabitacora = ultimabitacora
        record.ultimodestino = ultimodestino
        record.ultimohorometro = ultimohorometro
        record.ultimohorometroapu = ultimohorometroapu
        record.unidadpesos = unidadpesos
        record.ultimoaterrizaje = ultimoaterrizaje
        record.ultimociclo = ultimociclo
        record.status = 1
        
        cdh.saveContext(context: cdh.backgroundContext!)
    }
    
    func actualizaMatricula(ano: String, fabricante: String, matricula: String, modelo: String, mtow: NSNumber, numeroserie: String, pesoperacion: NSNumber, tipomotor: String, totalmotor: NSNumber, totalpax: NSNumber, unidadpesos: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()

        do{
            
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "TaxiAereoMatriculas", in: cdh.backgroundContext!)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "matricula = %@", matricula)
            request.propertiesToUpdate = [
                "ano" : ano,
                "fabricante" : fabricante,
                "modelo" : modelo,
                "mtow" : mtow,
                "numeroserie" : numeroserie,
                "pesooperacion" : pesoperacion,
                "tipomotor" : tipomotor,
                "totalmotor" : totalmotor,
                "totalpax" : totalpax,
                "unidadpesos" : unidadpesos,
                "status" : 1
                
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
            
            try cdh.backgroundContext!.execute(request)
            
            cdh.saveContext(context: cdh.backgroundContext!)
            
            print("Actualizado la matricula desde servidor")
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        

        
    }
    
    func borrarMatriculas() {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
            fetchRequest.predicate = NSPredicate(format: "sincronizado==1")
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [TaxiAereoMatriculas]
            
            if(fetchResults.count>0){
                
                for bas in fetchResults
                {
                    let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "TaxiAereoMatriculas", in: cdh.backgroundContext!)!
                    
                    let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
                    request.predicate = NSPredicate (format: "matricula = %@", bas.matricula!)
                    request.propertiesToUpdate = [
                        "status" : 0
                        
                    ]
                    request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
                    
                    try cdh.backgroundContext!.execute(request)
                    
                   //cdh.saveContext(context: cdh.backgroundContext!)
                   //cdh.managedObjectContext.delete(bas)
                     print("matricula borrada: \(bas.matricula!)")
                }
                
                cdh.saveContext(context: cdh.managedObjectContext)
            }
            
            
            
                
            
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    func verificaHayAvionesPorSincronizar(){

        var results : NSArray!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.allowsFloats = true
            
        if Conexion.isConnectedToNetwork() {
                
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            
            let wsURL = URL(string: acciones.getAviones)

            print("URL: \(wsURL!)")
            let data = try! Data(contentsOf: wsURL!)
            
            
            if let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary) as NSDictionary??)  {
                if(json!.count > 0){
                    if let total = json!["Resultado"] as? NSArray
                    {
                        if total.count > 0 {
                            let row = total[0] as! NSDictionary
                            let totalaviones:  Int = (((row["total"])! as AnyObject).integerValue)
                            if  totalaviones > 0 {
                                print("Total Aviones :\(totalaviones)")
                            }
                        }
                    }
                    results = json!["Aviones"] as! NSArray
                    if (results.count > 0){
                        self.borrarMatriculas()
                        for x in 0 ..< results.count {
                            let row = results[x] as! NSDictionary
                            
                            var uh : NSNumber  = 0
                            var uhapu : NSNumber = 0
                            var ua : NSNumber = 0
                            var ucm1 : NSNumber = 0
                            var ub : NSNumber = 0
                            var pom : NSNumber = 0
                            var po : NSNumber = 0
                            var up : NSNumber = 0
                            var tp : NSNumber = 0
                            var tm : NSNumber = 0
                            
                            if let cc = Double(row["ultimohorometro"] as! String){
                                uh = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["ultimohorometroapu"] as! String){
                                uhapu = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["ultimoaterrizaje"] as! String){
                                ua = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["ultimociclo"] as! String){
                                ucm1 = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["ultimabitacora"] as! String){
                                ub = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["pesooperacionmax"] as! String){
                                pom = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["pesooperacion"] as! String){
                                po = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["unidadpesos"] as! String){
                                up = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["totalpax"] as! String){
                                tp = NSNumber(value: cc)
                            }
                            
                            if let cc = Double(row["totalmotor"] as! String){
                                tm = NSNumber(value: cc)
                            }
                            
                            
                            if(self.existeMatriculas(matricula: row["matricula"] as! String) == false){
                                
                                self.agregarMatricula(ano: row["ano"] as! String, fabricante: row["fabricante"] as! String, matricula: row["matricula"] as! String,  modelo: row["modelo"] as! String,
                                                      mtow: pom, numeroserie: row["numeroserie"] as! String, pesoperacion: po, sincronizado: 1, tipomotor: row["tipomotor"] as! String, totalmotor: tm,
                                                      totalpax: tp, ultimabitacora: ub, ultimodestino: row["ultimodestino"] as! String, ultimohorometro: uh, ultimohorometroapu: uhapu, unidadpesos: up, ultimoaterrizaje: ua, ultimociclo: ucm1)
                            }else{
                                
                                //Solo actualizo los pesos y unidad de peso
                                self.actualizaMatricula(ano: row["ano"] as! String, fabricante: row["fabricante"] as! String,  matricula: row["matricula"] as! String,
                                                        modelo: row["modelo"] as! String, mtow: pom, numeroserie: row["numeroserie"] as! String, pesoperacion: po, tipomotor: row["tipomotor"] as! String, totalmotor: tm, totalpax: tp, unidadpesos: up)
                                
                                self.verificaUltimaInformacion(matricula: row["matricula"] as! String)
                                
                                self.actualizaUltimaInformacion(matricula: row["matricula"] as! String, ultimabitacora: ub, ultimodestino: row["ultimodestino"] as! String, ultimohorometro: uh, ultimohorometroapu: uhapu, sincronizado: 1, ultimoaterrizaje: ua, ultimociclo: ucm1)
                            }
                        }
                        
                    }
                }else{
                    
                }
            }
            
        }
    }
    
    func actualizarAvionParaSincronizar(matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        do{
            
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "TaxiAereoMatriculas", in: cdh.managedObjectContext)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "matricula = %@", matricula)
            request.propertiesToUpdate = [
                "sincronizado" : 1
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
            
            _ = try cdh.managedObjectContext.execute(request)
            
            cdh.saveContext(context: cdh.managedObjectContext)
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func actualizaUltimaInformacion(matricula: String, ultimabitacora: NSNumber, ultimodestino: String, ultimohorometro: NSNumber, ultimohorometroapu: NSNumber, sincronizado: NSNumber, ultimoaterrizaje : NSNumber, ultimociclo : NSNumber) {
        
        
        //Verificar si la última información debe guardarse.
        print("\(ultimabitacora)")
        print("\(global_var.j_avion_ultimabitacora)")
        if   (ultimabitacora.intValue >= global_var.j_avion_ultimabitacora.intValue || (ultimabitacora.intValue+3) <= global_var.j_avion_ultimabitacora.intValue){
            let cdh : CoreDataHelper = CoreDataHelper()
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "TaxiAereoMatriculas", in: cdh.backgroundContext!)!
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
                request.predicate = NSPredicate (format: "matricula = %@", matricula)
                request.propertiesToUpdate = [
                    "ultimabitacora" : ultimabitacora,
                    "ultimodestino" : ultimodestino,
                    "ultimohorometro" : ultimohorometro,
                    "ultimohorometroapu" : ultimohorometroapu,
                    "sincronizado" : sincronizado,
                    "ultimoaterrizaje" : ultimoaterrizaje,
                    "ultimociclo" : ultimociclo
                ]
            
                request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
            
            do {
                
                try cdh.backgroundContext!.execute(request)
                cdh.saveContext(context: cdh.backgroundContext!)
            }
            catch let error as NSError{
                Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
            }
        }
    }
    
    func obtieneUltimaInformacion(matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
        fetchRequest.predicate = NSPredicate(format: "matricula = %@", matricula)
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [TaxiAereoMatriculas]
            if let aviones = fetchResults{
                for row in aviones{
                    
                    global_var.j_avion_ultimabitacora = 0
                    if row.ultimabitacora != nil {
                       global_var.j_avion_ultimabitacora = NSNumber(value: row.ultimabitacora!.intValue + 1)
                    }
                    
                    global_var.j_avion_ultimodestino = ""
                    if row.ultimodestino != nil{
                        global_var.j_avion_ultimodestino = row.ultimodestino!
                    }
                    
                    global_var.j_avion_ultimohorometro = 0
                    if row.ultimohorometro != nil {
                        global_var.j_avion_ultimohorometro = row.ultimohorometro!
                    }
                    
                        global_var.j_avion_ultimoaterrizaje = 0
                    if row.ultimoaterrizaje != nil {
                        global_var.j_avion_ultimoaterrizaje = NSNumber(value: row.ultimoaterrizaje!.intValue + 1)
                        
                    }
                    global_var.j_avion_ultimociclo = 0
                    if row.ultimociclo != nil{
                        global_var.j_avion_ultimociclo =    NSNumber(value: row.ultimociclo!.intValue + 1)
                    }
                    

                }
            }
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func verificaUltimaInformacion(matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
        fetchRequest.predicate = NSPredicate(format: "matricula = %@", matricula)
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [TaxiAereoMatriculas]
            if let aviones = fetchResults{
                for row in aviones{
                    
                    global_var.j_avion_ultimabitacora = 0
                    if row.ultimabitacora != nil {
                        global_var.j_avion_ultimabitacora = NSNumber(value: row.ultimabitacora!.intValue)
                    }
                    
                    global_var.j_avion_ultimodestino = ""
                    if row.ultimodestino != nil{
                        global_var.j_avion_ultimodestino = row.ultimodestino!
                    }
                    
                    global_var.j_avion_ultimohorometro = 0
                    if row.ultimohorometro != nil {
                        global_var.j_avion_ultimohorometro = row.ultimohorometro!
                    }
                    
                    global_var.j_avion_ultimoaterrizaje = 0
                    if row.ultimoaterrizaje != nil {
                        global_var.j_avion_ultimoaterrizaje = NSNumber(value: row.ultimoaterrizaje!.intValue)
                        
                    }
                    global_var.j_avion_ultimociclo = 0
                    if row.ultimociclo != nil{
                        global_var.j_avion_ultimociclo =    NSNumber(value: row.ultimociclo!.intValue)
                    }
                    
                    
                }
            }
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func obtieneMatriculas() -> Array<Any>{
        var ArregloMatriculas : Array<AnyObject> = []
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaxiAereoMatriculas")
        
        do {
            let fetchResults = try cdh.backgroundContext!.fetch(fetchRequest) as! [TaxiAereoMatriculas]
            
            if fetchResults.count > 0 {
                ArregloMatriculas = fetchResults
                
                for Matricula in ArregloMatriculas as! [TaxiAereoMatriculas]{
                    print(Matricula.matricula as Any)
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        return ArregloMatriculas
    }
    
    
    // MARK: - Tramos Core Data
    
    
    func obtenerIdTramo() -> NSNumber{
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        var Idtramo : NSNumber = 0
        
        do {
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [BitacorasLegs]
            
            Idtramo = (NSNumber(value: (fetchResults!.count + 1)))
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return Idtramo
        
    }
    

    func agregarTramo(aceitecargado: NSNumber, aceitecargadoapu: NSNumber,  calzoacalzo: String, capitan_altimetrorvsm: NSNumber, combustibleaterrizaje: NSNumber, combustiblecargado: NSNumber, combustibleconsumido: NSNumber, combustibledespegue: NSNumber, coordenadasregistradas: String, destino: String, destinociudad: String, horallegada: String, horasalida: String, horometroaterrizaje: NSNumber, horometrodespegue: NSNumber, idbitacora: NSNumber, idservidor: NSNumber, idtramo: NSNumber, nivelvuelo: NSNumber, numbitacora: NSNumber,oat: NSNumber, origen: String, origenciudad: String, pesoaterrizaje: NSNumber, pesocarga: NSNumber, pesocombustible: NSNumber, pesodespegue: NSNumber, pesoperacion: NSNumber, primeroficialaltimetrorvsm: String, tv: NSNumber, combustibleunidadmedida: String, combustibleunidadpeso: String, matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        do {
            
            let record = NSEntityDescription.insertNewObject(forEntityName: "BitacorasLegs", into:  cdh.backgroundContext!) as! BitacorasLegs
            
            record.aceitecargado = aceitecargado
            record.aceitecargadoapu = aceitecargadoapu
            record.calzoacalzo = calzoacalzo
            record.capitan_altimetrorvsm = capitan_altimetrorvsm
            record.combustibleaterrizaje = combustibleaterrizaje
            record.combustiblecargado = combustiblecargado
            record.combustibleconsumido = combustibleconsumido
            record.combustibledespegue = combustibledespegue
            record.coordenadasregistradas = coordenadasregistradas
            record.destino = destino
            record.destinociudad = destinociudad
            record.horallegada = horallegada
            record.horasalida = horasalida
            record.horometroaterrizaje = horometroaterrizaje
            record.horometrodespegue = horometrodespegue
            record.idbitacora = idbitacora
            record.idservidor = idservidor
            record.idtramo = idtramo
            record.nivelvuelo = nivelvuelo
            record.numbitacora = numbitacora
            record.oat = oat
            record.origen = origen
            record.origenciudad = origenciudad
            record.pesoaterrizaje = pesoaterrizaje
            record.pesocarga = pesocarga
            record.pesocombustible = pesocombustible
            record.pesodespegue = pesodespegue
            record.pesooperacion = pesoperacion
            record.primeroficialaltimetrorvsm = primeroficialaltimetrorvsm
            record.tv = tv
            record.combustibleunidadmedida = combustibleunidadmedida
            record.combustibleunidadpeso = combustibleunidadpeso
            record.matricula = matricula
            
            cdh.saveContext(context: cdh.backgroundContext!)
            
        }
    }
    
    func quitarTramos(idbitacora: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
        fetchRequest.predicate = NSPredicate(format: "idbitacora = %@", idbitacora)
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [BitacorasLegs]
                
                for bas in fetchResults
                {
                    cdh.managedObjectContext.delete(bas)
                }
                
                cdh.saveContext(context: cdh.managedObjectContext)
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    
    func actualizaTramo(aceitecargado: NSNumber, aceitecargadoapu: NSNumber,  calzoacalzo: String, capitan_altimetrorvsm: NSNumber, combustibleaterrizaje: NSNumber, combustiblecargado: NSNumber, combustibleconsumido: NSNumber, combustibledespegue: NSNumber, coordenadasregistradas: String, destino: String, destinociudad: String, horallegada: String, horasalida: String, horometroaterrizaje: NSNumber, horometrodespegue: NSNumber, idbitacora: NSNumber, idservidor: NSNumber, idtramo: NSNumber, nivelvuelo: NSNumber, numbitacora: NSNumber,oat: NSNumber, origen: String, origenciudad: String, pesoaterrizaje: NSNumber, pesocarga: NSNumber, pesocombustible: NSNumber, pesodespegue: NSNumber, pesoperacion: NSNumber, primeroficialaltimetrorvsm: String, tv: NSNumber, combustibleunidadmedida: String, combustibleunidadpeso: String, matricula: String) {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasLegs", in:  cdh.backgroundContext!)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora, matricula])
            request.propertiesToUpdate = [
                
                "aceitecargado" : aceitecargado,
                "aceitecargadoapu" : aceitecargadoapu,
                "calzoacalzo" : calzoacalzo,
                "capitan_altimetrorvsm" : capitan_altimetrorvsm,
                "combustibleaterrizaje" : combustibleaterrizaje,
                "combustiblecargado" : combustiblecargado,
                "combustibleconsumido" : combustibleconsumido,
                "combustibledespegue" : combustibledespegue,
                "coordenadasregistradas" : coordenadasregistradas,
                "destino" : destino,
                "destinociudad" : destinociudad,
                "horallegada" : horallegada,
                "horasalida" : horasalida,
                "horometroaterrizaje" : horometroaterrizaje,
                "horometrodespegue" : horometrodespegue,
                "idbitacora" : idbitacora,
                "idservidor" : idservidor,
                "nivelvuelo" : nivelvuelo,
                "numbitacora" : numbitacora,
                "oat" : oat,
                "origen" : origen,
                "origenciudad" : origenciudad,
                "pesoaterrizaje" : pesoaterrizaje,
                "pesocarga" : pesocarga,
                "pesocombustible" : pesocombustible,
                "pesodespegue" : pesodespegue,
                "pesooperacion" : pesoperacion,
                "primeroficialaltimetrorvsm" : primeroficialaltimetrorvsm,
                "tv" : tv,
                "combustibleunidadmedida" : combustibleunidadmedida,
                "combustibleunidadpeso" : combustibleunidadpeso,
                "matricula" : matricula
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
           do {
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
    
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func obtenerTramo(idbitacora: NSNumber, matricula: String) -> String {
        
        var Ruta : String = " "
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
            let predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora, matricula])
            fetchRequest.predicate = predicate
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [BitacorasLegs]
            if let aviones = fetchResults{
                
                for tramo in aviones{
                    if tramo.origen != nil && tramo.destino != nil{
                        Ruta += tramo.origen! + " - " + tramo.destino! + " "
                    }
                    
                }
                
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        
        return Ruta
        
    }
    
    func actualizaTramoSincronizado(idbitacora: NSNumber, matricula: String, idservidor: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasLegs", in:  cdh.managedObjectContext)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate = [
            "idservidor" : idservidor
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try managedObjectContext.execute(request)
            cdh.saveContext(context: cdh.managedObjectContext)
            
            print("Actualizado desde Batch")
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    //MARK: - Bitacoras
    
    func IdBitacora(matricula: String) -> NSNumber {
        
        //Verifica si ya existe el numero de bitacora para la matricula
        //let cdh : CoreDataHelper = CoreDataHelper()
        var IdBitacora : NSNumber = 0
        /*
        let sortDescriptor = NSSortDescriptor(key: "numbitacora", ascending: false)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        let predicate = NSPredicate(format: "matricula =%@", argumentArray: [matricula])
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
            
            if (fetchResults?.count > 0){
                for item in fetchResults! {
                    IdBitacora = (item.numbitacora!) as Int + 1
                }
            }else{*/
        IdBitacora = NSNumber(value: (global_var.j_avion_ultimabitacora.intValue) + 1)
           /*}
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description, delegate: self)
        }*/
        
        return IdBitacora
        
        
    }
    
    func obtenerIdBitacora(matricula: String, numbitacora: NSNumber) -> Bool{
        
        //Verifica si ya existe el numero de bitacora para la matricula
        let cdh : CoreDataHelper = CoreDataHelper()
        var Existe = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        let predicate = NSPredicate(format: "matricula =%@ and numbitacora = %@", argumentArray: [matricula, numbitacora])
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
            
            if ((fetchResults?.count)! > 0){
                Existe = true
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return Existe

        
    }
    
    func agregarBitacora(accioncorreectiva: String, aterrizajes: NSNumber, capitan: String, capitannombre: String, capitanlicencia: String, ciclos: NSNumber, ciclosapu: NSNumber, cliente: String, copiloto: String, copilotonombre: String, fecharegistro: NSDate, fechavuelo: NSDate, horometroapu: NSNumber, horometrollegada: NSNumber, horometrosalida: NSNumber, hoy: NSNumber, idbitacora: NSNumber, idservidor: NSNumber, ifr: NSNumber, legid: NSNumber, licenciatecnico: String, mantenimientodgac: String, mantenimientointerno: String, matricula: String, nocturno: String, nombretecnico: String, numbitacora: NSNumber, quienprevuelo: String, reportes: String, serie: String, sincronizado: NSNumber, status: NSNumber, totalaterrizaje: NSNumber, tv: NSNumber, modificada: NSNumber, modificadatotal: NSNumber, prevuelolocal: NSNumber) {
        
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "Bitacoras", into:  cdh.backgroundContext!) as! Bitacoras
        
        record.aterrizajes = aterrizajes
        record.capitan = capitan
        record.capitannombre = capitannombre
        record.capitanlicencia = capitanlicencia
        record.ciclos = ciclos
        record.ciclosapu = ciclosapu
        record.cliente = cliente
        record.copiloto = copiloto
        record.copilotonombre = copilotonombre
        record.fecharegistro = fecharegistro
        record.fechavuelo = fechavuelo
        record.horometroapu = horometroapu
        record.horometrollegada = horometrollegada
        record.horometrosalida = horometrosalida
        record.hoy = hoy
        record.idbitacora = idbitacora
        record.idservidor = idservidor
        record.ifr = ifr
        record.legid = legid
        record.licenciatecnico = licenciatecnico
        record.matricula = matricula
        record.nocturno = nocturno
        record.nombretecnico = nombretecnico
        record.numbitacora = numbitacora
        record.quienprevuelo = quienprevuelo
        record.reportes = reportes
        record.serie = serie
        record.sincronizado = sincronizado
        record.status = status
        record.totalaterrizajes = totalaterrizaje
        record.tv = tv
        record.modificada = modificada
        record.modificadatotal = modificadatotal
        record.prevuelolocal = prevuelolocal
        record.usuario = global_var.j_usuario_clave
        
        cdh.saveContext(context: cdh.backgroundContext!)
    }
    
    func quitarBitacora(idbitacora: NSNumber){
        
       let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        fetchRequest.predicate = NSPredicate(format: "idbitacora = %@", idbitacora)
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [Bitacoras]
            
                for bas in fetchResults
                {
                    cdh.managedObjectContext.delete(bas)
                }
                
                cdh.saveContext(context: cdh.managedObjectContext)
            
        }
            
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func actualizarBitacora(accioncorreectiva: String, aterrizajes: NSNumber, capitan: String, capitannombre: String, capitanlicencia: String, ciclos: NSNumber, ciclosapu: NSNumber, cliente: String, copiloto: String, copilotonombre: String, fecharegistro: NSDate, fechavuelo: NSDate, horometroapu: NSNumber, horometrollegada: NSNumber, horometrosalida: NSNumber, hoy: NSNumber, idbitacora: NSNumber, idservidor: NSNumber, ifr: NSNumber, legid: NSNumber, licenciatecnico: String, mantenimientodgac: String, mantenimientointerno: String, matricula: String, nocturno: String, nombretecnico: String, numbitacora: NSNumber, quienprevuelo: String, reportes: String, serie: String, sincronizado: NSNumber, status: NSNumber, totalaterrizaje: NSNumber, tv: NSNumber, modificada: NSNumber, modificadatotal: NSNumber, prevuelolocal: NSNumber) {

        let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in:  cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate = [
            
            "aterrizajes" : aterrizajes,
            "capitan" : capitan,
            "capitannombre" : capitannombre,
            "capitanlicencia" : capitanlicencia,
            "ciclos" : ciclos,
            "ciclosapu" : ciclosapu,
            "cliente" : cliente,
            "copiloto" : copiloto,
            "copilotonombre" : copilotonombre,
            "fecharegistro" : fecharegistro,
            "fechavuelo" : fechavuelo,
            "horometroapu" : horometroapu,
            "horometrollegada" : horometrollegada,
            "horometrosalida" : horometrosalida,
            "hoy" : hoy,
            "idservidor" : idservidor,
            "ifr" : ifr,
            "legid" : legid,
            "licenciatecnico" : licenciatecnico,
            "matricula" : matricula,
            "nocturno" : nocturno,
            "nombretecnico" : nombretecnico,
            "numbitacora" : numbitacora,
            "quienprevuelo" : quienprevuelo,
            "reportes" : reportes,
            "serie" : serie,
            "sincronizado" : sincronizado,
            "status" : status,
            "totalaterrizajes" : totalaterrizaje,
            "tv" : tv,
            "modificada" : modificada,
            "modificadatotal" : modificadatotal,
            "prevuelolocal" : prevuelolocal,
            "usuario" : global_var.j_usuario_clave
            
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do{
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Actualizado desde Batch")
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func regresarBitacorasSincronizar() {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in:  cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "status = %@", argumentArray: [3])
        request.propertiesToUpdate = ["status" : 2]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request) 
            
            print("Regresadas Correctamente")
            
            //Verifica si hay alguna bitácora por sincronizar o bitácora abierta
            /*
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
            fetchRequest.predicate = NSPredicate(format: "sincronizado = %@ OR status = %@", argumentArray: [0, 1])
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
            if((fetchResults?.count)! > 0){
                print("Tiene tarea pendiente, no puedo sincronizar la aeronave")
                global_var.j_existe_bitacora_por_sincronizar = true
            }else{
                self.actualizarTodasMatriculas()
            }*/
            global_var.j_existe_bitacora_por_sincronizar = false    
            self.actualizarTodasMatriculas()
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func cerrarBitacora(idbitacora: NSNumber, matricula: String) {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in:  cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora,matricula])
        request.propertiesToUpdate = ["status" : 2]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request) 
            print("Cerrado la bitácora Correctamente")
            cdh.saveContext(context: cdh.backgroundContext!)
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func actualizaBitacoraSincronizando(idbitacora: NSNumber, matricula: String) {
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in:  managedObjectContext)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora,matricula])
        request.propertiesToUpdate = ["status" : 3]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try managedObjectContext.execute(request) 
            print("Sincronizando Correctamente")
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func verificaSiHayBitacoraMatricula(matricula: String) -> Bool {
        
        let cdh : CoreDataHelper = CoreDataHelper()

        
        var HayBitacora : Bool = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        fetchRequest.predicate = NSPredicate(format: "matricula = %@ AND status = %@", argumentArray: [matricula, 1])
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [Bitacoras]
            if(fetchResults.count > 0){
                HayBitacora = true
            }
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return HayBitacora
        
        
    }
    
    
    func verificaSiHayBitacoraMatriculaSincronizando(matricula: String) -> Bool {
        
        var HayBitacora : Bool = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        fetchRequest.predicate = NSPredicate(format: "matricula = %@ AND status = %@", argumentArray: [matricula, 3])
        
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
            if((fetchResults?.count)! > 0){
                HayBitacora = true
            }
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return HayBitacora
        
        
    }
    
    func BitacoraStatus(idbitacora: NSNumber, matricula: String) -> NSNumber {
        
        var Status : NSNumber = 0
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        fetchRequest.predicate = NSPredicate(format: "matricula = %@ AND idbitacora = %@", argumentArray: [matricula, idbitacora])
        
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
            if((fetchResults?.count)! > 0){
                for bas in fetchResults!
                {
                    Status = bas.status!
                }
            }
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return Status
        
        
    }
    
    func agregarBitacoraPasajero(idbitacora: NSNumber, idpax: NSNumber, idservidor: NSNumber, idtramo: NSNumber, nombre:String, matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()

        
        let record = NSEntityDescription.insertNewObject(forEntityName: "BitacorasPax", into:  cdh.backgroundContext!) as! BitacorasPax
        
        record.idbitacora = idbitacora
        record.idpax = idpax
        record.idservidor = idservidor
        record.idtramo = idtramo
        record.nombre = nombre
        record.matricula = matricula
        print(record)
        
        cdh.saveContext(context: cdh.backgroundContext!)
    }

    func actualizaBitacoraSincronizada(idbitacora: NSNumber, idservidor: NSNumber) {
        
        let cdh : CoreDataHelper = CoreDataHelper()

        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in:  cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@", idbitacora)
        request.propertiesToUpdate = [
            
            "idservidor" : idservidor,
            "sincronizado" : 1,
        ]
        
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            let result = try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Actualizado bitacora sincronizada: id: ", result.description)
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func abrirBitacora(idbitacora: NSNumber, matricula: String, modificada: NSNumber, modificadatotal: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in: cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate =
            [
                "status" : 1,
                "sincronizado" : 0,
                "modificada" : modificada,
                "modificadatotal" : modificadatotal
        	]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Abierto Correctamente")
           
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }

    func verificaBitacoraPorCerrar(idbitacora: NSNumber, matricula: String) -> String {
        
        var returnvalue = ""
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
        fetchRequest.predicate = NSPredicate(format: "idbitacora = %@ and matricula = %@", argumentArray: [idbitacora,matricula])
        
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [BitacorasLegs]
            
            if let flight = fetchResults {
                
                for row in flight
                {
                    
                    let hllega : Double = row.horometroaterrizaje!.doubleValue
                    let hsale : Double = row.horometrodespegue!.doubleValue
                    
                    print(hllega)
                    print(hsale)
                    
                    if(hllega < hsale){
                        returnvalue += "[ " + BitacorasError.horometroLlega.NombreError() + " ] "
                    }
                    
                    if(row.horasalida! == ""){
                        returnvalue += "[ " + BitacorasError.utcSale.NombreError() + " ] "
                    }
                    
                    if(row.horallegada! == ""){
                        returnvalue += "[ " + BitacorasError.utcLlega.NombreError() + " ] "
                    }
                    
                    if(!Util.validaTiempos(horacalzo: row.calzoacalzo!, tiempovuelo: row.tv!)){
                        returnvalue += "[ " + BitacorasError.tiempovuelo.NombreError() + " ] "
                    }
                    
                    if !(row.calzoacalzo!.isEmpty) && !(row.horometroaterrizaje!.stringValue.isEmpty) {
                        let tv : NSNumber = row.tv!
                        
                        let splitTime = row.calzoacalzo!.split(separator: ":")
                        if splitTime.count > 1 {
                            if !Util.validaTiempos(horacalzo: row.calzoacalzo!, tiempovuelo: tv){
                                returnvalue += "[ " +  BitacorasError.calzoacalzo.NombreError() + " ] "
                            }
                        }else{
                            returnvalue += "[ " +  BitacorasError.calzoacalzo.NombreError() + " ] "
                        }
                    }
                    
                    if(row.combustibleaterrizaje!.intValue <= 0){
                        returnvalue += "[ " + BitacorasError.combustibleLlega.NombreError() + " ] "
                    }
                    
                    if(row.combustibledespegue!.intValue <= 0){
                        returnvalue += "[ " + BitacorasError.combustibleSale.NombreError() + " ] "
                    }
                    
                    if (row.combustibledespegue!.intValue == row.combustibleaterrizaje!.intValue){
                        returnvalue += "[ " + BitacorasError.combustibleLlega.NombreError() + " ] "
                    }
                    
                    if returnvalue == ""{
                        returnvalue = BitacorasError.sinError.NombreError()
                    }
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return returnvalue
        
    }
    
    
    //MARK: - Instrumentos Core Data
    
    func obtenerIdInstrumento() -> NSNumber{
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        var IdInstrumento : NSNumber = 0
        
        do {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [BitacorasInstrumentos]
            
            IdInstrumento = (NSNumber(value: (fetchResults!.count + 1)))
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        
        return IdInstrumento
    
    
    }
    
    func quitarInstrumentos(){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
        
        do{
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as! [BitacorasInstrumentos]
            
            
                
                for bas in fetchResults
                {
                    cdh.backgroundContext!.delete(bas)
                }
                
                //saveContext(context: )
                
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    
    func quitarInstrumentos(idbitacora: NSNumber){
        
       let cdh : CoreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasInstrumentos")
        fetchRequest.predicate = NSPredicate(format: "idbitacora = %@", idbitacora)
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [BitacorasInstrumentos]
            
            if fetchResults.count > 0{
                for bas in fetchResults
                {
                    cdh.managedObjectContext.delete(bas)
                }
                
                cdh.saveContext(context: cdh.managedObjectContext)
            }
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
       
        
    }
    
    
    
    func agregarInstrumentos_Piston_MonoMotor(idbitacora: NSNumber, idlectura: NSNumber, idservidor: NSNumber, idtramo: NSNumber,  matricula: String, numbitacora: NSNumber, piston_aceite_mas: NSNumber, piston_ampers: NSNumber, piston_cht: NSNumber,  piston_crucero: NSNumber, piston_egt: NSNumber, piston_flow: NSNumber, piston_fuelpress: NSNumber, piston_manpress: NSNumber, piston_oat: NSNumber, piston_oilpress: NSNumber, piston_rpm: NSNumber, piston_temp: NSNumber, piston_volts: NSNumber) {
        
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "BitacorasInstrumentos", into:  cdh.backgroundContext!) as! BitacorasInstrumentos

        record.idbitacora = idbitacora
        record.idlectura = idlectura
        record.idservidor = idservidor
        record.idtramo = idtramo
        record.matricula = matricula
        record.numbitacora = numbitacora
        record.piston_aceite_mas = piston_aceite_mas
        record.piston_ampers = piston_ampers
        record.piston_cht = piston_cht
        record.piston_crucero = piston_crucero
        record.piston_egt = piston_egt
        record.piston_flow = piston_flow
        record.piston_fuelpress = piston_fuelpress
        record.piston_manpress = piston_manpress
        record.piston_oat = piston_oat
        record.piston_oilpress = piston_oilpress
        record.piston_rpm = piston_rpm
        record.piston_temp = piston_temp
        record.piston_volts = piston_volts
        
        cdh.saveContext(context: cdh.backgroundContext!)
    }
    
    func actualizarInstrumentos_Piston_MonoMotor(idbitacora: NSNumber, idlectura: NSNumber, idservidor: NSNumber, idtramo: NSNumber,  matricula: String, numbitacora: NSNumber, piston_aceite_mas: NSNumber, piston_ampers: NSNumber, piston_cht: NSNumber,  piston_crucero: NSNumber, piston_egt: NSNumber, piston_flow: NSNumber, piston_fuelpress: NSNumber, piston_manpress: NSNumber, piston_oat: NSNumber, piston_oilpress: NSNumber, piston_rpm: NSNumber, piston_temp: NSNumber, piston_volts: NSNumber) {
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasInstrumentos", in:  cdh.backgroundContext!)!
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula=%@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate = [
            
            "idbitacora" : idbitacora,
            "idlectura" : idlectura,
            "idservidor" : idservidor,
            "idtramo" : idtramo,
            "matricula" : matricula,
            "numbitacora" : numbitacora,
            "piston_aceite_mas" : piston_aceite_mas,
            "piston_ampers" : piston_ampers,
            "piston_cht" : piston_cht,
            "piston_crucero" : piston_crucero,
            "piston_egt" : piston_egt,
            "piston_flow" : piston_flow,
            "piston_fuelpress" : piston_fuelpress,
            "piston_manpress" : piston_manpress,
            "piston_oat" : piston_oat,
            "piston_oilpress" : piston_oilpress,
            "piston_rpm" : piston_rpm,
            "piston_temp" : piston_temp,
            "piston_volts" : piston_volts
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request) 
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Actualizado desde Batch")
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    
    func actualizarInstrumentosSincronizado(idbitacora: NSNumber, matricula: String, idservidor: NSNumber) {
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasInstrumentos", in:  cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula=%@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate = [
            
            
            "idservidor" : idservidor
            
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Actualizado desde Batch")
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func agregarInstrumentos_Jet(idbitacora: NSNumber, idlectura: NSNumber, idservidor:  NSNumber, idtramo: NSNumber, matricula: String, numbitacora: NSNumber,jet_amp : NSNumber,jet_amp_motor2: NSNumber,jet_dcac: NSNumber,jet_dcac_motor2: NSNumber,jet_fflow: NSNumber,jet_fflow_motor2: NSNumber,jet_fueltemp: NSNumber,jet_fueltemp_motor2: NSNumber,jet_hydvol: NSNumber,jet_hydvol_motor2: NSNumber,
        jet_itt: NSNumber,jet_itt_motor2: NSNumber,jet_n1: NSNumber,jet_n1_motor2: NSNumber,jet_n2: NSNumber,jet_n2_motor2: NSNumber, jet_oilpress: NSNumber, jet_oilpress_motor2: NSNumber, jet_oiltemp: NSNumber, jet_oiltemp_motor2: NSNumber, jet_lecturaaltimetro_capitan: NSNumber, jet_lecturaaltimetro_primeroficial: NSNumber, jet_avion_serie: String, jet_motor1_serie: String, jet_motor2_serie: String, jet_apu_serie: String, jet_avion_ciclos: NSNumber, jet_motor1_ciclos: NSNumber, jet_motor2_ciclos: NSNumber, jet_apu_ciclos: NSNumber, jet_avion_turm: NSNumber, jet_motor1_turm: NSNumber, jet_motor2_turm: NSNumber, jet_apu_turm: NSNumber, jet_avion_tt: NSNumber, jet_motor1_tt: NSNumber, jet_motor2_tt: NSNumber, jet_apu_tt: NSNumber, jet_ias: NSNumber, jet_oat: NSNumber, jet_dc: NSNumber) {
        
             let cdh : CoreDataHelper = CoreDataHelper()
        
            let record = NSEntityDescription.insertNewObject(forEntityName: "BitacorasInstrumentos", into:  cdh.backgroundContext!) as! BitacorasInstrumentos
            
            record.idbitacora = idbitacora
            record.idlectura = idlectura
            record.idservidor = idservidor
            record.idtramo = idtramo
            record.matricula = matricula
            record.numbitacora = numbitacora
            
            record.jet_amp = jet_amp
            record.jet_amp_motor2 = jet_amp_motor2
            record.jet_dcac = jet_dcac
            record.jet_dcac_motor2 = jet_dcac_motor2
            record.jet_fflow = jet_fflow
            record.jet_fflow_motor2 = jet_fflow_motor2
            record.jet_fueltemp = jet_fueltemp
            record.jet_fueltemp_motor2 = jet_fueltemp_motor2
            record.jet_hydvol = jet_hydvol
            record.jet_hydvol_motor2 = jet_hydvol_motor2
            record.jet_itt = jet_itt
            record.jet_itt_motor2 = jet_itt_motor2
            record.jet_n1 = jet_n1
            record.jet_n1_motor2 = jet_n1_motor2
            record.jet_n2 = jet_n2
            record.jet_n2_motor2 = jet_n2_motor2
            record.jet_oilpress = jet_oilpress
            record.jet_oilpress_motor2 = jet_oilpress_motor2
            record.jet_oiltemp = jet_oiltemp
            record.jet_oiltemp_motor2 = jet_oiltemp_motor2
            record.jet_lecturaaltimetro_capitan = jet_lecturaaltimetro_capitan
            record.jet_lecturaaltimetro_primeroficial = jet_lecturaaltimetro_primeroficial
            record.jet_avion_serie = jet_avion_serie
            record.jet_motor1_serie = jet_motor1_serie
            record.jet_motor2_serie = jet_motor2_serie
            record.jet_apu_serie = jet_apu_serie
            record.jet_avion_ciclos = jet_avion_ciclos
            record.jet_motor1_ciclos = jet_motor1_ciclos
            record.jet_motor2_ciclos = jet_motor2_ciclos
            record.jet_apu_ciclos = jet_apu_ciclos
            record.jet_avion_turm = jet_avion_turm
            record.jet_motor1_turm = jet_motor1_turm
            record.jet_motor2_turm = jet_motor2_turm
            record.jet_apu_turm = jet_apu_turm
            record.jet_avion_tt = jet_avion_tt
            record.jet_motor1_tt = jet_motor1_tt
            record.jet_motor2_tt = jet_motor2_tt
            record.jet_apu_tt = jet_apu_tt
            record.jet_ias = jet_ias
            record.jet_oat = jet_oat
            record.jet_dc = jet_dc
        
            cdh.saveContext(context: cdh.backgroundContext!)
        
    }
    
    
    func actualizaInstrumentos_Jet(idbitacora: NSNumber, idlectura: NSNumber, idservidor:  NSNumber, idtramo: NSNumber, matricula: String, numbitacora: NSNumber,jet_amp : NSNumber,jet_amp_motor2: NSNumber,jet_dcac: NSNumber,jet_dcac_motor2: NSNumber,jet_fflow: NSNumber,jet_fflow_motor2: NSNumber,jet_fueltemp: NSNumber,jet_fueltemp_motor2: NSNumber,jet_hydvol: NSNumber,jet_hydvol_motor2: NSNumber,
        jet_itt: NSNumber,jet_itt_motor2: NSNumber,jet_n1: NSNumber,jet_n1_motor2: NSNumber,jet_n2: NSNumber,jet_n2_motor2: NSNumber, jet_oilpress: NSNumber, jet_oilpress_motor2: NSNumber, jet_oiltemp: NSNumber, jet_oiltemp_motor2: NSNumber, jet_lecturaaltimetro_capitan: NSNumber, jet_lecturaaltimetro_primeroficial: NSNumber, jet_avion_serie: String, jet_motor1_serie: String, jet_motor2_serie: String, jet_apu_serie: String, jet_avion_ciclos: NSNumber, jet_motor1_ciclos: NSNumber, jet_motor2_ciclos: NSNumber, jet_apu_ciclos: NSNumber, jet_avion_turm: NSNumber, jet_motor1_turm: NSNumber, jet_motor2_turm: NSNumber, jet_apu_turm: NSNumber, jet_avion_tt: NSNumber, jet_motor1_tt: NSNumber, jet_motor2_tt: NSNumber, jet_apu_tt: NSNumber, jet_ias: NSNumber, jet_oat: NSNumber, jet_dc: NSNumber) {
        
         let cdh : CoreDataHelper = CoreDataHelper()
            
            let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasInstrumentos", in: cdh.backgroundContext!)!
            
            let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
            request.predicate = NSPredicate (format: "idbitacora = %@ and matricula=%@", argumentArray: [idbitacora, matricula])
            request.propertiesToUpdate = [
                
                
                "idlectura" : idlectura,
                "matricula" : matricula,
                "numbitacora" : numbitacora,
                
                "jet_amp" : jet_amp,
                "jet_amp_motor2" : jet_amp_motor2,
                "jet_dcac" : jet_dcac,
                "jet_dcac_motor2" : jet_dcac_motor2,
                "jet_fflow" : jet_fflow,
                "jet_fflow_motor2" : jet_fflow_motor2,
                "jet_fueltemp" : jet_fueltemp,
                "jet_fueltemp_motor2" : jet_fueltemp_motor2,
                "jet_hydvol" : jet_hydvol,
                "jet_hydvol_motor2" : jet_hydvol_motor2,
                "jet_itt" : jet_itt,
                "jet_itt_motor2" : jet_itt_motor2,
                "jet_n1" : jet_n1,
                "jet_n1_motor2" : jet_n1_motor2,
                "jet_n2" : jet_n2,
                "jet_n2_motor2" : jet_n2_motor2,
                "jet_oilpress" : jet_oilpress,
                "jet_oilpress_motor2" : jet_oilpress_motor2,
                "jet_oiltemp" : jet_oiltemp,
                "jet_oiltemp_motor2" : jet_oiltemp_motor2,
                "jet_lecturaaltimetro_capitan" : jet_lecturaaltimetro_capitan,
                "jet_lecturaaltimetro_primeroficial" : jet_lecturaaltimetro_primeroficial,
                "jet_avion_serie" : jet_avion_serie,
                "jet_motor1_serie" : jet_motor1_serie,
                "jet_motor2_serie" : jet_motor2_serie,
                "jet_apu_serie" : jet_apu_serie,
                "jet_avion_ciclos" : jet_avion_ciclos,
                "jet_motor1_ciclos" : jet_motor1_ciclos,
                "jet_motor2_ciclos" : jet_motor2_ciclos,
                "jet_apu_ciclos" : jet_apu_ciclos,
                "jet_avion_turm" : jet_avion_turm,
                "jet_motor1_turm" : jet_motor1_turm,
                "jet_motor2_turm" : jet_motor2_turm,
                "jet_apu_turm" : jet_apu_turm,
                "jet_avion_tt" : jet_avion_tt,
                "jet_motor1_tt" : jet_motor1_tt,
                "jet_motor2_tt" : jet_motor2_tt,
                "jet_apu_tt" : jet_apu_tt,
                "jet_ias" : jet_ias,
                "jet_oat" : jet_oat,
                "jet_dc" :  jet_dc
            ]
            request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
            
            do{
                try cdh.backgroundContext!.execute(request)
                cdh.saveContext(context: cdh.backgroundContext!)
                print("Actualizado el instrumento JET desde Batch")
            }
            catch let error as NSError{
                Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
            }
            
            
    }
    
    
    func agregarInstrumentos_Turbo(idbitacora: NSNumber, idlectura: NSNumber, idservidor: NSNumber, idtramo: NSNumber, matricula: String, numbitacora: NSNumber, turbo_flow: NSNumber, turbo_flow_motor2: NSNumber, turbo_helicerpm: NSNumber,turbo_helicerpm_motor2: NSNumber, turbo_ias: NSNumber,turbo_ias_motor2: NSNumber, turbo_itt: NSNumber, turbo_itt_motor2: NSNumber, turbo_ng: NSNumber, turbo_ng_motor2: NSNumber,  turbo_nivelvuelo: NSNumber, turbo_oat: NSNumber, turbo_oilpress: NSNumber, turbo_oilpress_motor2 : NSNumber, turbo_oiltemp: NSNumber, turbo_oiltemp_motor2 : NSNumber, turbo_torque: NSNumber, turbo_torque_motor2: NSNumber, turbo_vi: NSNumber, turbo_vi_motor2:NSNumber, turbo_vv: NSNumber, turbo_vv_motor2 : NSNumber, turbo_dcac: NSNumber, turbo_dcac_motor2:NSNumber, turbo_amp: NSNumber, turbo_amp_motor2: NSNumber, turbo_avion_serie: String, turbo_avion_ciclos: NSNumber, turbo_avion_turm: NSNumber, turbo_avion_tt: NSNumber, turbo_motor_serie: String, turbo_motor_ciclos: NSNumber, turbo_motor_turm: NSNumber, turbo_motor_tt: NSNumber, turbo_helice_serie: String, turbo_helice_ciclos: NSNumber, turbo_helice_turm: NSNumber, turbo_helice_tt: NSNumber, turbo_fflow_in : NSNumber, turbo_fflow_in_motor2 : NSNumber, turbo_fflow_out : NSNumber, turbo_fflow_out_motor2 : NSNumber) {
        
        let cdh : CoreDataHelper = CoreDataHelper()

        
        let record = NSEntityDescription.insertNewObject(forEntityName: "BitacorasInstrumentos", into: cdh.backgroundContext!) as! BitacorasInstrumentos
        
        record.idbitacora = idbitacora
        record.idlectura = idlectura
        record.idservidor = idservidor
        record.idtramo = idtramo
        record.matricula = matricula
        record.numbitacora = numbitacora
        
        record.turbo_fflow = turbo_flow
        record.turbo_fflow_motor2 = turbo_flow_motor2
        record.turbo_helicerpm = turbo_helicerpm
        record.turbo_helicerpm_motor2 = turbo_helicerpm_motor2
        record.turbo_ias = turbo_ias
        record.turbo_ias_motor2 = turbo_ias_motor2
        record.turbo_itt = turbo_itt
        record.turbo_itt_motor2 = turbo_itt_motor2
        record.turbo_ng = turbo_ng
        record.turbo_ng_motor2 = turbo_ng_motor2
        record.turbo_nivelvuelo = turbo_nivelvuelo
        record.turbo_oat = turbo_oat
        record.turbo_oilpress = turbo_oilpress
        record.turbo_oilpress_motor2 = turbo_oilpress_motor2
        record.turbo_oiltemp = turbo_oiltemp
        record.turbo_oilpress_motor2 = turbo_oilpress_motor2
        record.turbo_torque = turbo_torque
        record.turbo_torque_motor2 = turbo_torque_motor2
        record.turbo_vi = turbo_vi
        record.turbo_vi_motor2   = turbo_vi_motor2
        record.turbo_vv = turbo_vv
        record.turbo_vv_motor2 = turbo_vv_motor2
        record.turbo_dcac = turbo_dcac
        record.turbo_dcac_motor2 = turbo_dcac_motor2
        record.turbo_amp = turbo_amp
        record.turbo_amp_motor2 = turbo_amp_motor2
        
        record.turbo_avion_serie = turbo_avion_serie
        record.turbo_avion_ciclos = turbo_avion_ciclos
        record.turbo_avion_turm = turbo_avion_turm
        record.turbo_avion_tt = turbo_avion_tt
        
        record.turbo_motor_serie = turbo_motor_serie
        record.turbo_motor_ciclos = turbo_motor_ciclos
        record.turbo_motor_turm = turbo_motor_turm
        record.turbo_motor_tt = turbo_motor_tt
        
        record.turbo_helice_serie = turbo_helice_serie
        record.turbo_helice_ciclos = turbo_helice_ciclos
        record.turbo_helice_turm = turbo_helice_turm
        record.turbo_helice_tt = turbo_helice_tt

        //Actualización 18 de Abril

        record.turbo_fflow_in = turbo_fflow_in
        record.turbo_fflow_in_motor2 = turbo_fflow_in_motor2
        record.turbo_fflow_out = turbo_fflow_out
        record.turbo_fflow_out_motor2 = turbo_fflow_out_motor2

        
        cdh.saveContext(context: cdh.backgroundContext!)
        
    }
    
    func actualizarInstrumentos_Turbo(idbitacora: NSNumber, idlectura: NSNumber, idservidor: NSNumber, idtramo: NSNumber, matricula: String, numbitacora: NSNumber, turbo_flow: NSNumber, turbo_flow_motor2: NSNumber, turbo_helicerpm: NSNumber,turbo_helicerpm_motor2: NSNumber, turbo_ias: NSNumber,turbo_ias_motor2: NSNumber, turbo_itt: NSNumber, turbo_itt_motor2: NSNumber, turbo_ng: NSNumber, turbo_ng_motor2: NSNumber,  turbo_nivelvuelo: NSNumber, turbo_oat: NSNumber, turbo_oilpress: NSNumber, turbo_oilpress_motor2 : NSNumber, turbo_oiltemp: NSNumber, turbo_oiltemp_motor2 : NSNumber, turbo_torque: NSNumber, turbo_torque_motor2: NSNumber, turbo_vi: NSNumber, turbo_vi_motor2:NSNumber, turbo_vv: NSNumber, turbo_vv_motor2 : NSNumber, turbo_dcac: NSNumber, turbo_dcac_motor2:NSNumber, turbo_amp: NSNumber, turbo_amp_motor2: NSNumber, turbo_avion_serie: String, turbo_avion_ciclos: NSNumber, turbo_avion_turm: NSNumber, turbo_avion_tt: NSNumber, turbo_motor_serie: String, turbo_motor_ciclos: NSNumber, turbo_motor_turm: NSNumber, turbo_motor_tt: NSNumber, turbo_helice_serie: String, turbo_helice_ciclos: NSNumber, turbo_helice_turm: NSNumber, turbo_helice_tt: NSNumber,turbo_fflow_in : NSNumber, turbo_fflow_in_motor2 : NSNumber, turbo_fflow_out : NSNumber, turbo_fflow_out_motor2 : NSNumber) {
        
        
        let cdh : CoreDataHelper = CoreDataHelper()

        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasInstrumentos", in: cdh.backgroundContext!)!
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula=%@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate = [
            
            
            "idbitacora" : idbitacora,
            "idlectura" : idlectura,
            "idservidor" : idservidor,
            "idtramo" : idtramo,
            "matricula" : matricula,
            "numbitacora" : numbitacora,
            "turbo_fflow" : turbo_flow,
            "turbo_fflow_motor2" : turbo_flow_motor2,
            "turbo_helicerpm" : turbo_helicerpm,
            "turbo_helicerpm_motor2" : turbo_helicerpm_motor2,
            "turbo_ias" : turbo_ias,
            "turbo_ias_motor2" : turbo_ias_motor2,
            "turbo_itt" : turbo_itt,
            "turbo_itt_motor2" : turbo_itt_motor2,
            "turbo_ng" : turbo_ng,
            "turbo_ng_motor2" : turbo_ng_motor2,
            "turbo_nivelvuelo" : turbo_nivelvuelo,
            "turbo_oat" : turbo_oat,
            "turbo_oilpress" : turbo_oilpress,
            "turbo_oilpress_motor2" : turbo_oilpress_motor2,
            "turbo_oiltemp" : turbo_oiltemp,
            "turbo_oiltemp_motor2" : turbo_oiltemp_motor2,
            "turbo_torque" : turbo_torque,
            "turbo_torque_motor2" : turbo_torque_motor2,
            "turbo_vi" : turbo_vi,
            "turbo_vi_motor2" : turbo_vi_motor2,
            "turbo_vv" : turbo_vv,
            "turbo_vv_motor2" : turbo_vv_motor2,
            "turbo_dcac" : turbo_dcac,
            "turbo_dcac_motor2" : turbo_dcac_motor2,
            "turbo_amp" : turbo_amp,
            "turbo_amp_motor2" : turbo_amp_motor2,
            "turbo_avion_serie" : turbo_avion_serie,
            "turbo_avion_ciclos" : turbo_avion_ciclos,
            "turbo_avion_turm" : turbo_avion_turm,
            "turbo_avion_tt" : turbo_avion_tt,
            "turbo_motor_serie" : turbo_motor_serie,
            "turbo_motor_ciclos" : turbo_motor_ciclos,
            "turbo_motor_turm" : turbo_motor_turm,
            "turbo_motor_tt" : turbo_motor_tt,
            "turbo_helice_serie" : turbo_helice_serie,
            "turbo_helice_ciclos" : turbo_helice_ciclos,
            "turbo_helice_turm" : turbo_helice_turm,
            "turbo_helice_tt" : turbo_helice_tt,
            "turbo_fflow_in" : turbo_fflow_in,
            "turbo_fflow_in_motor2" : turbo_fflow_in_motor2,
            "turbo_fflow_out" : turbo_fflow_out,
            "turbo_fflow_out_motor2" : turbo_fflow_out_motor2
        
        ]
        
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do{
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
             print("Actualizado el instrumento Turbo desde Batch")
        }
            catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    
    //MARK: -  Pasajeros Core Data
    
    func obtenerIdPax(bitacora: NSNumber, matricula: String) -> NSNumber {
        
        let cdh : CoreDataHelper = CoreDataHelper()

        var IdPax : NSNumber = 0
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
        fetchRequest.predicate = NSPredicate(format: "matricula=%@ and idbitacora=%@", argumentArray: [matricula, bitacora])
        do{
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [BitacorasPax]
            IdPax = (NSNumber(value: fetchResults!.count + 1))
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return IdPax
        
    }
    
    func obtenerTotalPaxVuelo(legid: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VuelosPasajeros")
        let predicate = NSPredicate(format: "legid=='\(legid)'")
        fetchRequest.predicate = predicate
        
        do{
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [VuelosPasajeros]
            
            print("Total pasajeros a pasar : \(String(describing: fetchResults?.count))")
            
           
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    func agregarPasajeroDeVuelosABitacoras(legid: String, idbitacora: NSNumber, idtramo: NSNumber, matricula: String){
      
        let cdh : CoreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VuelosPasajeros")
        let predicate = NSPredicate(format: "legid='\(legid)'")
        fetchRequest.predicate = predicate
        
        do{
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [VuelosPasajeros]
            
            if let aviones = fetchResults {
                
                self.borrarPasajerosBitacoras(idbitacora: idbitacora, matricula: matricula)
                
                var x = 1
                
                for pax in aviones{
                    
                    
                    let record = NSEntityDescription.insertNewObject(forEntityName: "BitacorasPax", into:  cdh.backgroundContext!) as! BitacorasPax
                    
                    record.idbitacora = idbitacora
                    record.idpax = x as NSNumber
                    record.idservidor = 0
                    record.idtramo = idtramo
                    record.nombre = pax.nombre
                    record.matricula = matricula
                    
                    x += 1
                    
                }
                
                cdh.saveContext(context: cdh.backgroundContext!)
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    func borrarPasajerosBitacoras() {
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
        do{
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [BitacorasPax]
            for bas in fetchResults
            {
                cdh.backgroundContext!.delete(bas)
            }
            
            cdh.saveContext(context: cdh.managedObjectContext)
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func borrarPasajerosBitacoras(idbitacora: NSNumber, matricula: String) {
        
        let context = self.managedObjectContext
        let coord = self.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
        fetchRequest.predicate = NSPredicate(format: "idbitacora=%@ and matricula=%@", argumentArray:  [idbitacora,matricula])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord!.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
        
    }
    
    func eliminarPasajero(idpax: NSNumber, bitacora: NSNumber, matricula: String){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        print(matricula)
        print(bitacora)
        print(idpax)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
        fetchRequest.predicate = NSPredicate(format: "idpax == %@ and matricula == %@ and idbitacora == %@", argumentArray: [ idpax, matricula, bitacora])
        
        do {
            let fetchResults = try cdh.backgroundContext!.fetch(fetchRequest) as! [BitacorasPax]
            print(fetchResults.count)
            if fetchResults.count > 0 {
                for bas in fetchResults
                {
                    cdh.backgroundContext!.delete(bas)
                }
            }
            
            cdh.saveContext(context: cdh.backgroundContext!)
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    func quitarPasajeros(idbitacora: NSNumber){
       
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasPax")
        fetchRequest.predicate = NSPredicate(format: "idbitacora = %@", idbitacora)
        
        do {
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as! [BitacorasPax]
            
                for bas in fetchResults
                {
                    cdh.managedObjectContext.delete(bas)
                }
                
                cdh.saveContext(context: cdh.managedObjectContext)
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }

        
        
    }
    
    func actualizarPasajeroSincronizado(idpax: NSNumber, idservidor: NSNumber) {
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "BitacorasPax", in: cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idpax = %@", idpax)
        request.propertiesToUpdate = [
            "idservidor" : idservidor
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Actualizado desde Batch")
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    
    // MARK: - Reportes Bitacoras
    
    func agregarReportes(idbitacora: NSNumber, matricula: String, mantenimientodgac: String, mantenimientointerno: String, motivo : String, prevuelo: String, prevuelolocal: NSNumber){
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Bitacoras", in: cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idbitacora = %@ and matricula=%@", argumentArray: [idbitacora, matricula])
        request.propertiesToUpdate = [
            
            
            "mantenimientodgac" : mantenimientodgac,
            "mantenimientointerno" : mantenimientointerno,
            "accioncorrectiva" : motivo,
            "quienprevuelo" : prevuelo,
            "prevuelolocal" : prevuelolocal
            
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
            print("Actualizado reportes desde Batch")
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    
    // MARK: - Tiempo de Vuelo por Fecha
    
    func obtenerHorasVuelo() -> String {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        
        var horasvuelo : Double = 0
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
        
        do{
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [BitacorasLegs]
            
            if let tramos = fetchResults {
                
                for row in tramos {
                    
                   horasvuelo += row.tv as! Double
                    
                }
                
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        let formato : NumberFormatter = NumberFormatter()
        formato.decimalSeparator = "."
        formato.maximumFractionDigits = 1
        formato.numberStyle = .decimal
        
        
        return formato.string(from: NSNumber(value: horasvuelo))!
    }
    
    func obtenerHorasPorDias(dias: Int) -> String {
        
        let cdh : CoreDataHelper = CoreDataHelper()
        let today = NSDate()
        let tomorrow  = NSCalendar.current.date(byAdding: Calendar.Component.calendar, value: 1, to: today as Date)
        //dateByAddingUnit(.Day, value: 1, toDate: today, options: NSCalendar.Options.WrapComponents)
        print(tomorrow ?? today)
        
        var horasvuelo : Double = 0
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bitacoras")
        fetchRequest.predicate = NSPredicate(format: "fechavuelo > %@", tomorrow! as CVarArg)
        
        do{
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Bitacoras]
           
            if let flight = fetchResults {
                for item in flight {
                    do{
                        let tramosrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitacorasLegs")
                        tramosrequest.predicate = NSPredicate(format: " idbitacora = %@ ", item.idbitacora!)
                        
                        let tramosresult = try cdh.managedObjectContext.fetch(tramosrequest) as? [BitacorasLegs]
                        
                        if let tramos = tramosresult {
                            
                            for row in tramos {
                                
                                horasvuelo += row.tv as! Double
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        
        
        let formato : NumberFormatter = NumberFormatter()
        formato.decimalSeparator = "."
        formato.maximumFractionDigits = 1
        formato.numberStyle = .decimal
        
        
        return formato.string(from: NSNumber(value: horasvuelo))!
    }
    
    
    // MARK: - Logs
    
    func addLogs(numbitacora : NSNumber, matricula: String, url: String, error: Bool){
        
         let cdh : CoreDataHelper = CoreDataHelper()
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "Logs", into: cdh.backgroundContext!) as! Logs
        
        record.numbitacora = numbitacora
        record.matricula = matricula
        record.url = url
        record.error = error as NSNumber?
        
        cdh.saveContext(context: cdh.backgroundContext!)
        
    }
    
    
    // MARK: - Pilotos
    
    func existePiloto(idpiloto: String) -> Bool {
        let cdh : CoreDataHelper = CoreDataHelper()
        var Existe = false
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pilotos")
            fetchRequest.predicate = NSPredicate(format: "idpiloto = %@", argumentArray: [idpiloto])
            
            let fetchResults = try cdh.managedObjectContext.fetch(fetchRequest) as? [Pilotos]
            
            if let persons = fetchResults{
                
                for person in persons{
                    Existe = true
                    //print(person.idpiloto as Any)
                }
            }
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
        return Existe
    }
    
    func agregarPiloto(idpiloto: String, correo: String, nombre: String, licencia: String){
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "Pilotos", into: cdh.backgroundContext!) as! Pilotos
        record.idpiloto = idpiloto
        record.correo = correo
        record.licencia = licencia
        record.nombre = nombre
        
        cdh.saveContext(context: cdh.backgroundContext!)
    }
    
    func actualizaPiloto(idpiloto: String, correo: String, nombre: String, licencia: String){
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let entidad : NSEntityDescription = NSEntityDescription.entity(forEntityName: "Pilotos", in: cdh.backgroundContext!)!
        
        let request : NSBatchUpdateRequest = NSBatchUpdateRequest(entity: entidad)
        request.predicate = NSPredicate (format: "idpiloto = %@", idpiloto)
        request.propertiesToUpdate = [
            "correo" : correo,
            "nombre" : nombre,
            "licencia" : licencia
        ]
        request.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        
        do {
            try cdh.backgroundContext!.execute(request)
            cdh.saveContext(context: cdh.backgroundContext!)
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
    }
    
    func eliminarPilotosMatricula(matricula: String){
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AvionesAsignados")
        fetchRequest.predicate = NSPredicate(format: "matricula == %@", argumentArray: [matricula])
        
        do {
            let fetchResults = try cdh.backgroundContext!.fetch(fetchRequest) as! [AvionesAsignados]

            if fetchResults.count > 0 {
                for bas in fetchResults
                {
                    cdh.backgroundContext!.delete(bas)
                }
            }
            
            cdh.saveContext(context: cdh.backgroundContext!)
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        
    }
    
    func agregarPilotoMatricula(idpiloto: String, matricula: String){
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "AvionesAsignados", into: cdh.backgroundContext!) as! AvionesAsignados
        record.idpiloto = idpiloto
        record.matricula = matricula
        
        cdh.saveContext(context: cdh.backgroundContext!)
    }
    
    func obtienePilotosMatricula(matricula: String) -> Array<AnyObject>{
        var RelacionPilotosMatricula : Array<AnyObject> = []
        let cdh : CoreDataHelper = CoreDataHelper()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AvionesAsignados")
        fetchRequest.predicate = NSPredicate(format: "matricula == %@", argumentArray: [matricula])
        
        do {
            let fetchResults = try cdh.backgroundContext!.fetch(fetchRequest) as! [AvionesAsignados]
            
            if fetchResults.count > 0 {
                for bas in fetchResults as [AvionesAsignados]
                {
                    let Piloto = bas.idpiloto!
                    
                }
            }
            RelacionPilotosMatricula = fetchResults
        }
        catch let error as NSError{
            Util.invokeAlertMethod(strTitle: "Error", strBody: error.description as NSString, delegate: self)
        }
        return RelacionPilotosMatricula
    }
    
    func pilotosPorSincronizar(){
        
            var results : NSArray!
            if Conexion.isConnectedToNetwork() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true

                let wsURL = URL(string: parametros.host + "/json?asp=getPilotosMatricula&matricula=\(global_var.j_usuario_idPiloto)")
                
                let data = try! Data(contentsOf: wsURL!)
                //print("datos\(String(describing: data))")
                if let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary) as NSDictionary??)  {
                    if(json!.count > 0){
                        results = json!["Matriculas"] as! NSArray
                        if (results.count > 0){
                            for i in 0 ..< results.count {
                                var collectionMatricula = results[i] as! NSDictionary
                                var pilotos : NSArray!
                                pilotos = collectionMatricula["Pilotos"] as! NSArray
                                let Matricula = collectionMatricula["Matricula"] as! String
                                
                                self.eliminarPilotosMatricula(matricula: Matricula)
                                if (pilotos.count > 0){
                                    for x in 0 ..< pilotos.count {
                                        
                                        let row = pilotos[x] as! NSDictionary
                                        
                                        if(self.existePiloto(idpiloto: row["IDPiloto"] as! String) == false){
                                            
                                            self.agregarPiloto(idpiloto: row["IDPiloto"] as! String, correo: row["Correo"] as! String, nombre: row["Nombre"] as! String, licencia: row["NoLicencia"] as! String)
                                        }else{
                                            
                                            self.actualizaPiloto(idpiloto: row["IDPiloto"] as! String, correo: row["Correo"] as! String, nombre: row["Nombre"] as! String, licencia: row["NoLicencia"] as! String)
                                        }
                                        let idpiloto = row["IDPiloto"] as! NSString
                                        if (Int(idpiloto.intValue) == global_var.j_usuario_idPiloto ){
                                            global_var.j_piloto_nombre = row["Nombre"] as! String
                                            global_var.j_piloto_licencia = row["NoLicencia"] as! String
                                            global_var.j_piloto_id = row["IDPiloto"] as! String
                                        }
                                        //print(row["Nombre"] as! String)
                                        self.agregarPilotoMatricula(idpiloto: row["IDPiloto"] as! String, matricula: Matricula)
                                    }
                                }
                            } //Termina for
                        } //Termina if
                    }
                }//Termina if
        }
    }
}
