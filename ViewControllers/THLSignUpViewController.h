//
//  THLSignUpViewController.h
//  Hype
//
//  Created by Edgar Li on 7/19/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol THLSignUpViewControllerDelegate <NSObject>

-(void)signUpViewControllerDidFinishSignup;

@end

@interface THLSignUpViewController : UIViewController
@property (nonatomic, weak) id<THLSignUpViewControllerDelegate> delegate;

@end
