//
//  THLAdmissionOption.m
//  Hype
//
//  Created by Edgar Li on 6/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLAdmissionOption.h"

@interface THLAdmissionOption()

@end

@implementation THLAdmissionOption
@dynamic gender;
@dynamic location;
@dynamic name;
@dynamic price;
@dynamic type;
@dynamic venue;
@dynamic partySize;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"AdmissionOption";
}
@end

