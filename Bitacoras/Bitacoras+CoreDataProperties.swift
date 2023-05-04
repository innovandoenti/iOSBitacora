//
//  Bitacoras+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Paola Martínez on 17/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension Bitacoras {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bitacoras> {
        return NSFetchRequest<Bitacoras>(entityName: "Bitacoras")
    }

    @NSManaged public var accioncorrectiva: String?
    @NSManaged public var aterrizajes: NSNumber?
    @NSManaged public var capitan: String?
    @NSManaged public var capitanlicencia: String?
    @NSManaged public var capitannombre: String?
    @NSManaged public var ciclos: NSNumber?
    @NSManaged public var ciclosapu: NSNumber?
    @NSManaged public var cliente: String?
    @NSManaged public var copiloto: String?
    @NSManaged public var copilotonombre: String?
    @NSManaged public var fecharegistro: NSDate?
    @NSManaged public var fechavuelo: NSDate?
    @NSManaged public var horometroapu: NSNumber?
    @NSManaged public var horometrollegada: NSNumber?
    @NSManaged public var horometrosalida: NSNumber?
    @NSManaged public var hoy: NSNumber?
    @NSManaged public var idbitacora: NSNumber?
    @NSManaged public var idservidor: NSNumber?
    @NSManaged public var ifr: NSNumber?
    @NSManaged public var legid: NSNumber?
    @NSManaged public var licenciatecnico: String?
    @NSManaged public var mantenimientodgac: String?
    @NSManaged public var mantenimientointerno: String?
    @NSManaged public var matricula: String?
    @NSManaged public var modificada: NSNumber?
    @NSManaged public var modificadatotal: NSNumber?
    @NSManaged public var nocturno: String?
    @NSManaged public var nombretecnico: String?
    @NSManaged public var numbitacora: NSNumber?
    @NSManaged public var prevuelolocal: NSNumber?
    @NSManaged public var quienprevuelo: String?
    @NSManaged public var reportes: String?
    @NSManaged public var serie: String?
    @NSManaged public var sincronizado: NSNumber?
    @NSManaged public var status: NSNumber?
    @NSManaged public var totalaterrizajes: NSNumber?
    @NSManaged public var tv: NSNumber?
    @NSManaged public var usuario: String?

}
