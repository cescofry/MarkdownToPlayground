//
//  MTPFileManager.h
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPFileManager : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong, readonly) NSString *filePath;
@property (nonatomic, strong, readonly) NSString *markdown;

- (instancetype)initWithFileAtPath:(NSString *)path;

- (void)outputPlaygroundWith:(NSDictionary *)content;

+ (NSURL *)fileURLForResourceName:(NSString *)name;

@end
