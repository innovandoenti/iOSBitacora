//
//  TVC_VuelosPasajerosTableViewController.swift
//  Bitacoras
//
//  Created by Jaime Solis on 20/05/16.
//  Copyright © 2016 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit
import CoreData


class TVC_VuelosPasajerosTableViewController: UITableViewController {
    
    var dictionary : NSDictionary!
    var dataSource : NSDictionary!
    var dt : Array<AnyObject> = []
    var searchResultados : NSArray!
    var searchActive : Bool = false
    var logica = Util()
    var coreDataStack = CoreDataStack()
    var menu : UIBarButtonItem = UIBarButtonItem()
    var agregar : UIBarButtonItem = UIBarButtonItem()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        
        cargarPax()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargarPax(){
        
            dt.removeAll(keepingCapacity: false)
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VuelosPasajeros")
            request.predicate = NSPredicate(format: "legid = %@ ", argumentArray: [global_var.j_vuelo_legid])
            
            dt = try! coreDataStack.managedObjectContext.fetch(request) as Array<AnyObject>
            
            print("Total Pax: \(dt.count)")
            
            tableView.reloadData()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dt.count
    }
    
    @IBAction func Cerrar(sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var altura : CGFloat = 0
        if DeviceType.IS_IPAD {
            altura = 90
        }else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P {
            altura = 60
        }else{
            altura = 90
        }
        
        return altura
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TVC_VuelosPasajerosTableViewCell
            
            cell.backgroundColor = UIColor.clear
            
            if let row = dt[(indexPath as NSIndexPath).row] as? VuelosPasajeros {
                
                print(row.nombre!)
                cell.Nombre.text = row.nombre!
        }
            return cell
        
       
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Pasajeros"
    }
    
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
