//
//  UPTHDSigner+Utils.h
//  uPortMobile
//
//  Created by josh on 1/10/18.
//  Copyright © 2018 ConsenSys AG. All rights reserved.
//

#import "UPTHDSigner.h"

@interface UPTHDSigner (Utils)

+ (NSArray<NSString *> *)wordsFromPhrase:(NSString *)phrase;
+ (NSData*)randomEntropy;
+ (UPTHDSignerProtectionLevel)enumStorageLevelWithStorageLevel:(NSString *)storageLevel;
+ (NSString *)base64StringWithURLEncodedBase64String:(NSString *)URLEncodedBase64String;
+ (NSString *)URLEncodedBase64StringWithBase64String:(NSString *)base64String;
@end
