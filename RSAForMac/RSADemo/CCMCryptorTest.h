//
//  CCMCryptorTest.h
//  CocoaCryptoMac
//
//  Created by kevin on 16/9/13.
//  Copyright © 2016年 Nik Youdale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCMBase64.h"
#import "CCMCryptor.h"
#import "CCMPublicKey.h"
#import "CCMKeyLoader.h"

@interface CCMCryptorTest : NSObject
- (CCMPublicKey *)loadPublicKeyResource:(NSString *)name ;
- (CCMPrivateKey *)loadPrivateKeyResource:(NSString *)name;
@end
