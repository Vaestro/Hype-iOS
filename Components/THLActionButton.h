//
//  THLActionButton.h
//  HypeUp
//
//  Created by Edgar Li on 1/31/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLActionButton : UIButton
- (instancetype)initWithDefaultStyle;
- (instancetype)initWithInverseStyle;
- (instancetype)initWithActionStyle;
- (void)setTitle:(NSString *)title;
@end
