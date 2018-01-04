//
//  UPTSignJWTViewController.m
//  UPTEthereumSigner_Example
//
//  Created by josh on 1/4/18.
//  Copyright © 2018 josh. All rights reserved.
//

#import <UPTEthereumSigner/UPTEthereumSigner.h>
#import <UPTEthereumSigner/UPTEthereumSigner+Utils.h>
#import "UPTSignJWTViewController.h"
#import "../../UPTEthereumSigner/CoreBitcoin.framework/Headers/BTCData.h"

NSString * const EXAMPLE_JWT_PRIVATE_KEY = @"278a5de700e29faae8e40e366ec5012b5ec63d36ec77e8a2417154cc1d25383f";
NSString * const EXAMPLE_JWT_ETHEREUM_ADDRESS = @"0xf3beac30c498d9e26865f34fcaa57dbb935b0d74";
NSString * const EXAMPLE_DECODED = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksifQ.eyJpc3MiOiIzNHdqc3h3dmR1YW5vN05GQzh1ak5KbkZqYmFjZ1llV0E4bSIsImlhdCI6MTQ4NTMyMTEzMywiY2xhaW1zIjp7Im5hbWUiOiJCb2IifSwiZXhwIjoxNDg1NDA3NTMzfQ";
NSString * const EXAMPLE_ENCODED = @"ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKRlV6STFOa3NpZlEuZXlKcGMzTWlPaUl6TkhkcWMzaDNkbVIxWVc1dk4wNUdRemgxYWs1S2JrWnFZbUZqWjFsbFYwRTRiU0lzSW1saGRDSTZNVFE0TlRNeU1URXpNeXdpWTJ4aGFXMXpJanA3SW01aGJXVWlPaUpDYjJJaWZTd2laWGh3SWpveE5EZzFOREEzTlRNemZR";
NSString * const EXAMPLE_HEX = @"65794a30655841694f694a4b563151694c434a68624763694f694a46557a49314e6b736966512e65794a7063334d694f69497a4e48647163336833646d5231595735764e303547517a6831616b354b626b5a71596d466a5a316c6c5630453462534973496d6c68644349364d5451344e544d794d54457a4d797769593278686157317a496a7037496d3568625755694f694a4362324969665377695a586877496a6f784e4467314e4441334e544d7a6651";
NSString * const EXAMPLE_SIGNATURE = @"sg1oJ7J_f2pWaX2JwqzA61oWMUK5v0LYVxUp3PvG7Y25CVYWPyQ6UhA7U9d4w3Ny74k7ryMaUz7En5RSL4pyXg";

@interface UPTSignJWTViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UITextField *ethereumAddress;
@property (weak, nonatomic) IBOutlet UITextField *jwtDataPayload;
@property (weak, nonatomic) IBOutlet UITextField *signature;

@end

@implementation UPTSignJWTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    for ( UIView *subview in self.scrollContentView.subviews ) {
        [NSLayoutConstraint activateConstraints:@[[subview.widthAnchor constraintEqualToConstant:(screenSize.width - 32)]]];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.scrollView.contentSize = CGSizeMake( screenSize.width, screenSize.height * 2 );
    self.scrollContentView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height );
}

- (IBAction)useExampleDataTapped:(UIButton *)sender {
    NSData *privateKeyData32Bytes = BTCDataFromHex(EXAMPLE_JWT_PRIVATE_KEY);
    [UPTEthereumSigner saveKey:privateKeyData32Bytes protectionLevel:UPTEthKeychainProtectionLevelNormal result:^(NSString *ethAddress, NSString *publicKey, NSError *error) {
        NSLog(@"testSavingKey, created public key is -> %@ and the eth address is %@", publicKey, ethAddress);
        if ( error ) {
            NSLog( @"Error saving keys: %@", error.description );
        }
    }];

    self.ethereumAddress.text = EXAMPLE_JWT_ETHEREUM_ADDRESS;
    self.jwtDataPayload.text = EXAMPLE_ENCODED;
}

- (IBAction)signJWT:(UIButton *)sender {
    // error handling
    BOOL isValidEthereumAddress = self.ethereumAddress.text && ![self.ethereumAddress.text isEqualToString:@""];
    BOOL isValidJWTDataPayload = self.jwtDataPayload.text && ![self.jwtDataPayload.text isEqualToString:@""];
    if ( !isValidEthereumAddress || !isValidJWTDataPayload ) {
        NSLog( @"Please provide an etherum address and jwt data payload or use example data by tapping the example data button" );
        return;
    }

    // sign button
    NSData *payload = [[NSData alloc] initWithBase64EncodedString:self.jwtDataPayload.text options:0];
    [UPTEthereumSigner signJwt:self.ethereumAddress.text userPrompt:@"example signing data" data:payload result:^(NSData *signature, NSError *error) {
        if ( !error ) {
            NSString *base64Signature = [signature base64EncodedStringWithOptions:0];
            NSString *webSafeBase64Signature = [UPTEthereumSigner URLEncodedBase64StringWithBase64String:base64Signature];
            self.signature.text = webSafeBase64Signature;
            BOOL isUsingExampleData = [self.ethereumAddress.text isEqualToString:EXAMPLE_JWT_ETHEREUM_ADDRESS] && [self.jwtDataPayload.text isEqualToString:EXAMPLE_ENCODED];
            if ( isUsingExampleData && [webSafeBase64Signature isEqualToString:EXAMPLE_SIGNATURE] ) {
                NSLog( @"Example data computed the expected results!" );
            } else {
                NSLog( @"Example data DID NOT compute the expected results" );
            }
        } else {
            NSLog( @"Error signing transaction: %@", error.description );
            self.signature.text = @"";
        }
    }];

}

@end
