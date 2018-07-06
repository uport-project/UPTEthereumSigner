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
            rootDerivationPath:UPORT_ROOT_DERIVATION_PATH
            callback:^(NSString *ethAddress, NSString *publicKey, NSError *error) {
            NSLog(@"eth address: %@ . for public key: %@", ethAddress, publicKey);
            expect(error).to.beNil();
            expect(ethAddress.length).to.equal(42);
        }];
    });

    it(@"creates deterministic keys", ^{
        NSString *phrase = @"army girl debate clog ensure crumble amused casual hard vapor review release";
        [UPTHDSigner
            importSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
            phrase:phrase
            rootDerivationPath:METAMASK_ROOT_DERIVATION_PATH
            callback:^(NSString *rootEthAddress, NSString *publicKey, NSError *error) {
                expect(error).to.beNil();
                expect(rootEthAddress).to.equal(@"0x108ceb4960947426ae50ded628a49df6856ce851");
                #define checkChild(index, expectedAddress) \
                [UPTHDSigner\
                    computeAddressForPath:rootEthAddress\
                    derivationPath:[METAMASK_ROOT_DERIVATION_PATH stringByAppendingString:@"/" index]\
                    prompt:@""\
                    callback:^(NSString *account0Address, NSString *account0PublicKey, NSError *error) {\
                        expect(account0Address).to.equal(expectedAddress);\
                    }\
                ];
                checkChild("0", @"0x171d67ebf279e85aff100cdb96506d835d133589");
                checkChild("1", @"0x9d24423d7bde30e69b0e4adcea5d94c53625bcb7");
                checkChild("2", @"0xad0e692b1022a461e2c8ac68c4e8b3b243481d9a");
                #undef checkChild
            }
        ];
        [UPTHDSigner
            importSeed:UPTHDSignerProtectionLevelPromptSecureEnclave
            phrase:phrase
            rootDerivationPath:UPORT_ROOT_DERIVATION_PATH
            callback:^(NSString *rootEthAddress, NSString *publicKey, NSError *error) {
                expect(error).to.beNil();
                expect(rootEthAddress).to.equal(@"0x1f03a97add0d17538c88ab058b472015094a45e7");
            }
        ];
    });
});

SpecEnd
