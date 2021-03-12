//
//  Datos+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension Datos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Datos> {
        return NSFetchRequest<Datos>(entityName: "Datos")
    }

    @NSManaged public var descripcion: String?
    @NSManaged public var iddata: NSNumber?

}
