//
//  CCMCryptorTest.m
//  CocoaCryptoMac
//
//  Created by kevin on 16/9/13.
//  Copyright © 2016年 Nik Youdale. All rights reserved.
//

#import "CCMCryptorTest.h"

static NSString *pubkey = @"-----BEGIN RSA PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END RSA PUBLIC KEY-----";
static NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END RSA PRIVATE KEY-----";


@implementation CCMCryptorTest

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (CCMPublicKey *)loadPublicKeyResource:(NSString *)name {
    NSString *pem = [self loadPEMResource:name];
    CCMKeyLoader *keyLoader = [[CCMKeyLoader alloc] init];
    return [keyLoader loadRSAPEMPublicKey:pem];
}

- (CCMPrivateKey *)loadPrivateKeyResource:(NSString *)name {
    NSString *pem = [self loadPEMResource:name];
    CCMKeyLoader *keyLoader = [[CCMKeyLoader alloc] init];
    return [keyLoader loadRSAPEMPrivateKey:pem];
}

- (NSString *)loadPEMResource:(NSString *)name {
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:name withExtension:@"pem"];
    NSAssert(url != nil, @"file not found");
    NSString *pem = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return pem;
}

@end
