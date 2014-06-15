//
//  Formats.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation


let HTML_RESOURCE_FORMAT = "<documentation relative-path='%@'/>"
let SWIFT_RESOURCE_FORMAT = "<code source-file-name='%@'/>"

let PLAYGROUND_FORMAT = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?>\n" +
    "<playground version='1.0' sdk='macosx' allows-reset='yes'>\n" +
    "<sections>\n " +
    "%@\n" +
    "</sections>\n" +
"</playground>\n"

let HTML_FORMAT = "<!DOCTYPE html>" +
    "<html lang=\"en\">" +
    "<head>" +
    "<title>%@</title>" +
    "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />" +
    "<meta charset='utf-8'>" +
    "<meta id=\"xcode-display\" name=\"xcode-display\" content=\"render\" />" +
    "<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" +
    "<meta name = \"viewport\" content = \"width = device-width, maximum-scale=1.0\">" +
    "</head>" +
    "" +
    "<body id=\"conceptual_flow_with_tasks\" class=\"jazz\">" +
    "<div class=\"content-wrapper\">" +
    "<article class=\"chapter>\">" +
    "<section class=\"section\">" +
    "%@" +
    "</section>" +
    "</article>" +
    "</div>" +
    "</body>" +
"</html>"

let HELPER = "Usage: mkdtoplg <fileName.md> [-o <outputPath>]"
