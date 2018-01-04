//
//  UPTSignTransactionViewController.m
//  UPTEthereumSigner_Example
//
//  Created by josh on 1/3/18.
//  Copyright © 2018 josh. All rights reserved.
//

#import <UPTEthereumSigner/UPTEthereumSigner.h>
#import "UPTSignTransactionViewController.h"

NSString * const EXAMPLE_PRIVATE_KEY = @"NobiRYkMf5l3Zrc6Idjln2OF4SCIMa84YldHkMvD0Vg=";
NSString * const EXAMPLE_ETHEREUM_ADDRESS = @"0x7f2d6bb19b6a52698725f4a292e985c51cefc315";
NSString * const EXAMPLE_TRANSACTION_DATA_PAYLOAD = @"84CFC6Q7dACDL+/YlJ4gaMziLeTh6A8Vy3HvQ1ogo7N8iA3gtrOnZAAAiQq83vASNFZ4kA==";
NSString * const EXAMPLE_SIGNATURE_R = @"gJ47XvJfSjsDkTni+3D3C2NuuonHejsB4MccGjbYQSY=";
NSString * const EXAMPLE_SIGNATURE_S = @"OFJN/NPkEstrw39FlLutEEtnZLsUxk5CxplzAQbRiFo=";


@interface UPTSignTransactionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ethereumAddress;
@property (weak, nonatomic) IBOutlet UITextField *transactionDataPayload;
@property (weak, nonatomic) IBOutlet UITextField *signatureRValue;
@property (weak, nonatomic) IBOutlet UITextField *signatureSValue;
@property (weak, nonatomic) IBOutlet UITextField *signatureVValue;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@end

@implementation UPTSignTransactionViewController

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

- (IBAction)useExampleDataTapped:(id)sender {
    NSData *privateKeyData32Bytes = [[NSData alloc] initWithBase64EncodedString:EXAMPLE_PRIVATE_KEY options:0];
    NSLog(@"private key data: %@", privateKeyData32Bytes);
    [UPTEthereumSigner saveKey:privateKeyData32Bytes protectionLevel:UPTEthKeychainProtectionLevelNormal result:^(NSString *ethAddress, NSString *publicKey, NSError *error) {
        NSLog(@"example key was saved, created public key is -> %@ and the eth address is %@", publicKey, ethAddress);
    }];

    self.ethereumAddress.text = EXAMPLE_ETHEREUM_ADDRESS;
    self.transactionDataPayload.text = EXAMPLE_TRANSACTION_DATA_PAYLOAD;
}


- (IBAction)signTransactionTapped:(id)sender {
    BOOL isDataValid = self.ethereumAddress && ![self.ethereumAddress.text isEqualToString:@""] && self.transactionDataPayload && ![self.transactionDataPayload.text isEqualToString:@""];
    if ( !isDataValid ) {
        NSLog( @"Inputs are not valid, maybe use example data?" );
        return;
    }


    [UPTEthereumSigner signTransaction:self.ethereumAddress.text data:self.transactionDataPayload.text userPrompt:@"signing test" result:^(NSDictionary *signature, NSError *error) {
        if (!error) {
            NSLog(@"signature: %@", signature);
            self.signatureRValue.text = [NSString stringWithFormat:@"%@", signature[@"r"]];
            self.signatureSValue.text = [NSString stringWithFormat:@"%@", signature[@"s"]];
            self.signatureVValue.text = [NSString stringWithFormat:@"%@", signature[@"v"]];
        } else {
            NSLog(@"error signing transaction : %@", error);
        }
    }];

}

@end
