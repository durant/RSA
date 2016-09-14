//
//  ViewController.m
//  RSAUtil
//
//  Created by kevin on 9/14/16.
//  Copyright (c) 2016 kevin. All rights reserved.
//

#import "ViewController.h"
#import "RSA.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSString *)loadPEMResource:(NSString *)name {
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:name withExtension:@"pem"];
    NSAssert(url != nil, @"file not found");
    NSString *pem = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return pem;
}


- (void)viewDidLoad {
	[super viewDidLoad];

    NSString *pubkey = [self loadPEMResource:@"rsa_public_key"];
    NSString *privkey = [self loadPEMResource:@"rsa_private_key_8"];
    
	NSString *originString;
	NSString *encWithPubKey;
	NSString *decWithPrivKey;
    NSString *signStr;
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jspathDemo" ofType:@"js"];
    originString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	// Demo: encrypt with public key
	encWithPubKey = [RSA encryptString:originString publicKey:pubkey];
	NSLog(@"Enctypted with public key: %@", encWithPubKey);
    
	// Demo: decrypt with private key
	decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
	NSLog(@"Decrypted with private key: %@", decWithPrivKey);
    
    // RSA 签名 with private key
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSData *signData = [RSA PKCSSignBytesSHA256withRSA:data key:privkey];
    
    signStr = [signData base64EncodedStringWithOptions:0];
    
    NSLog(@"sign with private key: %@", signStr);
    // RSA 验证签名 with public key
    signData = [[NSData alloc] initWithBase64EncodedString:signStr options:0];
    BOOL res = [RSA PKCSVerifyBytesSHA256withRSA:data signData:signData key:pubkey];
    if (res) {
        NSLog(@"签名验证成功");
    }
    else {
        NSLog(@"签名验证失败");
    }
}

@end
