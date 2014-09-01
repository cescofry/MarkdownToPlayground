//
//  main.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//

import Foundation

let config = MTPConfig()

if config.help != nil {
    println(HELPER)
}
else if config.markDownFile != nil && config.userPath != nil {

    let fileManager = MTPFileManager(config: config)

    
    let converter = MTPConverter(config: config, markdown: fileManager.markdown)
    let contents = converter.htmlFromMarkdown()
    fileManager.outputPlaygroundWithContent(contents)
}
else {
    println("Missing markdown file\n \(HELPER)")
}




