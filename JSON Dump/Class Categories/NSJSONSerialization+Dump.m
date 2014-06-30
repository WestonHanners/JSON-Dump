//
//  NSJSONSerialization+Dump.m
//  JSON Dump
//
//  Created by Weston Hanners on 6/30/14.
//  Copyright (c) 2014 Hanners Software. All rights reserved.
//

#import "NSJSONSerialization+Dump.h"
#import <objc/runtime.h>

@implementation NSJSONSerialization (Dump)

+ (void)activate {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
    Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(JSONObjectWithData:options:error:);
        SEL swizzledSelector = @selector(hs_JSONObjectWithData:options:error:);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

+ (NSURL *)folderForJSON {
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    
    NSURL *jsonFolder = [documentsDirectoryURL URLByAppendingPathComponent:@"JSON DUMP" isDirectory:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
        // When getting the folder for JSON dumps, we need to make sure that the folder exists first.
    
    if ([fileManager fileExistsAtPath:[jsonFolder path]]) {
        
        return jsonFolder;
    } else {
        
        bool success = [fileManager createDirectoryAtURL:jsonFolder withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (success) {
            
            return jsonFolder;
        } else {
            
            return nil;
        }
    }
}

+ (NSURL *)saveURLWithID:(NSString *)identifier {

    NSURL *baseURL = [NSJSONSerialization folderForJSON];
    NSURL *fileName = [baseURL URLByAppendingPathComponent:identifier];
    NSURL *fileNameWithExtension = [fileName URLByAppendingPathExtension:@"json"];
    
    return fileNameWithExtension;
}

+ (id)hs_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYMMDDAAAAAA"];
        
        NSString *identifier = [formatter stringFromDate:[NSDate date]];
        
        [data writeToURL:[NSJSONSerialization saveURLWithID:identifier] atomically:YES];
    }];
    
    id retval = [self hs_JSONObjectWithData:data options:opt error:error];
        // extra stuff
    
    return retval;
}
@end
