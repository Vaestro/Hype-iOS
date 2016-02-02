//
//  THLResourceManager.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/14/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLResourceManager.h"

@implementation THLResourceManager
+ (NSString *)privacyPolicyText {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy Policy" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

+ (NSString *)termsOfUseText {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms of Use" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

+ (NSURL *)onboardingVideo {
    NSURL *url = [NSURL fileURLWithPath:[[
                                          NSBundle mainBundle] pathForResource:@"Lavo" ofType:@"mov"]];
    return url;
}

@end
