//
//  UPTHDSigner+Utils.m
//  uPortMobile
//
//  Created by josh on 1/10/18.
//  Copyright © 2018 ConsenSys AG. All rights reserved.
//

#import "UPTHDSigner.h"
#import "UPTHDSigner+Utils.h"

@implementation UPTHDSigner (Utils)

+ (NSArray<NSString *> *)wordsFromPhrase:(NSString *)phrase {
    NSArray<NSString *> *words = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
}

+ (NSData*)randomEntropy {
    NSUInteger entropyCapacity = 128 / 8;
    NSMutableData* entropy = [NSMutableData dataWithCapacity:(128 / 8)];
    NSUInteger numBytes = entropyCapacity / 4;
    for( NSUInteger i = 0 ; i < numBytes; ++i ) {
        u_int32_t randomBits = arc4random();
        [entropy appendBytes:(void *)&randomBits length:4];
    }

    return entropy;
}

+ (UPTHDSignerProtectionLevel)enumStorageLevelWithStorageLevel:(NSString *)storageLevel {
    NSArray<NSString *> *storageLevels = @[ ReactNativeHDSignerProtectionLevelNormal,
            ReactNativeHDSignerProtectionLevelICloud,
            ReactNativeHDSignerProtectionLevelPromptSecureEnclave,
            ReactNativeHDSignerProtectionLevelSinglePromptSecureEnclave];
    return (UPTHDSignerProtectionLevel)[storageLevels indexOfObject:storageLevel];
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
