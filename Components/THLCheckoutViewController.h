//
//  THLCheckoutViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/15/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THLEventEntity;

@class THLCheckoutViewController;
@protocol THLCheckoutViewDelegate <NSObject>
-(void)checkoutViewController:(THLCheckoutViewController *)checkoutView didFinishSubmittingGuestlist:(NSString *)guestlistId;
-(void)checkoutViewController:(THLCheckoutViewController *)checkoutView didFinishPurchasingForGuestlistInvite:(NSString *)guestlistInviteId;
@end

@interface THLCheckoutViewController : UIViewController
@property (nonatomic, weak) id<THLCheckoutViewDelegate> delegate;
-(id)initWithEvent:(THLEventEntity *)event paymentInfo:(NSDictionary *)paymentInfo andCompletionAction:(RACCommand *)completionAction;
@end

