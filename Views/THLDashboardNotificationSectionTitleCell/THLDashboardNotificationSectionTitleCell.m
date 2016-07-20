//
//  THLDashboardNotificationSectionTitleCell.m
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardNotificationSectionTitleCell.h"
#import "THLAppearanceConstants.h"

@interface THLDashboardNotificationSectionTitleCell()
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THLDashboardNotificationSectionTitleCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAndLayoutView];
    }
    return self;
}

- (void)setupAndLayoutView {
    _titleLabel = [self newTitleLabel];
    [self addSubview:_titleLabel];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsHigh());
    }];
    
//    RAC(self.titleLabel, text, @"") = RACObserve(self, titleText);
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.textColor = kTHLNUIGrayFontColor;
    
    return label;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

@end
