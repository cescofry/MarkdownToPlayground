//
//  main.m
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPConverter.h"
#import "MTPFileManager.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        
        if (arguments.count < 2) {
            NSLog(@"Missing makrdown file");
            return 1;
        }
        
        MTPFileManager *fileManager = [[MTPFileManager alloc] initWithFileAtPath:arguments[1]];
        NSDictionary *contents = [MTPConverter htmlFromMarkdown:fileManager.markdown];
        [fileManager outputPlaygroundWith:contents];
        
    }
    return 0;
}

