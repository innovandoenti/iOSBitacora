//
//  AvionesAsignados+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Paola Martínez on 15/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension AvionesAsignados {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvionesAsignados> {
        return NSFetchRequest<AvionesAsignados>(entityName: "AvionesAsignados")
    }

    @NSManaged public var matricula: String?
    @NSManaged public var idpiloto: String?

}
