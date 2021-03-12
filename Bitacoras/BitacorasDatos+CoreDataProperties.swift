//
//  BitacorasDatos+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension BitacorasDatos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitacorasDatos> {
        return NSFetchRequest<BitacorasDatos>(entityName: "BitacorasDatos")
    }

    @NSManaged public var ciclos: NSNumber?
    @NSManaged public var dato: String?
    @NSManaged public var idtramo: NSNumber?
    @NSManaged public var matricula: String?
    @NSManaged public var numbitacora: NSNumber?
    @NSManaged public var serie: String?
    @NSManaged public var tt: NSNumber?
    @NSManaged public var turm: NSNumber?

}
