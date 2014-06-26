//
//  MTPConverter.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//

import Foundation

let MTPCodeScannerImportToken = "#import "
let MTPCodeScannerToken = "```"
let MTPCodeScannerSwiftToken = "swift"

class MTPConverter {

    var scanner : NSScanner
    var result : Dictionary<String, String>
    var scanIndex: NSInteger = 0
    var userPath: String
    
    init(markDown: String?, userPath: String?) {
        self.userPath = userPath!
        self.scanner = NSScanner(string: markDown)
        self.result = Dictionary<String, String>()
    }
    
    func scanPattern(pattern: String?) -> String? {
        
        var result : NSString? = nil
        self.scanner.scanUpToString(pattern, intoString: &result)

        if result {
            self.scanner.scanString(pattern, intoString: nil)
        }
       return result
    }
    
    func addResource(resource: String?, type: String?) {
        let key = currentKey(type)
        self.result[key] = resource
        self.scanIndex++
    }
    
    func currentKey(type: String?) -> String {
        return "section-\(self.scanIndex).\(type!)"
    }
    

    
    func htmlFromMarkdown() -> Dictionary<String, String> {
        
        // Import clasees
        /*
        var lastImportPosition = 0
        while !self.scanner.atEnd {
            let hasImportClass = scanPattern(MTPCodeScannerImportToken)
            
            println(">>> \(hasImportClass) : \(self.scanner.scanLocation)")
            
            if hasImportClass {
                let importClass = scanPattern("\n")
                
                if importClass {
                    let classText = swiftCodeFromImport(importClass)
                    addResource(classText, type: "swift")
                    lastImportPosition = self.scanner.scanLocation
                }
                
            }
        }
        self.scanner.scanLocation = lastImportPosition
*/
        
        
        while !self.scanner.atEnd {
            
            println(">>>\(self.scanner.scanLocation)")
            
            var mkdown = scanPattern(MTPCodeScannerToken)
        
            // HTML Section
            if mkdown {
                var html = MMMarkdown.HTMLStringWithMarkdown(mkdown, error: nil)
                
                if html {
                    html = wrapHTML(html)
                    addResource(html, type: "html")
                }
            }
            
            var code : NSString? = self.scanPattern(MTPCodeScannerToken)
            
            // Swift
            if code {
                if code!.hasPrefix(MTPCodeScannerSwiftToken) {
                    code = code!.substringFromIndex(countElements(MTPCodeScannerSwiftToken))
                }
                
                addResource(code, type: "swift")
            }
        }
        
        if result.count == 0 {
            println("No Code block found!")
            var html = MMMarkdown.HTMLStringWithMarkdown(scanner.string, error: nil)
            html = wrapHTML(html)
            addResource(html, type: "html")
        }
        
        var html = appendFooterToHTML("")
        html = wrapHTML(html)
        addResource(html, type: "html")

        return result
    }
    
    func wrapHTML(html: String) -> String {
        let key = currentKey("html")
        return NSString(format: HTML_FORMAT, key, html)
    }
    
    func appendFooterToHTML(html: String) -> String {
        return html + FOOTER_HTML + "\n"
    }
    
    func swiftCodeFromImport(importPath: String?) -> String? {
        let classPath = self.userPath.stringByAppendingPathComponent(importPath!)
        var error : NSError? = nil
        return NSString(contentsOfFile: classPath, encoding: NSUTF8StringEncoding, error: &error)
    }
}