//
//  BitacorasLegs+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension BitacorasLegs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitacorasLegs> {
        return NSFetchRequest<BitacorasLegs>(entityName: "BitacorasLegs")
    }

    @NSManaged public var aceitecargado: NSNumber?
    @NSManaged public var aceitecargadoapu: NSNumber?
    @NSManaged public var aterrizajes: NSNumber?
    @NSManaged public var calzoacalzo: String?
    @NSManaged public var capitan_altimetrorvsm: NSNumber?
    @NSManaged public var ciclos: NSNumber?
    @NSManaged public var combustibleaterrizaje: NSNumber?
    @NSManaged public var combustiblecargado: NSNumber?
    @NSManaged public var combustibleconsumido: NSNumber?
    @NSManaged public var combustibledespegue: NSNumber?
    @NSManaged public var combustibleunidadmedida: String?
    @NSManaged public var combustibleunidadpeso: String?
    @NSManaged public var coordenadasregistradas: String?
    @NSManaged public var destino: String?
    @NSManaged public var destinociudad: String?
    @NSManaged public var horallegada: String?
    @NSManaged public var horasalida: String?
    @NSManaged public var horashelice: NSNumber?
    @NSManaged public var horasmotor: NSNumber?
    @NSManaged public var horasplaneador: NSNumber?
    @NSManaged public var horometroaterrizaje: NSNumber?
    @NSManaged public var horometrodespegue: NSNumber?
    @NSManaged public var idbitacora: NSNumber?
    @NSManaged public var idservidor: NSNumber?
    @NSManaged public var idtramo: NSNumber?
    @NSManaged public var matricula: String?
    @NSManaged public var nivelvuelo: NSNumber?
    @NSManaged public var numbitacora: NSNumber?
    @NSManaged public var oat: NSNumber?
    @NSManaged public var origen: String?
    @NSManaged public var origenciudad: String?
    @NSManaged public var pesoaterrizaje: NSNumber?
    @NSManaged public var pesocarga: NSNumber?
    @NSManaged public var pesocombustible: NSNumber?
    @NSManaged public var pesodespegue: NSNumber?
    @NSManaged public var pesooperacion: NSNumber?
    @NSManaged public var primeroficialaltimetrorvsm: String?
    @NSManaged public var tv: NSNumber?

}
