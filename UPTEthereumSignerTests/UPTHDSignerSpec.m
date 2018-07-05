//
//  UPTHDSignerSpec.m
//  UPTEthereumSignerTests
//
//  Created by William Morriss on 7/5/18.
//  Copyright © 2018 ConsenSys. All rights reserved.
//

#import "Specta/Specta.h"

@import Foundation;
#import "CoreBitcoin/CoreBitcoin.h"

#import "UPTHDSigner.h"

SpecBegin(UPTHDSigner)

describe(@"key creation, address retrieval", ^{
    
    it(@"can create keys", ^{
        [UPTHDSigner createHDSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
            callback:^(NSString *ethAddress, NSString *publicKey, NSError *error) {
            NSLog(@"eth address: %@ . for public key: %@", ethAddress, publicKey);
            expect(error).to.beNil();
        }];
    });
});

SpecEnd
