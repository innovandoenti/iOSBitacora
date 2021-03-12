//
//  Logs+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension Logs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Logs> {
        return NSFetchRequest<Logs>(entityName: "Logs")
    }

    @NSManaged public var error: NSNumber?
    @NSManaged public var matricula: String?
    @NSManaged public var numbitacora: NSNumber?
    @NSManaged public var url: String?

}
