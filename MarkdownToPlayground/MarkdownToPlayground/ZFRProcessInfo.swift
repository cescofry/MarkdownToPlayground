//
//  ZFRProcessInfo.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

class ZFRProcessInfo {
    
    class func allInfo() -> NSDictionary {
        return info(full: true)
    }
    
    class func info() -> NSDictionary {
        return info(full: false)
    }
    
    class func info(#full : Bool) -> NSDictionary {
        let keys = ["HOME", "USER", "PWD"]
        var environment = NSProcessInfo.processInfo().environment!
        if (!full) {
            environment = environment.dictionaryWithValuesForKeys(keys)
        }
        
        
        var pendingKey : String?;
        var unkeyedIndex  = 0
        let args = NSProcessInfo.processInfo().arguments!
        for  (index, value : AnyObject) in enumerate(args){
            let arg = value as String
            if arg.hasPrefix("-") {
                pendingKey = arg.substringFromIndex(1)
                continue
            }
            
            if index == 0 {
                pendingKey = "build_path"
            }
            
            var key : String
            if var mutKey = pendingKey {
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
            environment.setValue(arg, forKey: key)
        }
        
        return environment

    }
}