//
//  Ajustes+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension Ajustes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ajustes> {
        return NSFetchRequest<Ajustes>(entityName: "Ajustes")
    }

    @NSManaged public var clave: String?
    @NSManaged public var correo: String?
    @NSManaged public var idpiloto: String?
    @NSManaged public var licencia: String?
    @NSManaged public var nombre: String?
    @NSManaged public var perfil: String?
    @NSManaged public var registrado: String?
    @NSManaged public var telefono: String?
    @NSManaged public var tokenregistrado: String?
    @NSManaged public var ultimasincronizacion: NSDate?
    @NSManaged public var actualizando: NSNumber?

}
