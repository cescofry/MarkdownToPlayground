//
//  main.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

let HELPER = "Usage: mkdtoplg <fileName.md> [-o <outputPath>]"

let env = ZFRProcessInfo.info()

var mkdFile : String? = env["0"] as? String
let userPath : String? = env["PWD"] as? String;
let help : AnyObject! = env["help"]

if help {
    //    NSLog("%@", HELPER);
}
else if mkdFile && userPath {
    let fileManager = MTPFileManager(markdownFile: mkdFile!, userPath: userPath!)
    let contents = MTPConverter.htmlFromMarkdown(fileManager.markdown)
    fileManager.outputPlaygroundWith(contents)
}
else {
    NSLog("Missing markdown file")
    //  NSLog("", HELPER)
}




