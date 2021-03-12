//
//  Notificacion.swift


import Foundation
import UserNotifications;

 class Notificationes {

    func registerLocal() {
    
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
                if (granted)
                {
                    //UIApplication.sharedApplication().registerForRemoteNotifications()
                    print("welcome")
                }
                else{
                    //Do stuff if unsuccessful...
                }
                })
        } else {
            // Fallback on earlier versions
            
        }
    }

    func NotificacionLocal(title: String, body: String, hour: Int, minutos: Int, dia: Int, mes: Int, año: Int, legid: String) {
    
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": legid]
            content.sound = UNNotificationSound.default
            
            let dateComponents = NSDateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minutos
            dateComponents.day = dia
            dateComponents.month = mes
            dateComponents.year = año
            
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents as DateComponents, repeats: false)
            //Cuando quieres que se repita a la misma hora, modificar el datecomponente
            
            let request = UNNotificationRequest(identifier: NSUUID().uuidString, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        
        } else {
            // Fallback on earlier versions
            let content = UILocalNotification()
            content.alertTitle = title
            content.alertBody = body
            content.category = "alarm"
            content.userInfo = ["customData": legid]
            content.soundName = "default" 
            
            let dateComponents = NSDateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minutos
            dateComponents.day = dia
            dateComponents.month = mes
            dateComponents.year = año
            
            let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let fecha = calender.date(from: dateComponents as DateComponents)
            
            content.fireDate = fecha
            UIApplication.shared.scheduleLocalNotification(content)
        }
        
      
    }
    
    
    func removeNotifications(){
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
             center.removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
            
            //Remove all Notification
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
       
    
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    }

}


