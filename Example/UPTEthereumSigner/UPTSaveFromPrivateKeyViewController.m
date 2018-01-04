//
//  UPTSaveFromPrivateKeyViewController.m
//  UPTEthereumSigner_Example
//
//  Created by josh on 12/28/17.
//  Copyright © 2017 josh. All rights reserved.
//

#import <UPTEthereumSigner/UPTEthereumSigner.h>
#import "../../UPTEthereumSigner/CoreBitcoin.framework/Headers/BTCData.h"
#import "UPTSaveFromPrivateKeyViewController.h"


NSString * const TEST_PRIVATE_KEY_REFERENCE = @"5047c789919e943c559d8c134091d47b4642122ba0111dfa842ef6edefb48f38";
NSString * const TEST_PUBLIC_KEY_REFERENCE = @"BL9CdZ5tKmhO9kqCEMVb8jCOQQH3iVn/ozX/BF7x5CUrHAlxAoH4lxs57+17+2GuOB7XO5+qWpbxfgDBpMMnlrE=";
NSString *const TEST_ETHEREUM_ADDRESS_REFERENCE = @"0x45c4ebd7ffb86891ba6f9f68452f9f0815aacd8b";

@interface UPTSaveFromPrivateKeyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *privateKey;
@property (weak, nonatomic) IBOutlet UITextField *ethereumAddress;
@property (weak, nonatomic) IBOutlet UITextField *publicKey;

@end

@implementation UPTSaveFromPrivateKeyViewController


- (IBAction)savePrivateKey:(id)sender {
    if ( !self.privateKey.text || [self.privateKey.text isEqualToString:@""] ) {
        NSLog( @"In order to save a private key you must input a private key or tap the button to use a test private key" );
        return;
    }
    
    NSString *privateKey = self.privateKey.text;
    NSData *privateKeyData32Bytes = BTCDataFromHex(privateKey);
    [UPTEthereumSigner saveKey:privateKeyData32Bytes protectionLevel:UPTEthKeychainProtectionLevelPromptSecureEnclave result:^(NSString *ethAddress, NSString *publicKey, NSError *error) {
        if ( !error ) {
            self.ethereumAddress.text = ethAddress;
            self.publicKey.text = publicKey;

            // if using test private key then check computed results meet expectations
            BOOL isUsingTestPrivateKey = [self.privateKey.text isEqualToString:TEST_PRIVATE_KEY_REFERENCE];
            if ( isUsingTestPrivateKey ) {
                BOOL ethereumAddressMeetsExpectations = [ethAddress isEqualToString:TEST_ETHEREUM_ADDRESS_REFERENCE];
                BOOL publicKeyMeetsExpectations = [publicKey isEqualToString:TEST_PUBLIC_KEY_REFERENCE];
                if (ethereumAddressMeetsExpectations && publicKeyMeetsExpectations) {
                    NSLog( @"Using the test private key, the computed ethereum address and computed public key meet expectations!" );
                } else {
                    NSLog( @"Using the test private key, the computed ethereum address and computed public key DO NOT meet expectations!" );
                }
            }
        } else {
            self.ethereumAddress.text = @"";
            self.publicKey.text = @"";
            NSLog( @"Error saving private key: %@", error.description );
        }
    }];
}

- (IBAction)useTestPrivateKeyTapped:(UIButton *)sender {
    self.privateKey.text = TEST_PRIVATE_KEY_REFERENCE;
}

@end
