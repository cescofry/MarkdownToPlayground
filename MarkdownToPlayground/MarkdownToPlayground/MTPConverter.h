//
//  MTPConverter.h
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPConverter : NSObject

+ (NSDictionary *)htmlFromMarkdown:(NSString *)markdown;

@end
