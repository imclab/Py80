//
//  KDEPython.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEPython : NSObject

+ (KDEPython *) sharedPython;

- (BOOL) setupEnvironment;

- (BOOL) loadModuleFromSourceString:(NSString*)sourceString
                        runFunction:(NSString*)functionName;

- (void) test;

@end
