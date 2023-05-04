//
//  Pilotos+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Paola Martínez on 11/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension Pilotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pilotos> {
        return NSFetchRequest<Pilotos>(entityName: "Pilotos")
    }

    @NSManaged public var idpiloto: String?
    @NSManaged public var correo: String?
    @NSManaged public var nombre: String?
    @NSManaged public var licencia: String?

}
