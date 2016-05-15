//
//  THLstripeToken.h
//  Hype
//
//  Created by Daniel Aksenov on 5/13/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLUser;

@protocol THLStripeTokenServiceDelegate <NSObject>
@optional
- (void)didFinishSavingStripeToken:(NSString *)token;
@end

@interface THLStripeTokenService : NSObject
@property (nonatomic, weak) id <THLStripeTokenServiceDelegate> delegate;
- (void)createStripeToken:(NSString *)token forGuestId:(NSString *)guestId;
@end
