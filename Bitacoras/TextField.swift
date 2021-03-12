//
//  TextField.swift


import UIKit

class TextField: UITextField {

    /* 8
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
        return []
    }
    */
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return super.canPerformAction(action, withSender: sender)
    }
   

}
