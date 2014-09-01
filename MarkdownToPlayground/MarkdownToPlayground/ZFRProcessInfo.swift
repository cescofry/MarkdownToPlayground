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
    
    class func allInfo() -> [String: String] {
        return info(full: true)
    }
    
    class func info() -> [String: String] {
        return info(full: false)
    }
    
    class func info(#full : Bool) -> [String: String] {
        let keys = ["HOME", "USER", "PWD"]
        var rawEnviroment: [NSObject : AnyObject] = NSProcessInfo.processInfo().environment
        var environment = [String: String]()
        for (key, value) in rawEnviroment {
            let stringKey = key as String
        
            if (!full && !contains(keys, stringKey)) {
                continue
            }
            
            environment[stringKey] = (value as String)
        }
        
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
            environment[key as String] = (arg as String)
        }
        
        return environment

    }
}