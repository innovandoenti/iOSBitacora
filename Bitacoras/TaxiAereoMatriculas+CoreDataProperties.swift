//
//  TaxiAereoMatriculas+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Sistemas Aerotron on 20/04/18.
//  Copyright © 2018 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//
//

import Foundation
import CoreData


extension TaxiAereoMatriculas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaxiAereoMatriculas> {
        return NSFetchRequest<TaxiAereoMatriculas>(entityName: "TaxiAereoMatriculas")
    }

    @NSManaged public var ano: String?
    @NSManaged public var fabricante: String?
    @NSManaged public var matricula: String?
    @NSManaged public var modelo: String?
    @NSManaged public var mtow: NSNumber?
    @NSManaged public var numeroserie: String?
    @NSManaged public var pesooperacion: NSNumber?
    @NSManaged public var sincronizado: NSNumber?
    @NSManaged public var tipomotor: String?
    @NSManaged public var totalmotor: NSNumber?
    @NSManaged public var totalpax: NSNumber?
    @NSManaged public var ultimabitacora: NSNumber?
    @NSManaged public var ultimoaterrizaje: NSNumber?
    @NSManaged public var ultimoaterrizajem2: NSNumber?
    @NSManaged public var ultimociclo: NSNumber?
    @NSManaged public var ultimociclom2: NSNumber?
    @NSManaged public var ultimodestino: String?
    @NSManaged public var ultimohorometro: NSNumber?
    @NSManaged public var ultimohorometroapu: NSNumber?
    @NSManaged public var unidadpesos: NSNumber?
    @NSManaged public var status: NSNumber?

}
