//
//  AppDelegate.swift


import UIKit
import CoreData
import QuartzCore
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var customAllowedSet = CharacterSet.init(charactersIn: "()'&+=\"#%/<>?@\\^`{|}").inverted
    var window: UIWindow?
    let coreDataStack = CoreDataStack()
    var notificacion : NSNotification!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        applyTheme()
        
        //Reachability
        do {
            Network.reachability = try Reachability(hostname: "intranet.aerotron.com.mx")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        // Notifications
        _ = OneSignal(launchOptions: launchOptions, appId: "0928d124-1fa1-42bd-b6fa-0da975121e19", handleNotification: nil)
        
        OneSignal.defaultClient().enable(inAppAlertNotification: true)
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions, completionHandler: {_,_ in })
        } else {
            // Fallback on earlier versions
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        //Versión
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        global_var.j_version = (version as NSString).floatValue
        
        print("Version: \(version)")
        
        // Usuario
        let yaexiste =  coreDataStack.verificaHayUsuario()
        if(yaexiste == 1){
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            var destViewController : UIViewController
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
            self.window?.rootViewController =  destViewController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            var destViewController : UIViewController
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "vc_iniciar")
            self.window?.rootViewController = destViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
   
    // #pragma mark - Core Data Helper
    
    lazy var cdstore: CoreDataStack = {
        let cdstore = CoreDataStack()
        return cdstore
    }()
    
    var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
    }()
    
    func applyTheme() {
        
        // Make all navigation bars in the app purple
        UINavigationBar.appearance().barTintColor = UIColor(red:0.03, green:0.17, blue:0.29, alpha:1.0)
        // Change tint color of navigation bars
        UINavigationBar.appearance().tintColor = UIColor(red:0.84, green:0.91, blue:0.96, alpha:1.0)
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColor(red:0.95, green:1.0, blue:0.57, alpha:1.0)])
        
        
        // Custom back icon
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back");
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back");
        
        // Adjust the back text for our new image
        //UIBarButtonItem.appearance().  setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 10.0, vertical: 0.0), for: .,,default);
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        _ = UIApplication.shared.currentUserNotificationSettings
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        
        global_var.j_usuario_token = token
    }
    
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print(error)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Recibi una notificacion remota")
        
        if let notification = userInfo["aps"] as? NSDictionary {
            print(notification["badge"]!)
            application.applicationIconBadgeNumber = (notification["badge"]! as AnyObject).integerValue
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            var destViewController : UIViewController
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
            destViewController.tabBarController?.tabBarItem.badgeValue = "\(notification["badge"]!)"
            self.window?.rootViewController = destViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("Notificación local")
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        self.coreDataStack.regresarBitacorasSincronizar()
        
        //Se quito esta opción para que fuera manual la sincronización
        //BitacorasPorSincronizar()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0;
        self.coreDataStack.regresarBitacorasSincronizar()
        self.coreDataStack.actualizando(idpiloto: NSNumber(value: global_var.j_usuario_idPiloto), actualizando: 0)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
           self.cdh.saveContext()
    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
