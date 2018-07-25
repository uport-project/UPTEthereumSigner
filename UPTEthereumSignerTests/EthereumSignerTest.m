//
//  EthereumSignerTest.m
//  UPTEthereumSignerTests
//
//  Created by William Morriss on 7/25/18.
//  Copyright © 2018 ConsenSys. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "EthereumSigner.h"
#import "CoreBitcoin/BTCData.h"


@interface EthereumSignerTest : XCTestCase

@end

@implementation EthereumSignerTest

- (void)testEIP155Example {
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md#example
    NSData *privateKey = BTCDataFromHex(@"0x4646464646464646464646464646464646464646464646464646464646464646");
    BTCKey *key = [[BTCKey alloc]
        initWithPrivateKey:privateKey
    ];
    NSData *hash = BTCDataFromHex(@"0xdaf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53");
    NSData *chainId = BTCDataFromHex(@"0x01");
    NSDictionary *sig = ethereumSignature(key, hash, chainId);
    XCTAssertEqualObjects(sig[@"v"], @(37));
    XCTAssertEqualObjects(sig[@"r"], [BTCDataFromHex(@"28EF61340BD939BC2195FE537567866003E1A15D3C71FF63E1590620AA636276") base64EncodedStringWithOptions:0]);
    XCTAssertEqualObjects(sig[@"s"], [BTCDataFromHex(@"67CBE9D8997F761AECB703304B3800CCF555C9F3DC64214B297FB1966A3B6D83") base64EncodedStringWithOptions:0]);
}

@end
