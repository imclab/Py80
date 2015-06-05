//
//  KDEPy80Preferences.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KDETheme;

@interface KDEPy80Preferences : NSObject

@property (nonatomic, readonly, strong) NSString *currentThemePath;

+ (KDEPy80Preferences *) sharedPreferences;

- (void) appLaunchChecks;

- (NSArray *) pathsOfAvailableThemes;
- (void) saveTheme:(KDETheme *)theme
          withName:(NSString *)name;
- (BOOL) renameThemeNamed:(NSString *)themeName
                       to:(NSString *)newName;

@end