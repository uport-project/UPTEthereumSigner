//
//  UPTEthSigner+Utils.m
//  uPortMobile
//
//  Created by josh on 10/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <CoreBitcoin/CoreBitcoin.h>
#import "UPTEthSigner+Utils.h"
#import "UPTEthSigner.h"
#import "keccak.h"

@implementation UPTEthSigner (Utils)

+ (NSData *)keccak256:(NSData *)input {
    char *outputBytes = malloc(32);
    sha3_256((unsigned char *)outputBytes, 32, (unsigned char *)[input bytes], (unsigned int)[input length]);
    return [NSData dataWithBytes:outputBytes length:32];
}

+ (UPTEthKeychainProtectionLevel)enumStorageLevelWithStorageLevel:(NSString *)storageLevel {
  NSArray<NSString *> *storageLevels = @[ ReactNativeKeychainProtectionLevelNormal,
                                          ReactNativeKeychainProtectionLevelICloud,
                                          ReactNativeKeychainProtectionLevelPromptSecureEnclave,
                                          ReactNativeKeychainProtectionLevelSinglePromptSecureEnclave];
  return (UPTEthKeychainProtectionLevel)[storageLevels indexOfObject:storageLevel];
}

+ (NSString *)hexStringWithDataKey:(NSData *)dataPrivateKey {
    return BTCHexFromData(dataPrivateKey);
}

+ (NSData *)dataFromHexString:(NSString *)originalHexString {
    return BTCDataFromHex(originalHexString);
}


+ (NSString *)base64StringWithURLEncodedBase64String:(NSString *)URLEncodedBase64String {
    NSMutableString *characterConverted = [[[URLEncodedBase64String stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] mutableCopy];
    if ( characterConverted.length % 4 != 0 ) {
        NSUInteger numEquals = 4 - characterConverted.length % 4;
        NSString *equalsPadding = [@"" stringByPaddingToLength:numEquals withString: @"=" startingAtIndex:0];
        [characterConverted appendString:equalsPadding];
    }

    return characterConverted;

}

+ (NSString *)URLEncodedBase64StringWithBase64String:(NSString *)base64String {
    return [[[base64String stringByReplacingOccurrencesOfString:@"+" withString:@"-"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"] stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

@end
