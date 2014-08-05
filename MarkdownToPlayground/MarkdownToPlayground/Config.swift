//
//  Config.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 7/2/14.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

class MTPConfig {
    var markDownFile : String?
    var userPath : String?
    let output : String?
    let customCSS : String?
    let help : AnyObject!
    
    init() {
        
        let env = ZFRProcessInfo.info()
        
        markDownFile = env["0"] as? String
        userPath = env["PWD"] as? String
        output = env["o"] as? String
        customCSS = env["css"] as? String
        help = env["help"]
        
        
        if output != nil {
            userPath = output
        }
        
        
        if !markDownFile!.hasPrefix("/") && !markDownFile!.hasPrefix("~") {
            markDownFile = userPath!.stringByAppendingPathComponent(markDownFile!)
        }
    }
    
}


extension String {
    var lenght : Int {
    get {
        return countElements(self)
    }
    }
}
