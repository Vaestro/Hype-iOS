//
//  THLPermissionRequestViewController.h
//  Hype
//
//  Created by Edgar Li on 6/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLPermissionRequestViewControllerDelegate <NSObject>

-(void)permissionViewControllerDidReceivePermission;
-(void)permissionViewControllerDeclinedPermission;
@end

@interface THLPermissionRequestViewController : UIViewController
@property (nonatomic, weak) id<THLPermissionRequestViewControllerDelegate> delegate;

@end
