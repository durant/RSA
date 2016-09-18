//
//  CCMCryptor.m
//  CocoaCryptoMac
//
//  Created by Nik Youdale on 30/08/2015.
//  Copyright (c) 2015 Nik Youdale. All rights reserved.
//

#import "CCMCryptor.h"
#import "CCMPublicKey.h"
#import "CSSMRSACryptor.h"
#import "CCMPrivateKey.h"
#import "CCMPublicKey_internal.h"
#import "CCMPrivateKey_internal.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation CCMCryptor {
  CSSMRSACryptor *_cssmCryptor;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _cssmCryptor = [[CSSMRSACryptor alloc] init];
  }
  return self;
}

- (NSData *)decryptData:(NSData *)encryptedData withPublicKey:(CCMPublicKey *)key error:(NSError **)errorPtr {
  return [_cssmCryptor decryptData:encryptedData
                     withPublicKey:key
                             error:errorPtr];
}

- (NSData *)encryptData:(NSData *)data withPrivateKey:(CCMPrivateKey *)key error:(NSError **)errorPtr {
  return [_cssmCryptor encryptData:data
                    withPrivateKey:key
                             error:errorPtr];
}

- (NSData *)encryptData:(NSData *)data withPublicKey:(CCMPublicKey *)key error:(NSError **)errorPtr {
  SecKeyRef keyRef = [key secKeyRef];
  CFErrorRef error = NULL;
  NSData *outData = nil;
  SecTransformRef transform = SecEncryptTransformCreate(keyRef, &error);
  if (transform != NULL) {
    outData = [self executeTransform:transform withInput:data error:errorPtr];
    CFRelease(transform);
  }

  if (error) {
    if (errorPtr) {
      *errorPtr = (__bridge NSError *)error;
    }
    CFRelease(error);
  }

  return outData;
}

- (NSData *)decryptData:(NSData *)encryptedData withPrivateKey:(CCMPrivateKey *)key error:(NSError **)errorPtr {
  SecKeyRef keyRef = [key secKeyRef];
  CFErrorRef error = NULL;
  SecTransformRef transform = SecDecryptTransformCreate(keyRef, &error);
  NSData *outData = nil;
  if (transform != NULL) {
    outData = [self executeTransform:transform withInput:encryptedData error:errorPtr];
    CFRelease(transform);
  }

  if (error) {
    if (errorPtr) {
      *errorPtr = (__bridge NSError *)error;
    }
    CFRelease(error);
  }

  return outData;
}

- (NSData *)executeTransform:(SecTransformRef)transform withInput:(NSData *)input error:(NSError **)errorPtr {
  CFErrorRef error = NULL;
  CFTypeRef output = NULL;
  SecTransformSetAttribute(
      transform,
      kSecTransformInputAttributeName,
      (__bridge CFDataRef)input,
      &error);
  // A comment from QCCRSASmallCryptorT.m of the CryptoCompatibility sample code
  // https://developer.apple.com/library/mac/samplecode/CryptoCompatibility/Listings/Operations_QCCRSASmallCryptorT_m.html
  //
  // For an RSA key the transform does PKCS#1 padding by default.  Weirdly, if we explicitly
  // set the padding to kSecPaddingPKCS1Key then the transform fails <rdar://problem/13661366>.
  // Thus, if the client has requested PKCS#1, we leave paddingStr set to NULL, which prevents
  // us explicitly setting the padding to anything, which avoids the error while giving us
  // PKCS#1 padding.
  //
  // SecTransformSetAttribute(transform, kSecPaddingKey, kSecPaddingPKCS1Key, &error);
  output = SecTransformExecute(transform, &error);

  if (error) {
    if (errorPtr) {
      *errorPtr = (__bridge NSError *)error;
    }
    CFRelease(error);
  }

  if (output == NULL) {
    return nil;
  }

  NSData *encrypted = [NSData dataWithData:(__bridge NSData *)output];
  CFRelease(output);
  return encrypted;
}

- (NSData *)signData:(NSData *)data withPrivateKey:(CCMPrivateKey *)key error:(NSError **)errorPtr {
    SecKeyRef keyRef = [key secKeyRef];
    size_t signedHashBytesSize = SecKeyGetBlockSize(keyRef);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([data bytes], (CC_LONG)[data length], hashBytes)) {
        return nil;
    }
    
    SecKeyRawSign(keyRef,
                  kSecPaddingPKCS1,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    
    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];
    
    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    return signedHash;

//    SecKeyRef keyRef = [key secKeyRef];
//    CFErrorRef error = NULL;
//    NSData *outData = nil;
//    CFTypeRef output = NULL;

//    SecTransformRef transform = SecSignTransformCreate(keyRef, &error);
//    if (transform != NULL) {
//        SecTransformSetAttribute(
//                                 transform,
//                                 kSecTransformInputAttributeName,
//                                 (__bridge CFDataRef)data,
//                                 &error);
//        output = SecTransformExecute(transform, &error);
//        CFRelease(transform);
//    }
//    
//    if (error) {
//        if (errorPtr) {
//            *errorPtr = (__bridge NSError *)error;
//        }
//        CFRelease(error);
//    }
//    
//    if (output == NULL) {
//        return nil;
//    }
//    
//    outData = [NSData dataWithData:(__bridge NSData *)output];
//    CFRelease(output);
//
//    
//    return outData;
}

- (BOOL)verifySignData:(NSData *)signData data:(NSData *)data withPublicKey:(CCMPublicKey *)key error:(NSError **)errorPtr  {
    SecKeyRef keyRef = [key secKeyRef];
    size_t signedHashBytesSize = SecKeyGetBlockSize(keyRef);
    const void* signedHashBytes = [signData bytes];
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([data bytes], (CC_LONG)[data length], hashBytes)) {
        return false;
    }
    
    
    OSStatus status = SecKeyRawVerify(keyRef,
                                      kSecPaddingPKCS1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;

//    SecKeyRef keyRef = [key secKeyRef];
//    CFErrorRef error = NULL;
//    CFTypeRef output = NULL;
//    SecTransformRef transform = SecVerifyTransformCreate(keyRef, (__bridge CFDataRef)signData, &error);
//    SecTransformSetAttribute(
//                             transform,
//                             kSecTransformInputAttributeName,
//                             (__bridge CFDataRef)data,
//                             &error);
//    output = SecTransformExecute(transform, &error);
//
//    CFStringRef strRef = (CFStringRef)output;
//    CFBooleanRef b = (CFBooleanRef)output;
//    if (b == kCFBooleanTrue) {
//        NSLog(@"");
//    }    else if (b == kCFBooleanFalse){
//        NSLog(@"");
//    }
//    return false;

}

@end
