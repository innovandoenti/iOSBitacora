//
//  StringSplit.swift


import Foundation


extension String {
    
    public func split(separator: String) -> [String] {
        if separator.isEmpty {
            return self.map { String($0) }
        }
        
        return self.components(separatedBy: separator)
    }
    
   
}
