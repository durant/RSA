//
//  ViewController.m
//  RSADemo
//
//  Created by kevin on 16/9/13.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "ViewController.h"

#import "RSA.h"
#import "CCMBase64.h"
#import "CCMCryptor.h"
#import "CCMPublicKey.h"
#import "CCMKeyLoader.h"
#import "CCMCryptorTest.h"

@interface ViewController ()

@property (nonnull, nonatomic, copy) NSString *filePath;
@property (weak) IBOutlet NSTextField *pathField;

@property (weak) IBOutlet NSView *bgView;

@property (strong) NSData *preEncryData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bgView.layer.backgroundColor = [[NSColor clearColor] CGColor];
    

    
}

- (void)viewDidAppear {
    [super viewDidAppear];
}


- (IBAction)perforClick:(id)sender {
//    NSString *baseStr = @"fw+ekwQV/+cHq2idXMzD1q4B+RPxpwbmyEBcYz2epKEvjQDSDMwOSkkB23kp+ZVgs88UkN5DBAEqGfoaEe4HZd0l/oGRHlfH+dG7n3Hx5mRdRkVWz2Yz6vn/uH8KJjsEV81YmbBWrDlruLpPCIlfEACWTbnF3lOcTr7RdwRuZ01xrNdMbsjOYhU695LUWrVEav58h4WXrGqiytwVfnPzQ2iDk3dlv7X2eFDGOTibLdLwqeR/n+E9obUddWUMreDodzlf0EyynKOwaAeA4feNamVxaWnlY8DVbT5PPB5Py8qrHiLs1FKuHHxakpwEzQ9EzixFaUOo+ZYqLrbxqwBuUw==";
//    NSData *encryData = [CCMBase64 dataFromBase64String:baseStr];
//    CCMCryptorTest *test = [[CCMCryptorTest alloc] init];
//    CCMPublicKey *publicKey = [test loadPublicKeyResource:@"rsa_public_key"];
//    CCMPrivateKey *privateKey = [test loadPrivateKeyResource:@"rsa_private_key"];
//    CCMCryptor *cryptor = [[CCMCryptor alloc] init];
//    NSError *error;
//        NSData *decryptedData = [cryptor decryptData:encryData
//                                      withPrivateKey:privateKey
//                                               error:&error];
//        NSString *output = [[NSString alloc] initWithData:decryptedData
//                                                 encoding:NSUTF8StringEncoding];
//        NSLog(@"%@ ", output);
//        
//        return;

    NSOpenPanel *panel   = [NSOpenPanel openPanel];
    panel.canChooseFiles = true;
    panel.canChooseDirectories = false;
    panel.canCreateDirectories = false;
    
    NSInteger result     = [panel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        NSString *path = [[panel URL] path];
        
        self.filePath  = path;
        
        self.pathField.stringValue = path;
        
        NSLog(@"path = %@", path);
    }
    else {
        NSLog(@"open failed");
    }
}

- (IBAction)addSignAction:(id)sender {
    CCMCryptorTest *test = [[CCMCryptorTest alloc] init];
    CCMPublicKey *publicKey = [test loadPublicKeyResource:@"rsa_public_key"];
    CCMPrivateKey *privateKey = [test loadPrivateKeyResource:@"rsa_private_key"];
    CCMCryptor *cryptor = [[CCMCryptor alloc] init];
    NSError *error;

    NSString *originString = @"hello world!";
    for(int i=0; i<4; i++){
        originString = [originString stringByAppendingFormat:@" %@", originString];
    }
    
    NSData *inputData = [originString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jspathDemo" ofType:@"js"];
    inputData = [[NSData alloc] initWithContentsOfFile:path];
    
    // RSA 签名
    NSData *signData = [cryptor signData:inputData withPrivateKey:privateKey error:&error];
    NSString *signStr = [CCMBase64 base64StringFromData:signData];
    
    NSLog(@"signStr == %@ ", signStr);
    
    BOOL f = [cryptor verifySignData:signData data:inputData withPublicKey:publicKey error:&error];
    if(f)
    {
        NSLog(@" 签名成功 ");
    }
    else
    {
        NSLog(@" 签名失败");
    }
    // This can be decrypted on the command line with the following command:
    // % echo -n "<output>" \
    //   | base64 -D \
    //   | openssl rsautl -decrypt -inkey test/resources/private_key.pem
    NSData *encryptedData ;
    NSString *baseStr;
    encryptedData  = [cryptor encryptData:inputData withPublicKey:publicKey error:&error];
    
    baseStr = [CCMBase64 base64StringFromData:encryptedData];

    NSLog(@"%@ ", baseStr);
    
    encryptedData = [CCMBase64 dataFromBase64String:baseStr];
    NSData *decryptedData = [cryptor decryptData:encryptedData
                                  withPrivateKey:privateKey
                                           error:&error];
    NSString *output = [[NSString alloc] initWithData:decryptedData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"%@ ", output);

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

@end
