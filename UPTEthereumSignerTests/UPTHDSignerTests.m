//
//  UPTHDSignerTests.m
//  UPTEthereumSignerTests
//
//  Created by William Morriss on 7/5/18.
//  Copyright © 2018 ConsenSys. All rights reserved.
//

@import XCTest;
#import "UPTHDSigner.h"

@interface UPTHDSignerTests : XCTestCase
@end

@implementation UPTHDSignerTests

#pragma mark - Key Creation & Address Retrieval

- (void)testCanCreateKeys
{
    [UPTHDSigner createHDSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
           rootDerivationPath:UPORT_ROOT_DERIVATION_PATH
                     callback:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        NSLog(@"eth address: %@ . for public key: %@", ethAddress, publicKey);

        XCTAssertNil(error);
        XCTAssertEqual(ethAddress.length, 42);
    }];
}

- (void)checkChild:(NSInteger)index
   expectedAddress:(NSString *)expectedAddress
    rootEthAddress:(NSString *)rootEthAddress
{
    [UPTHDSigner computeAddressForPath:rootEthAddress
                        derivationPath:[METAMASK_ROOT_DERIVATION_PATH stringByAppendingFormat:@"/%ld", (long)index]
                                prompt:@""
                              callback:^(NSString *account0Address, NSString *account0PublicKey, NSError *error)
    {
        XCTAssertTrue([account0Address isEqualToString:expectedAddress]);
    }];
}

- (void)testCreatesDeterministicKeys
{
    NSString *phrase = @"army girl debate clog ensure crumble amused casual hard vapor review release";
    [UPTHDSigner importSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
                     phrase:phrase
         rootDerivationPath:METAMASK_ROOT_DERIVATION_PATH
                   callback:^(NSString *rootEthAddress, NSString *publicKey, NSError *error)
    {
        XCTAssertNil(error);
        XCTAssertTrue([rootEthAddress isEqualToString:@"0x108ceb4960947426ae50ded628a49df6856ce851"]);

        [self checkChild:0
         expectedAddress:@"0x171d67ebf279e85aff100cdb96506d835d133589"
          rootEthAddress:rootEthAddress];
        [self checkChild:1
         expectedAddress:@"0x9d24423d7bde30e69b0e4adcea5d94c53625bcb7"
          rootEthAddress:rootEthAddress];
        [self checkChild:2
         expectedAddress:@"0xad0e692b1022a461e2c8ac68c4e8b3b243481d9a"
          rootEthAddress:rootEthAddress];
    }];

    [UPTHDSigner importSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
                     phrase:phrase
                rootDerivationPath:UPORT_ROOT_DERIVATION_PATH
                   callback:^(NSString *rootEthAddress, NSString *publicKey, NSError *error)
    {
        XCTAssertNil(error);
        XCTAssertTrue([rootEthAddress isEqualToString:@"0x1f03a97add0d17538c88ab058b472015094a45e7"]);
    }];
}

- (void)testRejectsInvalidPhrases
{
    [UPTHDSigner importSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
                     phrase:@"then cat cat cat cat cat cat cat cat cat cat cat"
                rootDerivationPath:UPORT_ROOT_DERIVATION_PATH
                   callback:^(NSString *rootEthAddress, NSString *publicKey, NSError *error)
    {
        XCTAssertNil(rootEthAddress);
        XCTAssertNil(publicKey);
        XCTAssertEqual(error.code, UPTHDSignerErrorCodeInvalidSeedWords.integerValue);
    }];
}

#pragma mark - Deletion

- (void)testCanDelete
{
    [UPTHDSigner createHDSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
           rootDerivationPath:UPORT_ROOT_DERIVATION_PATH
                     callback:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        NSLog(@"Deletion eth address: %@ . for public key: %@", ethAddress, publicKey);
        XCTAssertNil(error);
        [UPTHDSigner deleteSeed:ethAddress callback:^(BOOL deleted, NSError *error)
        {
            XCTAssertTrue(deleted);
            XCTAssertNil(error);
            [UPTHDSigner showSeed:ethAddress
                           prompt:@"Test if seed still exists"
                         callback:^(NSString *phrase, NSError *error2)
            {
                XCTAssertNil(phrase);
                XCTAssertNotNil(error2);
            }];
        }];
    }];
}

@end
