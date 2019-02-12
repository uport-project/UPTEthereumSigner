//
//  EthereumSignerTests.m
//  UPTEthereumSignerTests
//
//  Created by William Morriss on 7/25/18.
//  Copyright © 2018 ConsenSys. All rights reserved.
//

@import XCTest;
@import CoreEth;
#import "EthereumSigner.h"

@interface EthereumSignerTests : XCTestCase
@end

@implementation EthereumSignerTests

- (void)testEIP155Example
{
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md#example
    NSData *privateKey = BTCDataFromHex(@"0x4646464646464646464646464646464646464646464646464646464646464646");
    BTCKey *key = [[BTCKey alloc] initWithPrivateKey:privateKey];
    NSData *hash = BTCDataFromHex(@"0xdaf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53");
    NSData *chainId = BTCDataFromHex(@"0x01");
    NSDictionary *sig = ethereumSignature(key, hash, chainId);
    XCTAssertEqualObjects(sig[@"v"], @(37));
    XCTAssertEqualObjects(sig[@"r"], [BTCDataFromHex(@"28EF61340BD939BC2195FE537567866003E1A15D3C71FF63E1590620AA636276") base64EncodedStringWithOptions:0]);
    XCTAssertEqualObjects(sig[@"s"], [BTCDataFromHex(@"67CBE9D8997F761AECB703304B3800CCF555C9F3DC64214B297FB1966A3B6D83") base64EncodedStringWithOptions:0]);
}

- (void)testDifficultSigs
{
    NSData *privateKey = BTCDataFromHex(@"0x4646464646464646464646464646464646464646464646464646464646464646");
    BTCKey *key = [[BTCKey alloc] initWithPrivateKey:privateKey];
    NSData *chainId = BTCDataFromHex(@"0x01");
    NSMutableArray *all = [NSMutableArray array];

    // these are all values in the range [0x00000000, 0x00000C80) that fail to sign with this private key
    NSArray *values =
    @[
        @(315), @(537), @(543), @(550), @(577), @(642), @(662), @(998), @(1020), @(1241),
        @(1352), @(1496), @(1541), @(1608), @(1742), @(1760), @(2285), @(2295), @(2304),
        @(2341), @(2665), @(2817), @(2867), @(2915), @(2927), @(3011), @(3064), @(3101)
    ];

    NSMutableData *hash = [NSMutableData dataWithLength:sizeof(uint64_t)];
    for (uint64_t val = 0; val < 0xc80; val++)
    {
        *((uint64_t *)(hash.mutableBytes)) = val;
        @try
        {
            NSDictionary *sig = ethereumSignature(key, hash, chainId);
            XCTAssertNotNil(sig[@"r"]);
            XCTAssertNotNil(sig[@"s"]);
        }
        @catch (NSException *exception)
        {
            [all addObject:@(val)];
        }
    }

    // the set of values that fail should diminish over time, and never regress
    XCTAssertEqualObjects(all, @[]);
}

@end
