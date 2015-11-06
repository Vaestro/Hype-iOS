//
//  THLGuestlistReviewCell.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/1/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewCell.h"
#import "THLAppearanceConstants.h"
#import "UIImageView+WebCache.h"

#import "THLPersonIconView.h"
#import "THLStatusView.h"

@interface THLGuestlistReviewCell()
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) THLStatusView *statusView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

//static CGFloat const STATUS_VIEW_DIMENSION = 20;

@implementation THLGuestlistReviewCell
@synthesize nameText;
@synthesize imageURL;
@synthesize guestlistInviteStatus;

//TODO: Initiate with identifier
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _iconImageView = [self newIconImageView];
    _nameLabel = [self newNameLabel];
    _statusView = [self newStatusView];
}

- (void)layoutView {
    self.layer.cornerRadius = kTHLCornerRadius;
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;

    [self addSubviews:@[_iconImageView, _nameLabel, _statusView]];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh()).priorityHigh();
        make.left.top.greaterThanOrEqualTo(SV(_iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(_iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(_iconImageView.mas_height);
        make.centerX.offset(0);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).insets(kTHLEdgeInsetsLow());
        make.bottom.left.right.insets(kTHLEdgeInsetsHigh());
        //        [_nameLabel c_makeRequiredContentCompressionResistanceAndContentHuggingPriority];
    }];
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.insets(kTHLEdgeInsetsHigh());
//        make.size.equalTo(CGSizeMake1(STATUS_VIEW_DIMENSION));
    }];
}

- (void)bindView {
    RAC(_iconImageView, imageURL) = RACObserve(self, imageURL);
    RAC(_nameLabel, text) = RACObserve(self, nameText);
    RAC(_statusView, status) = RACObserve(self, guestlistInviteStatus);
}

#pragma mark - Constructors
- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (THLStatusView *)newStatusView {
    THLStatusView *statusView = [THLStatusView new];
//    statusView.clipsToBounds = YES;
    return statusView;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

@end
