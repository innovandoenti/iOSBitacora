//
//  LoginClass.swift


import Foundation

struct parametros {
    
    static var host : String = "http://webbitacora.innovandoenti.com"
    static var typeJson : String = "type=json"
   
    
}

struct acciones {
 
    static var typeJson : String = "type=json"
    static var getVersion : String = parametros.host + "/json?asp=verifica_version"
    static var validateId : String = parametros.host + "/validateId/"
    static var getAviones : String = parametros.host + "/json?asp=verificar_aviones_sincronizar&idpiloto=\(global_var.j_usuario_idPiloto)"
}

struct versionApp : Decodable {
    
    let activa : Bool
    let version : String
    let fuv : Date
    
}

struct validausuario : Decodable {
    
}

struct EstatusResultado : Decodable {
    let exitoso : Bool
    let mensaje : String
    let returnid : Int
}

struct global_var {
    
        
    static var j_usuario_nombre : String = ""
    static var j_usuario_clave : String = ""
    static var j_usuario_perfil : String = ""
    static var j_usuario_inicio : Int = 0
    static var j_usuario_idPiloto : Int = 0
    static var j_usuario_token : String = ""
    static var j_usuario_yaregistro : Bool = false
    
    /* Variables matriculas */
    
    static var j_avion_matricula : String  = ""
    static var j_avion_fabricante : String = ""
    static var j_avion_modelo : String = ""
    static var j_avion_ano: String  = ""
    static var j_avion_tipomotor : String = ""
    static var j_avion_totalmotor : NSNumber = 0
    static var j_avion_totalpax : NSNumber = 0
    static var j_avion_numeroserie : String = ""
    static var j_avion_pesooperacion : NSNumber = 0
    static var j_avion_ultimabitacora : NSNumber = 0
    static var j_avion_ultimodestino : String = ""
    static var j_avion_ultimohorometro : NSNumber = 0
    static var j_avion_ultimohorometroapu : NSNumber = 0
    static var j_avion_mtow : Float = 0
    static var j_avion_tipomotor_sincronizar : String = ""
    static var j_avion_tipofuel : Int = 0 //AVGAS or JET A1
    static var j_avion_pesofuel : Int = 0 //LTS or GLN
    static var j_avion_unidadpesofuel : NSNumber = 0 //LBS or KGS
    static var j_avion_unidadpesoavion : NSNumber = 0
    static var j_avion_sincronizado : NSNumber = 0
    static var j_avion_ultimoaterrizaje : NSNumber = 0
    static var j_avion_ultimociclo : NSNumber = 0
    
    
    /* Variables Bitacoras */
    static var j_bitacoras_Id : NSNumber = 0
    static var j_bitacoras_idservidor : NSNumber = 0
    static var j_bitacora_num : NSNumber = 0
    static var j_bitacora_abierta : NSNumber = 0
    static var j_bitacora_mantenimientoInterno : String = ""
    static var j_bitacora_mantenimientoDGAC : String = ""
    static var j_bitacora_motivo : String = ""
    static var j_bitacora_nombreTecnico : String = ""
    static var j_bitacora_firmaTecnico : String = ""
    static var j_bitacora_legid : String = ""
    static var j_bitacora_fecha : NSDate = NSDate()
    static var j_bitacora_cliente : String = ""
    static var j_bitacora_matricula : String = ""
    static var j_bitacoras_ifr : NSNumber = 0
    static var j_bitacora_modificada : NSNumber = 0
    static var j_bitacora_nummodificada : NSNumber = 0
    static var j_bitacora_statussincronizacion : Bool = false
    static var j_bitacora_hoy : NSNumber = 0
    static var j_bitacora_totalaterrizajes : NSNumber = 0
    static var j_bitacora_ciclos : NSNumber = 0
    static var j_bitacora_nombrecopiloto : String = ""
    static var j_bitacora_licenciacopiloto : String = ""
    static var j_bitacora_prevuelo : String = ""
    static var j_bitacora_prevuelolocal : NSNumber = 0
    
    static var j_bitacora_nombrepiloto : String = ""
    static var j_bitacora_licenciapiloto : String = ""
    static var j_bitacora_idpiloto : String = ""

    static var j_bitacora_ultima_bitacora : NSNumber = 0
    static var j_bitacora_ultimo_destino : String = ""
    static var j_bitacora_ultimo_horometro : NSNumber = 0
    static var j_bitacora_ultimo_horometro_apu : NSNumber = 0
    static var j_bitacora_ultimo_aterrizaje : NSNumber = 0
    static var j_bitacora_ultimo_ciclo : NSNumber = 0
    
    
    /* Variables Tramos */
    static var j_tramos_Id : NSNumber = 0
    
    /* Variables Instrumentos */
    
    static var j_instrumentos_Id : NSNumber = 0
    
    /* Variables Bitacoras Pasajeros */
    static var j_pasajeros_Id : NSNumber = 0
    
    
    /* Variables pilotos */
    static var j_piloto_nombre : String = ""
    static var j_piloto_licencia : String = ""
    static var j_piloto_id : String = ""
    static var j_copiloto_id : String = ""
    
    
    /* Variables Vuelos Airplane Manager */
    static var j_vuelo_tripnumber : String = ""
    static var j_vuelo_tailnumber : String = ""
    static var j_vuelo_customername : String = ""
    static var j_vuelo_aeropuertosale : String = ""
    static var j_vuelo_aeropuertollega : String = ""
    static var j_vuelo_horasale : String = ""
    static var j_vuelo_horallega : String = ""
    static var j_vuelo_distancia : String = ""
    static var j_vuelo_horavuelo : String = ""
    static var j_vuelo_horavuelodecimal : String = ""
    static var j_vuelo_legnumber : String = ""
    static var j_vuelo_status : String = ""
    static var j_vuelo_legid : String = ""
    static var j_vuelo_fecha : NSDate = NSDate()
    static var j_vuelo_copiloto : String = ""
    static var j_vuelo_prevuelo : String  = ""
    
    /* Variables Globales */
    
    static var j_procedencia : Int = 0
    
    static var j_fechaultimasincronizacion : String = ""
    static var j_statusconexion : String =  "Sin Conexión"
    static var j_version : Float  =  0.0
    static var j_puedenavegar : Int32 = 0
    static var j_existe_bitacora_por_sincronizar : Bool = false
    static var j_statusSincronizacion : Int32 = 0
    static var j_mostrar_mensaje_actualizacion : Bool = false
    
    /* Constantes Conversion Tables */
    
    static var j_avgas_lts_lbs : Float = 1.58
    static var j_avgas_lts_kgs : Float = 0.72
    static var j_avgas_gln_lbs : Float = 6.0
    static var j_avgas_gln_kgs : Float = 2.72
    
    static var j_jet_lts_lbs : Float = 1.76
    static var j_jet_lts_kgs : Float = 0.8
    static var j_jet_gln_kgs : Float = 3.0
    static var j_jet_gln_lbs : Float = 6.7
}
