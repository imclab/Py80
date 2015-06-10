//
//  KDETokenizedStringTests.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/10/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "KDETokenizedString.h"
#import "KDETokenizer.h"



@interface KDETokenizedString ()

@property (nonatomic, readwrite, strong) NSArray *tokens;

- (void) replaceTokensFromFirstToken:(KDEToken *)firstToken
             toAndIncludingLastToken:(KDEToken *)lastToken
                          withTokens:(NSArray *)tokens;

@end



@interface KDETokenizedStringTests : XCTestCase

@end

@implementation KDETokenizedStringTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTokensSubarrayRangeWithCharacterRange
{
    KDETokenizedString *tokenizedString = [[KDETokenizedString alloc] initWithString:@""
                                                                           tokenizer:[KDETokenizer new]];
    tokenizedString.tokens = @[ [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 0, 5)],
                                [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 5, 5)],
                                [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 20, 2)],
                                [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 30, 10)],
                                [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 40, 10)]];

    // Test ranges that overlap tokens
    NSRange subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 0, 50)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 0, 5)), @"Subarray range incorrect");
    
    subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 6, 0)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 1, 1)), @"Subarray range incorrect");
    
    subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 22, 28)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 3, 2)), @"Subarray range incorrect");
    
    
    // Test ranges that don't overlap any tokens
    subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 5, 0)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 1, 0)), @"Subarray range incorrect");
    
    subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 22, 5)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 3, 0)), @"Subarray range incorrect");
    
    subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 0, 0)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 0, 0)), @"Subarray range incorrect");
    
    subarrayRange = [tokenizedString tokensSubarrayRangeWithCharacterRange:NSMakeRange( 50, 10)];
    XCTAssert( NSEqualRanges( subarrayRange, NSMakeRange( 5, 0)), @"Subarray range incorrect");
}

- (void) testReplaceTokens
{
    KDETokenizedString *tokenizedString = [[KDETokenizedString alloc] initWithString:@""
                                                                           tokenizer:[KDETokenizer new]];
    NSArray *originalTokens = @[ [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 0, 5)],
                                 [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 5, 5)],
                                 [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 20, 2)],
                                 [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 30, 10)],
                                 [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 40, 10)]];
    
    NSArray *replacementTokens = @[ [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 0, 5)],
                                    [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 5, 5)],
                                    [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 20, 2)],
                                    [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 30, 10)],
                                    [KDEToken tokenWithType:0 value:nil range:NSMakeRange( 40, 10)]];
    
    // Test 1
    tokenizedString.tokens = originalTokens;
    [tokenizedString replaceTokensFromFirstToken:originalTokens.firstObject
                         toAndIncludingLastToken:originalTokens.lastObject
                                      withTokens:replacementTokens];
    XCTAssertTrue( tokenizedString.tokens[ 0] == replacementTokens[0], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 1] == replacementTokens[1], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 2] == replacementTokens[2], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 3] == replacementTokens[3], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 4] == replacementTokens[4], @"token incorrect");
    
    XCTAssertFalse( tokenizedString.tokens[ 0] == originalTokens[0], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 1] == originalTokens[1], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 2] == originalTokens[2], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 3] == originalTokens[3], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 4] == originalTokens[4], @"token incorrect");
    
    // Test 2
    tokenizedString.tokens = originalTokens;
    [tokenizedString replaceTokensFromFirstToken:originalTokens[2]
                         toAndIncludingLastToken:originalTokens[4]
                                      withTokens:@[ replacementTokens[0], replacementTokens[1], replacementTokens[2]]];
    XCTAssertTrue( tokenizedString.tokens[ 0] == originalTokens[0], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 1] == originalTokens[1], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 2] == replacementTokens[0], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 3] == replacementTokens[1], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 4] == replacementTokens[2], @"token incorrect");
    
    XCTAssertFalse( tokenizedString.tokens[ 0] == replacementTokens[0], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 1] == replacementTokens[1], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 2] == originalTokens[2], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 3] == originalTokens[3], @"token incorrect");
    XCTAssertFalse( tokenizedString.tokens[ 4] == originalTokens[4], @"token incorrect");
    
    // Insertion Test
    tokenizedString.tokens = originalTokens;
    [tokenizedString replaceTokensFromFirstToken:originalTokens[3]
                         toAndIncludingLastToken:originalTokens[4]
                                      withTokens:replacementTokens];
    XCTAssertTrue( tokenizedString.tokens[ 0] == originalTokens[0], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 1] == originalTokens[1], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 2] == originalTokens[2], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 3] == replacementTokens[0], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 4] == replacementTokens[1], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 5] == replacementTokens[2], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 6] == replacementTokens[3], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 7] == replacementTokens[4], @"token incorrect");
    
    
    // Deletion Test
    tokenizedString.tokens = originalTokens;
    [tokenizedString replaceTokensFromFirstToken:originalTokens[0]
                         toAndIncludingLastToken:originalTokens[2]
                                      withTokens:@[]];
    XCTAssertTrue( tokenizedString.tokens[ 0] == originalTokens[3], @"token incorrect");
    XCTAssertTrue( tokenizedString.tokens[ 1] == originalTokens[4], @"token incorrect");
}

@end
