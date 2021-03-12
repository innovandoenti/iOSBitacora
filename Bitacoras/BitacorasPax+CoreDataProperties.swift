//
//  BitacorasPax+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension BitacorasPax {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitacorasPax> {
        return NSFetchRequest<BitacorasPax>(entityName: "BitacorasPax")
    }

    @NSManaged public var idbitacora: NSNumber?
    @NSManaged public var idpax: NSNumber?
    @NSManaged public var idservidor: NSNumber?
    @NSManaged public var idtramo: NSNumber?
    @NSManaged public var matricula: String?
    @NSManaged public var nombre: String?

}
