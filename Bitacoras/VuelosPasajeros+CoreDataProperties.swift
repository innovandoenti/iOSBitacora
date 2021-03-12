//
//  VuelosPasajeros+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension VuelosPasajeros {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VuelosPasajeros> {
        return NSFetchRequest<VuelosPasajeros>(entityName: "VuelosPasajeros")
    }

    @NSManaged public var legid: String?
    @NSManaged public var nombre: String?

}
