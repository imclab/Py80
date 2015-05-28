//
//  KDETextView.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KDECompletionViewController;

@interface KDETextView : NSTextView

@property (nonatomic, readwrite, weak) IBOutlet KDECompletionViewController *completionController;

@end
