//
//  UPTViewController.m
//  UPTEthereumSigner
//
//  Created bUPTEthereumSignery josh on 12/05/2017.
//  Copyright (c) 2017 josh. All rights reserved.
//

#import "UPTViewController.h"
#import "UPTEthSigner.h"

@interface UPTViewController ()

@end

@implementation UPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *someAddresses = [UPTEthSigner allAddresses];
    NSLog( @"someAddresses -> %@", someAddresses );
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
