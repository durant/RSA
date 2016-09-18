//
//  ViewController.m
//  RSADemo
//
//  Created by kevin on 16/9/13.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "ViewController.h"

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
    NSOpenPanel *panel   = [NSOpenPanel openPanel];
    panel.canChooseFiles = true;
    panel.canChooseDirectories = false;
    panel.canCreateDirectories = false;
    
    NSInteger result     = [panel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        NSString *path = [[panel URL] path];
        
//        self.filePath  = path;
        
        self.pathField.stringValue = path;
        
        NSLog(@"path = %@", path);
    }
    else {
        NSLog(@"open failed");
    }
}

- (IBAction)addSignAction:(id)sender
{
    CCMCryptorTest *test      = [[CCMCryptorTest alloc] init];
    CCMPublicKey *publicKey   = [test loadPublicKeyResource:@"rsa_public_key"];
    CCMPrivateKey *privateKey = [test loadPrivateKeyResource:@"rsa_private_key"];
    CCMCryptor *cryptor       = [[CCMCryptor alloc] init];
    NSError *error;
    
    NSString *path    = [[NSBundle mainBundle] pathForResource:@"jspathDemo" ofType:@"js"];
    NSData *inputData = [[NSData alloc] initWithContentsOfFile:path];
    
    // RSA 签名 with private key
    NSData *signData ;
    NSString *signStr;
    signData = [cryptor signData:inputData withPrivateKey:privateKey error:&error];
    signStr = [CCMBase64 base64StringFromData:signData];
    
    NSLog(@"signStr == %@", signStr);
    
    signStr = @"rkHASfk+wDXLQ3eWkhKA6a4d5HOwcobsXNs5WCYXztPeyuUeRPbwsrWxLlIFh8NSAktiMlfqwDPjlKK5k1y2bbQdXj3K8phkPeFF9xZmVIXLSRP3sFGubtxj3l3m+UGgyWoynag3jUDnZFZfrjqD+VYjlXEjUqxURGnDj9Hn7l4=";
    signData = [CCMBase64 dataFromBase64String:signStr];
    // RSA 验证签名 with public key
    BOOL f = [cryptor verifySignData:signData data:inputData withPublicKey:publicKey error:&error];
    if(f)
    {
        NSLog(@" 签名验证成功 ");
    }
    else
    {
        NSLog(@" 签名验证失败");
    }
    
    NSData *encryptedData ;
    NSString *encryptedStr;
    NSData *decryptedData;
    NSString *output;
    
    // rsa 加密 with public key
    encryptedData = [cryptor encryptData:inputData withPublicKey:publicKey error:&error];
    encryptedStr  = [CCMBase64 base64StringFromData:encryptedData];
    NSLog(@"%@ ", encryptedStr);
    
    // rsa 解密 with private key
    decryptedData = [cryptor decryptData:encryptedData withPrivateKey:privateKey error:&error];
    output        = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@ ", output);

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}

@end
