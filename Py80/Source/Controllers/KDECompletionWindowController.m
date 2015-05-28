//
//  KDECompletionWindowController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDECompletionWindowController.h"

#import "KDEPython.h"
#import "KDEPyCompletion.h"
#import "KDEPyCallSignature.h"

#import "NSString+CursorPosition.h"


@interface KDECompletionWindowController ()

@property (nonatomic, readwrite, strong) NSArray *completions;

@end


@implementation KDECompletionWindowController

- (BOOL) isVisible
{
    return self.window.isVisible;
}

- (void) reloadCompletionsForTextView:(NSTextView *)textView
{
    NSString *source = textView.string;
    KDEStringCursor cursor = [source cursorForRange:textView.selectedRange];
    
    NSArray *completionObjects = [[KDEPython sharedPython] completionsForSourceString:source
                                                                                 line:cursor.line
                                                                               column:cursor.column];
    
    NSMutableArray *signatures = [NSMutableArray array];
    NSMutableArray *completions = [NSMutableArray array];
    
    for( id obj in completionObjects)
    {
        if( [obj isKindOfClass:[KDEPyCompletion class]])
        {
            [completions addObject:obj];
        }
        else if( [obj isKindOfClass:[KDEPyCallSignature class]])
        {
            [signatures addObject:obj];
        }
    }
    
    NSMutableDictionary *completionDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *types;
    NSString *type;
    for( KDEPyCompletion *completion in completions)
    {
        type = completion.type;
        types = completionDictionary[ type];
        if( types == nil)
        {
            types = [NSMutableArray array];
            completionDictionary[ type] = types;
        }
        
        [types addObject:completion];
    }
    
    NSMutableArray *c = [NSMutableArray array];
    for( type in completionDictionary)
    {
        types = completionDictionary[ type];
        for( KDEPyCompletion *completion in types)
        {
            [c addObject:completion];
        }
    }
    
    NSTableColumn *typeColumn = self.table.tableColumns[ [self.table columnWithIdentifier:@"Type"]];
    typeColumn.minWidth = [self columnWidthForTypeNames:[completionDictionary allKeys]];
    typeColumn.width = typeColumn.minWidth;
    
    self.completions = [NSArray arrayWithArray:c];
    [self.table reloadData];
    
    if( self.completions.count == 0)
    {
        [self hide];
    }
}

- (void) insertCurrentCompletionInTextView:(NSTextView *)textView
{
    NSInteger index = self.table.selectedRow;
    
    if( index > -1)
    {
        KDEPyCompletion *completion = self.completions[ index];
        [textView insertText:completion.complete];
        [self hide];
    }
}

- (void) showForTextView:(NSTextView *)textView
{
    if( [KDEPython sharedPython].isInitialized && self.completions.count)
    {
        NSRect frame = self.window.frame;
        frame.size.height = MIN( [self tableHeightForRowCount:8],
                                 [self tableHeightForRowCount:self.completions.count]);
        frame.origin = [self windowPointForCurrentSelectionInTextView:textView];
        
        frame = [textView.window convertRectToScreen:frame];
        frame.origin.y -= frame.size.height;
        
        [self showWindow:nil];
        [self.window setFrame:frame
                      display:YES];
    }
}

- (void) hide
{
    [self close];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.completions.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *) tableView:(NSTableView *)tableView
    viewForTableColumn:(NSTableColumn *)tableColumn
                   row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:tableColumn.identifier
                                                        owner:self];
    KDEPyCompletion *completion = self.completions[ row];
    NSMutableString *string = [NSMutableString string];

    if( [tableColumn.identifier isEqualToString:@"Type"])
    {
        [string appendString:completion.type];
    }
    else if( [tableColumn.identifier isEqualToString:@"Completion"])
    {
        [string appendString:completion.name];
        
        if( [completion.type isEqualToString:@"function"])
        {
            [string appendString:@"("];
            if( completion.argNames.count)
            {
                [string appendFormat:@" %@",[completion.argNames componentsJoinedByString:@", "]];
            }
            [string appendString:@")"];
        }
    }
    
    view.textField.stringValue = string;
    
    return view;
}

#pragma mark - private

- (CGFloat) tableHeightForRowCount:(NSInteger)rowCount
{
    return rowCount * (self.table.rowHeight + self.table.intercellSpacing.height);
}

- (NSPoint) windowPointForCurrentSelectionInTextView:(NSTextView *)textView
{
    NSString *source = textView.string;
    
    NSRange lineRange = [source lineRangeForRange:textView.selectedRange];
    lineRange.length = textView.selectedRange.location - lineRange.location;
    NSRange glyphRange = [textView.layoutManager glyphRangeForCharacterRange:lineRange
                                                        actualCharacterRange:NULL];
    NSRect lineRect = [textView.layoutManager boundingRectForGlyphRange:glyphRange
                                                        inTextContainer:textView.textContainer];

    NSPoint point = NSMakePoint( NSMaxX( lineRect), NSMaxY( lineRect));
    return [textView convertPoint:point
                           toView:nil];
}

- (CGFloat) columnWidthForTypeNames:(NSArray *)typeNames
{
    NSTableCellView *view = [self.table makeViewWithIdentifier:@"Type"
                                                         owner:self];
    
    CGFloat width = 0.0f;
    CGSize size;
    NSDictionary *attributes = @{ NSFontAttributeName : view.textField.font };
    for( NSString *type in typeNames)
    {
        size = [type sizeWithAttributes:attributes];
        if( size.width > width)
        {
            width = size.width;
        }
    }
    return width + 6.0f;
}

@end
