//
//  UPTCreateKeysViewController.m
//  UPTEthereumSigner_Example
//
//  Created by josh on 12/27/17.
//  Copyright © 2017 josh. All rights reserved.
//

#import "UPTCreateKeysViewController.h"
#import "UPTEthereumSigner.h"

@interface UPTCreateKeysViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ethereumAddress;
@property (weak, nonatomic) IBOutlet UITextField *publicKey;

@end

@implementation UPTCreateKeysViewController

- (IBAction)createKeysTapped:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [UPTEthereumSigner createKeyPairWithStorageLevel:UPTEthKeychainProtectionLevelNormal result:^(NSString *ethAddress, NSString *publicKey, NSError *error) {
        if ( !error ) {
            weakSelf.ethereumAddress.text = ethAddress;
            weakSelf.publicKey.text = publicKey;
        } else {
            weakSelf.ethereumAddress.text = @"";
            weakSelf.publicKey.text = @"";
            NSLog( @"Error creating keys: %@", error.description );
        }
    }];
}

@end
