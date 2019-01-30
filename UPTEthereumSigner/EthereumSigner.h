//
//  EthereumSigner.m
//  UPTEthereumSigner
//
//  Created by Cornelis van der Bent on 19/01/2019.
//  Copyright © 2019 ConsenSys. All rights reserved.
//

@import Foundation;
@import CoreEth;

NSDictionary *ethereumSignature(BTCKey *keypair, NSData *hash, NSData *chainId);
NSDictionary *jwtSignature(BTCKey *keypair, NSData *hash);
NSDictionary *genericSignature(BTCKey *keypair, NSData *hash, BOOL lowS);
NSData *simpleSignature(BTCKey *keypair, NSData *hash);
