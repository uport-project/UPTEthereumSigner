//
//  UPTEthSigner+Utils.h
//  uPortMobile
//
//  Created by josh on 10/18/17.
//  Copyright © 2017 ConsenSys AG. All rights reserved.
//

#import "UPTEthereumSigner.h"

@interface UPTEthereumSigner (Utils)

/// @description courtesy helper method to convert an implementation specific storage level string to a storage
///              level this library recognizes.
+ (UPTEthKeychainProtectionLevel)enumStorageLevelWithStorageLevel:(NSString *)storageLevel;

+ (NSData *)keccak256:(NSData *)input;

+ (NSString *)hexStringWithDataKey:(NSData *)dataPrivateKey;

+ (NSData *)dataFromHexString:(NSString *)originalHexString;

+ (NSString *)base64StringWithURLEncodedBase64String:(NSString *)URLEncodedBase64String;

+ (NSString *)URLEncodedBase64StringWithBase64String:(NSString *)base64String;


@end
