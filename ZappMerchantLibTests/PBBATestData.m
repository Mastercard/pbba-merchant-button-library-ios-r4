//
//  PBBATestData.m
//  ZappAppPickerLib
//
//  Created by Alexandru Maimescu on 5/24/17.
//  Copyright 2017 Vocalink Limited
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "PBBATestData.h"

@interface PBBATestData ()

@property (nonatomic, class, readonly) NSBundle *testBundle;

@end

@implementation PBBATestData

+ (NSDictionary *)testData
{
    NSString *path = [self.testBundle pathForResource:@"test-jws-strings" ofType:@"strings"];
    NSDictionary *testData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return testData;
}

+ (NSBundle *)testBundle
{
    return [NSBundle bundleForClass:self];
}

+ (NSString *)validJWSContent
{
    return [self testData][@"valid-jws-content"];
}

+ (NSString *)invalidJWSContent
{
    return [self testData][@"invalid-jws-content"];
}

+ (NSString *)invalidHeaderJWSContent
{
    return [self testData][@"invalid-jws-content-header"];
}

+ (NSString *)invalidPayloadJWSContent
{
    return [self testData][@"invalid-jws-content-payload"];
}

+ (NSString *)invalidSignatureJWSContent
{
    return [self testData][@"invalid-jws-content-signature"];
}

+ (NSDictionary *)validJWSHeader
{
    NSString *validJWSHeader = [self testData][@"valid-jws-header"];
    NSData *data = [validJWSHeader dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];;
}

+ (NSDictionary *)validAppPickerManifest
{
    NSString *path = [self.testBundle pathForResource:@"test-pbba-app-picker-manifest" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSData *)testSelfSignedCertificateData
{
    NSString *path = [self.testBundle pathForResource:@"test-self-signed.cert" ofType:@"der"];
    
    return [NSData dataWithContentsOfFile:path];
}

+ (NSData *)testSelfSignedCertificateData2
{
    NSString *path = [self.testBundle pathForResource:@"test-self-signed-2.cert" ofType:@"der"];
    
    return [NSData dataWithContentsOfFile:path];
}

+ (NSData *)testLeafCertificateData
{
    NSString *path = [self.testBundle pathForResource:@"test-leaf.cert" ofType:@"der"];
    
    return [NSData dataWithContentsOfFile:path];
}

+ (NSData *)testCACertificateData
{
    NSString *path = [self.testBundle pathForResource:@"test-ca.cert" ofType:@"der"];
    
    return [NSData dataWithContentsOfFile:path];
}

+ (NSData *)testValidCARootCertificateData
{
    NSString *path = [self.testBundle pathForResource:@"test-ca-root.cert" ofType:@"der"];
    
    return [NSData dataWithContentsOfFile:path];
}

+ (NSString *)testValidCertificateChain
{
    NSString *path = [self.testBundle pathForResource:@"test-chain.cert" ofType:@"pem"];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)testValidCertificateChain2
{
    NSString *path = [self.testBundle pathForResource:@"test-chain-2.cert" ofType:@"pem"];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)testInvalidCertificateChain
{
    NSString *path = [self.testBundle pathForResource:@"test-ca-chain-invalid.cert" ofType:@"pem"];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)testInvalidCertificateChain2
{
    NSString *path = [self.testBundle pathForResource:@"test-ca-chain-invalid-2.cert" ofType:@"pem"];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (NSData *)validAppIconData
{
    NSString *path = [self.testBundle pathForResource:@"test-app-icon" ofType:@"png"];
    
    return [NSData dataWithContentsOfFile:path];
}

@end
