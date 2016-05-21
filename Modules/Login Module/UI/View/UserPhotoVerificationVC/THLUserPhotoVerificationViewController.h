//
//  THLUserPhotoVerificationViewController.h
//  Hype
//
//  Created by Nik Cane on 27/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLUserPhotoVerificationInterface.h"
//#import "OLFacebookImagePickerController.h"

@class THLUserPhotoVerificationViewController;

@protocol THLUserPhotoVerificationViewDelegate <NSObject>

- (void)userPhotoVerificationView:(THLUserPhotoVerificationViewController *)view
              userDidConfirmPhoto:(UIImage *) image;

@end

@protocol THLUserPhotoVerificationInterfaceDidHideDelegate <NSObject>

- (void) reloadUserImageWithURL:(NSURL *) imageURL;

@end

@interface THLUserPhotoVerificationViewController : UIViewController <THLUserPhotoVerificationInterface>

@property (nonatomic, weak) id<THLUserPhotoVerificationViewDelegate> delegate;
@property (nonatomic, weak) id<THLUserPhotoVerificationInterfaceDidHideDelegate> renewImageDelegate;

- (instancetype) initForNavigationController;

@end
