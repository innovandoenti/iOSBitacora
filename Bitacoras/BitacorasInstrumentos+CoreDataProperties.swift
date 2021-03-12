//
//  BitacorasInstrumentos+CoreDataProperties.swift
//  Bitacoras
//
//  Created by Jaime Solis on 04/05/17.
//  Copyright © 2017 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import Foundation
import CoreData


extension BitacorasInstrumentos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitacorasInstrumentos> {
        return NSFetchRequest<BitacorasInstrumentos>(entityName: "BitacorasInstrumentos")
    }

    @NSManaged public var idbitacora: NSNumber?
    @NSManaged public var idlectura: NSNumber?
    @NSManaged public var idservidor: NSNumber?
    @NSManaged public var idtramo: NSNumber?
    @NSManaged public var jet_amp: NSNumber?
    @NSManaged public var jet_amp_motor2: NSNumber?
    @NSManaged public var jet_apu_ciclos: NSNumber?
    @NSManaged public var jet_apu_serie: String?
    @NSManaged public var jet_apu_tt: NSNumber?
    @NSManaged public var jet_apu_turm: NSNumber?
    @NSManaged public var jet_avion_ciclos: NSNumber?
    @NSManaged public var jet_avion_serie: String?
    @NSManaged public var jet_avion_tt: NSNumber?
    @NSManaged public var jet_avion_turm: NSNumber?
    @NSManaged public var jet_dc: NSNumber?
    @NSManaged public var jet_dcac: NSNumber?
    @NSManaged public var jet_dcac_motor2: NSNumber?
    @NSManaged public var jet_fflow: NSNumber?
    @NSManaged public var jet_fflow_motor2: NSNumber?
    @NSManaged public var jet_fueltemp: NSNumber?
    @NSManaged public var jet_fueltemp_motor2: NSNumber?
    @NSManaged public var jet_hydvol: NSNumber?
    @NSManaged public var jet_hydvol_motor2: NSNumber?
    @NSManaged public var jet_ias: NSNumber?
    @NSManaged public var jet_itt: NSNumber?
    @NSManaged public var jet_itt_motor2: NSNumber?
    @NSManaged public var jet_lecturaaltimetro_capitan: NSNumber?
    @NSManaged public var jet_lecturaaltimetro_primeroficial: NSNumber?
    @NSManaged public var jet_motor1_ciclos: NSNumber?
    @NSManaged public var jet_motor1_serie: String?
    @NSManaged public var jet_motor1_tt: NSNumber?
    @NSManaged public var jet_motor1_turm: NSNumber?
    @NSManaged public var jet_motor2_ciclos: NSNumber?
    @NSManaged public var jet_motor2_serie: String?
    @NSManaged public var jet_motor2_tt: NSNumber?
    @NSManaged public var jet_motor2_turm: NSNumber?
    @NSManaged public var jet_n1: NSNumber?
    @NSManaged public var jet_n1_motor2: NSNumber?
    @NSManaged public var jet_n2: NSNumber?
    @NSManaged public var jet_n2_motor2: NSNumber?
    @NSManaged public var jet_oat: NSNumber?
    @NSManaged public var jet_oilpress: NSNumber?
    @NSManaged public var jet_oilpress_motor2: NSNumber?
    @NSManaged public var jet_oiltemp: NSNumber?
    @NSManaged public var jet_oiltemp_motor2: NSNumber?
    @NSManaged public var matricula: String?
    @NSManaged public var numbitacora: NSNumber?
    @NSManaged public var piston_aceite_mas: NSNumber?
    @NSManaged public var piston_aceite_mas_motor2: NSNumber?
    @NSManaged public var piston_ampers: NSNumber?
    @NSManaged public var piston_ampers_motor2: NSNumber?
    @NSManaged public var piston_cht: NSNumber?
    @NSManaged public var piston_cht_motor2: NSNumber?
    @NSManaged public var piston_crucero: NSNumber?
    @NSManaged public var piston_crucero_motor2: NSNumber?
    @NSManaged public var piston_egt: NSNumber?
    @NSManaged public var piston_egt_motor2: NSNumber?
    @NSManaged public var piston_flow: NSNumber?
    @NSManaged public var piston_flow_motor2: NSNumber?
    @NSManaged public var piston_fuelpress: NSNumber?
    @NSManaged public var piston_fuelpress_motor2: NSNumber?
    @NSManaged public var piston_manpress: NSNumber?
    @NSManaged public var piston_manpress_motor2: NSNumber?
    @NSManaged public var piston_oat: NSNumber?
    @NSManaged public var piston_oilpress: NSNumber?
    @NSManaged public var piston_oilpress_motor2: NSNumber?
    @NSManaged public var piston_rpm: NSNumber?
    @NSManaged public var piston_rpm_motor2: NSNumber?
    @NSManaged public var piston_temp: NSNumber?
    @NSManaged public var piston_temp_motor2: NSNumber?
    @NSManaged public var piston_volts: NSNumber?
    @NSManaged public var piston_volts_motor2: NSNumber?
    @NSManaged public var turbo_amp: NSNumber?
    @NSManaged public var turbo_amp_motor2: NSNumber?
    @NSManaged public var turbo_avion_ciclos: NSNumber?
    @NSManaged public var turbo_avion_serie: String?
    @NSManaged public var turbo_avion_tt: NSNumber?
    @NSManaged public var turbo_avion_turm: NSNumber?
    @NSManaged public var turbo_dcac: NSNumber?
    @NSManaged public var turbo_dcac_motor2: NSNumber?
    @NSManaged public var turbo_fflow: NSNumber?
    @NSManaged public var turbo_fflow_in: NSNumber?
    @NSManaged public var turbo_fflow_in_motor2: NSNumber?
    @NSManaged public var turbo_fflow_motor2: NSNumber?
    @NSManaged public var turbo_fflow_out: NSNumber?
    @NSManaged public var turbo_fflow_out_motor2: NSNumber?
    @NSManaged public var turbo_helice_ciclos: NSNumber?
    @NSManaged public var turbo_helice_serie: String?
    @NSManaged public var turbo_helice_tt: NSNumber?
    @NSManaged public var turbo_helice_turm: NSNumber?
    @NSManaged public var turbo_helicerpm: NSNumber?
    @NSManaged public var turbo_helicerpm_motor2: NSNumber?
    @NSManaged public var turbo_ias: NSNumber?
    @NSManaged public var turbo_ias_motor2: NSNumber?
    @NSManaged public var turbo_itt: NSNumber?
    @NSManaged public var turbo_itt_motor2: NSNumber?
    @NSManaged public var turbo_motor_ciclos: NSNumber?
    @NSManaged public var turbo_motor_serie: String?
    @NSManaged public var turbo_motor_tt: NSNumber?
    @NSManaged public var turbo_motor_turm: NSNumber?
    @NSManaged public var turbo_ng: NSNumber?
    @NSManaged public var turbo_ng_motor2: NSNumber?
    @NSManaged public var turbo_nivelvuelo: NSNumber?
    @NSManaged public var turbo_oat: NSNumber?
    @NSManaged public var turbo_oat_motor2: NSNumber?
    @NSManaged public var turbo_oilpress: NSNumber?
    @NSManaged public var turbo_oilpress_motor2: NSNumber?
    @NSManaged public var turbo_oiltemp: NSNumber?
    @NSManaged public var turbo_oiltemp_motor2: NSNumber?
    @NSManaged public var turbo_torque: NSNumber?
    @NSManaged public var turbo_torque_motor2: NSNumber?
    @NSManaged public var turbo_vi: NSNumber?
    @NSManaged public var turbo_vi_motor2: NSNumber?
    @NSManaged public var turbo_vv: NSNumber?
    @NSManaged public var turbo_vv_motor2: NSNumber?

}
