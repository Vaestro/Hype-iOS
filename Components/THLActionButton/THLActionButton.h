//
//  THLActionButton.h
//  Hype
//
//  Created by Edgar Li on 1/31/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLActionButton : UIButton
- (instancetype)initWithDefaultStyle;
- (instancetype)initWithFacebookStyle;
- (instancetype)initWithInverseStyle;
- (instancetype)initWithActionStyle;
- (void)setTitle:(NSString *)title;
@end
