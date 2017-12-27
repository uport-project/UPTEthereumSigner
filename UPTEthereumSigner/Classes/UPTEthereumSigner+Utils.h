//
//  UPTEthereumSigner+Utils.h
//  uPortMobile
//
//  Created by josh on 10/18/17.
//  Copyright © 2017 ConsenSys. All rights reserved.
//

#import "UPTEthereumSigner.h"

@interface UPTEthereumSigner (Utils)

+ (NSData *)keccak256:(NSData *)input;

+ (NSString *)base64StringWithURLEncodedBase64String:(NSString *)URLEncodedBase64String;

+ (NSString *)URLEncodedBase64StringWithBase64String:(NSString *)base64String;


@end
