//
//  SignerTests.m
//  UPTEthereumSignerTests
//
//  Created by josh on 12/05/2017.
//  Copyright (c) 2017 josh. All rights reserved.
//

@import XCTest;
@import CoreEth;
#import "UPTEthSigner.h"

@interface SignerTests : XCTestCase
@end

@implementation SignerTests

#pragma mark - Key Creation & Address Retrieval

- (void)testCanCreateKeys
{
    [UPTEthSigner createKeyPairWithStorageLevel:UPTEthKeychainProtectionLevelPromptSecureEnclave
                                         result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        NSLog(@"eth address: %@ . for public key: %@", ethAddress, publicKey);
        XCTAssertNil(error);
    }];
}

- (void)testCanRetrieveAllEthereumAddresses
{
    NSInteger lastProtectionLevel = (NSInteger)UPTEthKeychainProtectionLevelSinglePromptSecureEnclave;
    for (NSInteger i = 0; i <= lastProtectionLevel; ++i)
    {
        [UPTEthSigner createKeyPairWithStorageLevel:(UPTEthKeychainProtectionLevel)i
                                             result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
        {
            NSLog(@"eth address: %@ . for public key: %@", ethAddress, publicKey);
            XCTAssertNil(error);
        }];
    }

    NSArray *allAddresses = [UPTEthSigner allAddresses];
    XCTAssertGreaterThan(allAddresses.count, lastProtectionLevel);
    NSLog(@"allAddresses -> %@", allAddresses);
}

#pragma mark - CoreBitcoin Basic Operations, Fidelity

- (void)testCanRecreateKeysFromItsOwnPrivateKeys
{
    NSData *privateKey = [BTCKey new].privateKey;
    BTCKey *keyCopy = [[BTCKey alloc] initWithPrivateKey:privateKey];

    XCTAssertTrue([privateKey isEqualToData:keyCopy.privateKey]);
}

- (void)testCanCreateValidKeysFromExternalPrivateKeys
{
    NSString *referencePrivateKey = @"5047c789919e943c559d8c134091d47b4642122ba0111dfa842ef6edefb48f38"; // hex string
    NSData *privateKeyData32Bytes = BTCDataFromHex(referencePrivateKey);
    NSLog(@"private key data from hex strin has num bytes -> %@", @(privateKeyData32Bytes.length));

    BTCKey *keyPair = [[BTCKey alloc] initWithPrivateKey:privateKeyData32Bytes];
    XCTAssertTrue([privateKeyData32Bytes isEqualToData:keyPair.privateKey]);

    NSString *referencePublicKey = @"04bf42759e6d2a684ef64a8210c55bf2308e4101f78959ffa335ff045ef1e4252b1c09710281f8971b39efed7bfb61ae381ed73b9faa5a96f17e00c1a4c32796b1";
    NSString *hexPublicKeyRecreation = BTCHexFromData(keyPair.publicKey);
    XCTAssertTrue([hexPublicKeyRecreation isEqualToString:referencePublicKey]);

    NSString *hexPrivateKeyRecreation = BTCHexFromData(keyPair.privateKey);
    NSLog(@"privatekey reference: %@ and generated privateKey: %@", referencePrivateKey, hexPrivateKeyRecreation);
    XCTAssertTrue([referencePrivateKey isEqualToString:hexPrivateKeyRecreation]);
}

- (void)testCanCreateValidPublicKeyFromExternalPublicKeys
{
    NSString *referencePublicKey = @"04bf42759e6d2a684ef64a8210c55bf2308e4101f78959ffa335ff045ef1e4252b1c09710281f8971b39efed7bfb61ae381ed73b9faa5a96f17e00c1a4c32796b1";
    NSData *publicKeyDataBytes = BTCDataFromHex(referencePublicKey);
    NSLog(@"public key data from hex strin has num bytes -> %@", @(publicKeyDataBytes.length));

    BTCKey *keyPair = [[BTCKey alloc] initWithPublicKey:publicKeyDataBytes];
    XCTAssertTrue([publicKeyDataBytes isEqualToData:keyPair.publicKey]);

    NSString *hexPublicKeyRecreation = BTCHexFromData(keyPair.publicKey);
    NSLog(@"public key reference : %@ and generated public key : %@", referencePublicKey, hexPublicKeyRecreation);
    XCTAssertTrue([referencePublicKey isEqualToString:hexPublicKeyRecreation]);
}

#pragma mark - Saving

- (void)testCanSaveKeys
{
    NSString *referencePrivateKey = @"5047c789919e943c559d8c134091d47b4642122ba0111dfa842ef6edefb48f38";
    NSString *referencePublicKey = @"BL9CdZ5tKmhO9kqCEMVb8jCOQQH3iVn/ozX/BF7x5CUrHAlxAoH4lxs57+17+2GuOB7XO5+qWpbxfgDBpMMnlrE=";
    NSString *referenceEthAddress = @"0x45c4EBd7Ffb86891BA6f9F68452F9F0815AAcD8b".lowercaseString;
    NSData *privateKeyData32Bytes = BTCDataFromHex(referencePrivateKey);
    [UPTEthSigner saveKey:privateKeyData32Bytes
          protectionLevel:UPTEthKeychainProtectionLevelPromptSecureEnclave
                   result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        NSLog(@"testSavingKey, created public key is -> %@ and the eth address is %@", publicKey, ethAddress);
        XCTAssertNil(error);
        XCTAssertTrue([referencePublicKey isEqualToString:publicKey]);
        XCTAssertTrue([referenceEthAddress isEqualToString:ethAddress]);
    }];
}

#pragma mark - Deletion

- (void)testCanDelete
{
    NSString *referencePrivateKey = @"5047c789919e943c559d8c134091d47b4642122ba0111dfa842ef6edefb48f38";
    NSData *privateKeyData = [UPTEthSigner dataFromHexString:referencePrivateKey];
    [UPTEthSigner saveKey:privateKeyData
          protectionLevel:UPTEthKeychainProtectionLevelNormal
                   result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        XCTAssertNil(error);
        [UPTEthSigner deleteKey:ethAddress result:^(BOOL deleted, NSError *error)
        {
            XCTAssertNil(error);
            XCTAssertTrue(deleted);
        }];
    }];
}

#pragma mark - Signing

- (void)testCanSignTransaction
{
    NSString *referencePrivateKey = @"NobiRYkMf5l3Zrc6Idjln2OF4SCIMa84YldHkMvD0Vg=";
    NSString *referenceEthAddress = @"0x7f2d6bb19b6a52698725f4a292e985c51cefc315";
    NSString *rawTransaction = @"84CFC6Q7dACDL+/YlJ4gaMziLeTh6A8Vy3HvQ1ogo7N8iA3gtrOnZAAAiQq83vASNFZ4kA==";
    int vReference = 28;
    NSString *rReference = @"gJ47XvJfSjsDkTni+3D3C2NuuonHejsB4MccGjbYQSY=";
    NSString *sReference = @"OFJN/NPkEstrw39FlLutEEtnZLsUxk5CxplzAQbRiFo=";

    NSData *privateKeyData32Bytes = [[NSData alloc] initWithBase64EncodedString:referencePrivateKey options:0];
    NSLog(@"private key data: %@", privateKeyData32Bytes);
    [UPTEthSigner saveKey:privateKeyData32Bytes
          protectionLevel:UPTEthKeychainProtectionLevelNormal
                   result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        NSLog(@"testSavingKey, created public key is -> %@ and the eth address is %@", publicKey, ethAddress);
        XCTAssertNil(error);
        XCTAssertTrue([ethAddress isEqualToString:referenceEthAddress]);
    }];

    [UPTEthSigner signTransaction:referenceEthAddress
                             data:rawTransaction
                       userPrompt:@"signing test"
                           result:^(NSDictionary *signature, NSError *error)
    {
        XCTAssertNil(error);
        if (error == nil)
        {
            NSLog(@"signature: %@", signature);
            XCTAssertTrue([signature[@"r"] isEqualToString:rReference]);
            XCTAssertTrue([signature[@"s"] isEqualToString:sReference]);
            XCTAssertEqual([signature[@"v"] intValue], vReference);
        }
        else
        {
            NSLog(@"error signing transaction : %@", error);
        }
    }];
}

- (void)testCanSignJWT
{
    NSString *referencePrivateKey = @"278a5de700e29faae8e40e366ec5012b5ec63d36ec77e8a2417154cc1d25383f";
    NSString *referenceAddress = @"0xf3beac30c498d9e26865f34fcaa57dbb935b0d74";
    NSData *privateKeyData32Bytes = BTCDataFromHex(referencePrivateKey);

    [UPTEthSigner saveKey:privateKeyData32Bytes
          protectionLevel:UPTEthKeychainProtectionLevelNormal
                   result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
    {
        NSLog(@"testSavingKey, created public key is -> %@ and the eth address is %@", publicKey, ethAddress);
        XCTAssertNil(error);
        XCTAssertTrue([ethAddress isEqualToString:referenceAddress]);
    }];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *referenceDataPath = [bundle pathForResource:@"ReferenceData" ofType:@"plist"];
    NSArray *referenceData = [NSArray arrayWithContentsOfFile:referenceDataPath];
    for (NSDictionary *example in referenceData)
    {
        NSData *payload = [[NSData alloc] initWithBase64EncodedString:example[@"encoded"] options:0];
        [UPTEthSigner signJwt:referenceAddress
                   userPrompt:@"test signing data"
                         data:payload
                       result:^(NSData *signature, NSError *error)
        {
            XCTAssertNil(error);
            NSString *base64Signature = [signature base64EncodedStringWithOptions:0];
            NSString *webSafeBase64Signature = [UPTEthSigner URLEncodedBase64StringWithBase64String:base64Signature];
            XCTAssertTrue([webSafeBase64Signature isEqualToString:example[@"signature"]]);
        }];
    }
}

#pragma mark - Comprehensive Tests

- (void)testCanCombineSavingAndSigningTransactionsAndSigningJWTs
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *keyPairsPath = [bundle pathForResource:@"KeyPairsTestData" ofType:@"plist"];
    NSArray *keyPairs = [NSArray arrayWithContentsOfFile:keyPairsPath];
    NSString *txData = @"9oCFC6Q7dACDL+/YlJ4gaMziLeTh6A8Vy3HvQ1ogo7N8iA3gtrOnZAAAiQq83vASNFZ4kByAgA==";
    NSData *jwtData = [[NSData alloc] initWithBase64EncodedString:@"ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKRlV6STFOa3NpZlEuZXlKcGMzTWlPaUl6TkhkcWMzaDNkbVIxWVc1dk4wNUdRemgxYWs1S2JrWnFZbUZqWjFsbFYwRTRiU0lzSW1saGRDSTZNVFE0TlRNeU1URXpNeXdpWTJ4aGFXMXpJanA3SW01aGJXVWlPaUpDYjJJaWZTd2laWGh3SWpveE5EZzFOREEzTlRNemZR" options:0];

    for (NSDictionary *kp in keyPairs)
    {
        NSData *privateKeyData32Bytes = BTCDataFromHex(kp[@"privateKey"]);
        XCTAssertEqual(privateKeyData32Bytes.length, 32);
        BTCKey *keyPair = [[BTCKey alloc] initWithPrivateKey:privateKeyData32Bytes];
        XCTAssertTrue([privateKeyData32Bytes isEqualToData:keyPair.privateKey]);

        NSString *hexPublicKeyRecreation = BTCHexFromData(keyPair.publicKey);
        XCTAssertTrue([hexPublicKeyRecreation isEqualToString:kp[@"publicKey"]]);

        NSString *ethAddress = [UPTEthSigner ethAddressWithPublicKey:keyPair.publicKey];
        XCTAssertTrue([ethAddress isEqualToString:kp[@"address"]]);

        NSString *hexPrivateKeyRecreation = BTCHexFromData(keyPair.privateKey);
        XCTAssertTrue([hexPrivateKeyRecreation isEqualToString:kp[@"privateKey"]]);

        [UPTEthSigner saveKey:privateKeyData32Bytes
              protectionLevel:UPTEthKeychainProtectionLevelNormal
                       result:^(NSString *ethAddress, NSString *publicKey, NSError *error)
        {
            XCTAssertNil(error);
            if (error == nil)
            {
                XCTAssertTrue([ethAddress isEqualToString:kp[@"address"]]);
                NSString *refPublicKey = [BTCDataFromHex(kp[@"publicKey"]) base64EncodedStringWithOptions:0];
                XCTAssertTrue([publicKey isEqualToString:refPublicKey]);
                NSString *transaction = kp[@"address"];
                [UPTEthSigner signTransaction:transaction
                                         data:txData
                                   userPrompt:@"signing test"
                                       result:^(NSDictionary *signature, NSError *error)
                {
                    XCTAssertNil(error);
                    if (error == nil)
                    {
                        XCTAssertTrue([signature[@"r"] isEqualToString:kp[@"txsig"][@"r"]]);
                        XCTAssertTrue([signature[@"s"] isEqualToString:kp[@"txsig"][@"s"]]);
                        XCTAssertEqual([signature[@"v"] intValue], [kp[@"txsig"][@"v"] intValue]);
                        [UPTEthSigner signJwt:kp[@"address"]
                                   userPrompt:@"test signing data"
                                         data:jwtData
                                       result:^(NSData *signature, NSError *error)
                        {
                            XCTAssertNil(error);
                            NSString *base64Signature = [signature base64EncodedStringWithOptions:0];
                            NSString *webSafeBase64Signature = [UPTEthSigner URLEncodedBase64StringWithBase64String:base64Signature];
                            XCTAssertTrue([webSafeBase64Signature isEqualToString:kp[@"jwtsig"]]);
                        }];
                    }
                }];
            }
        }];
    }
}

@end
