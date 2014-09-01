//
//  ZFRProcessInfo.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//

import Foundation

class ZFRProcessInfo {
    
//    var home : String
//    var user: String
//    var pwd: String
    
    class func allInfo() -> NSDictionary {
        return info(full: true)
    }
    
    class func info() -> NSDictionary {
        return info(full: false)
    }
    
    class func info(#full : Bool) -> NSDictionary {
        let keys = ["HOME", "USER", "PWD"]
        var environment : NSDictionary = NSProcessInfo.processInfo().environment
        if (!full) {
            environment = environment.dictionaryWithValuesForKeys(keys)
        }
        
        var result = environment.mutableCopy() as NSMutableDictionary
        
        var pendingKey : String?;
        var unkeyedIndex  = 0
        let args = NSProcessInfo.processInfo().arguments
        for  (index, value : AnyObject) in enumerate(args){
            let arg = value as NSString
            if arg.hasPrefix("-") {
                pendingKey = arg.substringFromIndex(1)
                continue
            }
            
            if index == 0 {
                pendingKey = "build_path"
            }
            
            var key : NSString
            if var mutKey : NSString = pendingKey {
                while mutKey.hasPrefix("-") {
                    mutKey = mutKey.substringFromIndex(1)
                }
                key = mutKey
                pendingKey = nil
            }
            else {
                key = "\(unkeyedIndex)"
                unkeyedIndex++
            }
            result[key] = arg
        }
        
        return result.copy() as NSDictionary

    }
}