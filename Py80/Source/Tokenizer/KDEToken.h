//
//  KDEToken.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEToken : NSObject

@property (nonatomic, readwrite, strong) NSString *type;
@property (nonatomic, readwrite, strong) NSString *value;
@property (nonatomic, readwrite, assign) NSRange range;

+ (instancetype) tokenWithType:(NSString *)type
                         value:(NSString *)value
                         range:(NSRange)range;

@end
