//
//  THLLoginViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 12/7/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLLoginViewInterface.h"

@protocol THLLoginViewControllerDelegate <NSObject>

-(void)loginViewControllerDidFinishSignup;
-(void)loginViewControllerdidDismiss;

@end

@interface THLLoginViewController : UIViewController<THLLoginViewInterface>
@property (nonatomic, weak) id<THLLoginViewControllerDelegate> delegate;
- (void)applicationDidRegisterForRemoteNotifications;
@end
