//
//  THLPersonIconView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>

@interface THLPersonIconView : UIView
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PFImageView *imageView;

@property (nonatomic, copy) NSString *placeholderImageText;
- (void)setUnregisteredUserOn;
@end
