//
//  THLFxTitle.m
//  HypeUp
//
//  Created by Edgar Li on 2/11/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLFxTitleLabel.h"
#import "THLAppearanceConstants.h"

@interface THLFxTitleLabel()

@end

@implementation THLFxTitleLabel
- (instancetype)init {
    if (self = [super init]) {
        [self setTextColor:kTHLNUIPrimaryFontColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.characterSpacing = 0.25f;
        self.adjustsFontSizeToFitWidth = YES;
        self.numberOfLines = 1;
        self.minimumScaleFactor = 0.5;
        self.font = [UIFont fontWithName:@"Raleway-Regular" size:16];
    }
    return self;
}
@end
