//
//  THLstripeToken.m
//  Hype
//
//  Created by Daniel Aksenov on 5/13/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLStripeTokenService.h"
#import <Parse/Parse.h>
#import "THLUser.h"

@implementation THLStripeTokenService
@synthesize delegate;

- (void)createStripeToken:(NSString *)token forGuestId:(NSString *)guestId
{
    PFObject *stripeToken = [PFObject objectWithClassName:@"stripeToken"];
    stripeToken[@"token"] = token;
    stripeToken[@"user"] = [THLUser objectWithoutDataWithObjectId:guestId];
    stripeToken[@"date"] = [NSDate date];
    [stripeToken saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.delegate didFinishSavingStripeToken:token];
    }];
}
@end
