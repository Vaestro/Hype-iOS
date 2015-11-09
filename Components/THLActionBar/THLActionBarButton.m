//
//  THLActionBar.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/21/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLActionBarButton.h"
#import "Masonry.h"
#import "THLAppearanceConstants.h"

@interface THLActionBarButton ()
@end

@implementation THLActionBarButton
@dynamic titleLabel;
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [self tealColor];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.morphingLabel];
    WEAKSELF();
    [_morphingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(WSELF.titleEdgeInsets);
    }];
}

- (void)setTitle:(NSString *)title animateChanges:(BOOL)animate {
    if (animate) {
        [self.morphingLabel setText:title withCompletionBlock:NULL];
    } else {
        [self.morphingLabel setTextWithoutMorphing:title];
    }
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self setTitle:title animateChanges:NO];
}

- (TOMSMorphingLabel *)morphingLabel {
    if (!_morphingLabel) {
        TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc] init];
//        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textColor = kTHLNUIPrimaryFontColor;
        label.textAlignment = NSTextAlignmentCenter;
        
        _morphingLabel = label;
    }
    return _morphingLabel;
}



- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 60);
}


- (UIColor *)tealColor {
    return kTHLNUIAccentColor;
}

- (UIColor *)yellowColor {
    return kTHLNUIPendingColor;
}

- (UIColor *)redColor {
    return kTHLNUIRedColor;
}

@end
