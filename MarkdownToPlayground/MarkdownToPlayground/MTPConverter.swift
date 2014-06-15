//
//  MTPConverter.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

let MTPCodeScannerToken = "```"

class MTPConverter {
    
    class func htmlFromMarkdown(markdown: String?) -> Dictionary<String, String> {
        
        var result = Dictionary<String, String>()
        var scanner = NSScanner(string: markdown!)
        var index = 0
        
        while scanner.atEnd {
            var mkdown : NSString? = nil
            scanner.scanUpToString(MTPCodeScannerToken, intoString: &mkdown)
            
            // HTML Section
            if mkdown {
                scanner.scanUpToString(MTPCodeScannerToken, intoString: nil)
                var html = MMMarkdown.HTMLStringWithMarkdown(mkdown, error: nil)
                
                if html {
                    let key = "section-\(index).html"
                    html = wrapHTML(html, title: key)
                    result[key] = html
                    index++
                }
            }
            
            var code : NSString? = nil
            scanner.scanUpToString(MTPCodeScannerToken, intoString: &code)
            
            // Swift
            if code {
                scanner.scanUpToString(MTPCodeScannerToken, intoString: nil)
                let key = "section-\(index).swift"
                result[key] = code!
                index++
            }
        }
        
        if result.count == 0 {
            NSLog("No Code block found!")
            let key = "section-\(index).html"
            var html = MMMarkdown.HTMLStringWithMarkdown(markdown, error: nil)
            if html {
                let key = "section-\(index).html"
                html = wrapHTML(html, title: key)
                result[key] = html
            }
        }
        
        return result
    }
    
    class func wrapHTML(html: String, title: String) -> String {
        return NSString(format: HTML_FORMAT, title, html)
    }
}