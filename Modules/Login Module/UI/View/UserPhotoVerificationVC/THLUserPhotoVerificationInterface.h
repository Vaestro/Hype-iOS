//
//  THLUserPhotoVerificationInterface.h
//  HypeUp
//
//  Created by Nik Cane on 27/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

@protocol THLUserPhotoVerificationInterface <NSObject>

- (void) facebookUserImage:(UIImage *) image;
- (void) facebookImagePickerFailToLoadImage:(NSError *) error;

@end
