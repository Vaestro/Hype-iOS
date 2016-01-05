//
//  THLWaitlistHomeViewController.h
//  Hype
//
//  Created by Edgar Li on 1/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLWaitlistHomeViewController;
@protocol THLWaitlistHomeViewDelegate <NSObject>
- (void)didSelectUseInvitationCode;
- (void)didSelectRequestInvitation;
@end

@interface THLWaitlistHomeViewController : UIViewController
@property (nonatomic, weak) id<THLWaitlistHomeViewDelegate> delegate;

@end
