//
//  main.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//

import Foundation

let env = ZFRProcessInfo.info()

var mkdFile : String? = env["0"] as? String
var userPath : String? = env["PWD"] as? String;
let output : String? = env["o"] as? String;
let customCSS : String? = env["css"] as? String;
let help : AnyObject! = env["help"]

if help {
    println(HELPER)
}
else if mkdFile && userPath {
    
    if output {
        userPath = output
    }
    
    let fileManager = MTPFileManager(markdownFile: mkdFile!, userPath: userPath!)
    
    if (customCSS) {
        fileManager.customCSSPath = customCSS
    }
    
    let converter = MTPConverter(markDown: fileManager.markdown, userPath: userPath)
    let contents = converter.htmlFromMarkdown()
    fileManager.outputPlaygroundWithContent(contents)
}
else {
    println("Missing markdown file\n \(HELPER)")
}




