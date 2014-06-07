//
//  Formats.h
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#ifndef MarkdownToPlayground_Formats_h
#define MarkdownToPlayground_Formats_h

#define HTML_FORMAT @"<!DOCTYPE html>\
<html lang=\"en\">\
<head>\
<title>section-10.html</title>\
<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />\
<meta charset='utf-8'>\
<meta id=\"xcode-display\" name=\"xcode-display\" content=\"render\" />\
<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />\
<meta name = \"viewport\" content = \"width = device-width, maximum-scale=1.0\">\
</head>\
\
<body id=\"conceptual_flow_with_tasks\" class=\"jazz\">\
<div class=\"content-wrapper\">\
<article class=\"chapter>\">\
<section class=\"section\">\
%@\
</section>\
</article>\
</div>\
</body>\
</html>"

#define PLAYGROUND_FORMAT @"<?xml version='1.0' encoding='UTF-8' standalone='yes'?>\
<playground version='1.0' sdk='macosx' allows-reset='yes'>\
<sections>\
%@\
</sections>\
</playground>"

#define HTML_RESOURCE_FORMAT @"<documentation relative-path='%@'/>"
#define SWIFT_RESOURCE_FORMAT @"<code source-file-name='%@'/>"

#endif
