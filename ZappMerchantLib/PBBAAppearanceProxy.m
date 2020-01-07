//
//  PBBAAppearanceProxy.m
//  ZappMerchantLib
//
//  Created by Alexandru Maimescu on 3/15/16.
//  Copyright 2016 IPCO 2012 Limited
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

#import "PBBAAppearanceProxy.h"

@interface PBBAWeakTarget : NSProxy

- (instancetype)initWithTarget:(id)target;

@property (nonatomic, weak) id target;

@end

@implementation PBBAWeakTarget

- (instancetype)initWithTarget:(id)target
{
    self.target = target;
    
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [[self.target class] instanceMethodSignatureForSelector:sel];
}

@end


static NSMutableDictionary *registeredAppearances = nil;

@interface PBBAAppearanceProxy ()

@property (strong, nonatomic) Class mainClass;
@property (strong, nonatomic) NSMutableArray *invocations;

@end

@implementation PBBAAppearanceProxy

+ (id)appearanceForClass:(Class)givenClass
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!registeredAppearances) {
            registeredAppearances = [[NSMutableDictionary alloc] init];
        }
    });
    
    id registeredAppearance = registeredAppearances[NSStringFromClass(givenClass)];
    if (registeredAppearance) {
        return registeredAppearance;
    } else {
        PBBAAppearanceProxy *appearance = [[self alloc] initWithClass:givenClass];
        registeredAppearances[NSStringFromClass(givenClass)] = appearance;
        return appearance;
    }
}

- (instancetype)initWithClass:(Class)thisClass
{
    self.mainClass = thisClass;
    self.invocations = [NSMutableArray array];
    
    return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation retainArguments];
    [self.invocations addObject:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.mainClass instanceMethodSignatureForSelector:sel];
}

- (void)startForwarding:(__weak id)sender
{
    PBBAWeakTarget *weakTarget = [[PBBAWeakTarget alloc] initWithTarget:sender];
    
    for (NSInvocation *invocation in self.invocations) {
        [invocation setTarget:weakTarget];
        [invocation invoke];
    }
}

@end
