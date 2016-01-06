//
//  THLWaitlistPresenter.h
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLWaitlistEntry;
@class THLWaitlistPresenter;

@protocol THLWaitlistPresenterDelegate <NSObject>
- (void)didApproveUserForApp;
@end

@interface THLWaitlistPresenter : NSObject
@property (nonatomic, weak) id<THLWaitlistPresenterDelegate> delegate;

- (instancetype)init;

- (void)presentInterfaceInWindow:(UIWindow *)window;
@end
