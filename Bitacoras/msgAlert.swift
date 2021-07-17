//
//  msgAlert.swift
//  Bitacoras
//
//  Created by Jaime Solis on 15/03/21.
//

import Foundation

public class Alertas {

    public func displayAlert(title: String, msg: String){
    // Declare Alert message
           let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
           
           // Create OK button with action handler
           let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
               print("Ok button tapped")
               
           })
           
           // Create Cancel button with action handlder
        _ = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
               print("Cancel button tapped")
           }
           
           //Add OK and Cancel button to dialog message
           dialogMessage.addAction(ok)
           
           // Present dialog message to user
            dialogMessage.present(animated: true, completion: nil)
           
}
}
