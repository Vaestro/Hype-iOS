//
//  THLUserPhotoVerificationViewController.h
//  HypeUp
//
//  Created by Nik Cane on 27/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLUserPhotoVerificationInterface.h"
#import "OLFacebookImagePickerController.h"

@class THLUserPhotoVerificationViewController;

@protocol THLUserPhotoVerificationViewDelegate <NSObject>
- (void)userPhotoVerificationView:(THLUserPhotoVerificationViewController *)view userDidConfirmPhoto:(UIImage *) image;
- (void)presentFacebookImagePicker:(OLFacebookImagePickerController *) imagePicker;
//- (void)cancelPicker:(OLFacebookImagePickerController *) imagePicker;
@end

@interface THLUserPhotoVerificationViewController : UIViewController <THLUserPhotoVerificationInterface>

@property (nonatomic, weak) id<THLUserPhotoVerificationViewDelegate> delegate;

@end
