//
//  EstadisticasTableViewController.swift
//  Bitacoras
//
//  Created by Jaime Solis on 13/01/16.
//  Copyright © 2016 Servicios Aereos Corporativos S.A. de C.V. All rights reserved.
//

import UIKit

class EstadisticasTableViewController: UITableViewController {

    let coredata = CoreDataStack()
    
    @IBOutlet weak var AllEntries: UILabel!
    @IBOutlet weak var SevenDays: UILabel!
    @IBOutlet weak var TwentyEightDays: UILabel!
    @IBOutlet weak var SixMonthDays: UILabel!
    @IBOutlet weak var TwelveDays: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargarInformacion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cargarInformacion()
    }
    
    func cargarInformacion(){
        
        AllEntries.text = coredata.obtenerHorasVuelo()
        SevenDays.text = coredata.obtenerHorasPorDias(dias: -7)
        TwentyEightDays.text  = coredata.obtenerHorasPorDias(dias: -28)
        SixMonthDays.text = coredata.obtenerHorasPorDias(dias: -180)
        TwelveDays.text = coredata.obtenerHorasPorDias(dias: -365)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var altura : CGFloat = 90
        if DeviceType.IS_IPAD{
            altura =  90
        }else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6P {
            altura =  60
        }else{
            altura = 90
        }
        
        return altura
    
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var altura : CGFloat = 90
        if DeviceType.IS_IPAD{
            altura =  90
        }else if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6P {
            altura =  60
        }else{
            altura = 90
        }
        
        return altura
        
    }
    
    
    
    
    
    
    /*
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            AllEntries.text  = "0"
        

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
