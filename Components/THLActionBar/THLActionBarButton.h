//
//  THLActionBar.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/21/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOMSMorphingLabel.h"


@interface THLActionBarButton : UIButton
- (UIColor *)tealColor;
- (UIColor *)yellowColor;
- (UIColor *)redColor;
@property (nonatomic, strong) TOMSMorphingLabel *morphingLabel;
- (void)setTitle:(NSString *)title animateChanges:(BOOL)animate;
@end