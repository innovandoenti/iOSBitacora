//
//  Vuelos+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension Vuelos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vuelos> {
        return NSFetchRequest<Vuelos>(entityName: "Vuelos")
    }

    @NSManaged public var aeropuertollega: String?
    @NSManaged public var aeropuertosale: String?
    @NSManaged public var customername: String?
    @NSManaged public var distancia: String?
    @NSManaged public var fecha: NSDate?
    @NSManaged public var horallega: String?
    @NSManaged public var horasale: String?
    @NSManaged public var horavuelo: String?
    @NSManaged public var horavuelodecimal: String?
    @NSManaged public var legid: String?
    @NSManaged public var legnumber: String?
    @NSManaged public var prevuelo: String?
    @NSManaged public var sincronizado: NSNumber?
    @NSManaged public var status: NSNumber?
    @NSManaged public var tailnumber: String?
    @NSManaged public var tripnumber: String?

}
