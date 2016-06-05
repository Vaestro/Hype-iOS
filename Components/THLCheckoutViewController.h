//
//  THLCheckoutViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/15/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PFObject;
@class THLEvent;
@class THLCheckoutViewController;
@protocol THLCheckoutViewControllerDelegate <NSObject>

-(void)checkoutViewControllerDidFinishCheckoutForEvent:(THLEvent *)event withGuestlistId:(NSString *)guestlistId;
-(void)checkoutViewControllerWantsToPresentPaymentViewController;

-(void)checkoutViewController:(THLCheckoutViewController *)checkoutView didFinishSubmittingGuestlist:(NSString *)guestlistId;
-(void)checkoutViewController:(THLCheckoutViewController *)checkoutView didFinishPurchasingForGuestlistInvite:(NSString *)guestlistInviteId;
@end

@interface THLCheckoutViewController : UIViewController
@property (nonatomic, weak) id<THLCheckoutViewControllerDelegate> delegate;
-(id)initWithEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo;
- (id)initWithEvent:(PFObject *)event admissionOption:(PFObject *)admissionOption;
@end

