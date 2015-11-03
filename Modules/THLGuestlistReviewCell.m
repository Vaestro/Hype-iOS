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

//#import "THLStatusView.h"
#import "THLPersonIconView.h"

@interface THLGuestlistReviewCell()
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) THLStatusView *statusView;
@end

static CGFloat const STATUS_VIEW_DIMENSION = 20;

@implementation THLGuestlistReviewCell
@synthesize nameText;
@synthesize imageURL;
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
//    _statusView = [self newStatusView];
}

- (void)layoutView {
    self.layer.cornerRadius = kTHLCornerRadius;
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;

    [self addSubviews:@[_iconImageView, _nameLabel]];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh()).priorityHigh();
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
//    [_statusView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.insets(kTHLEdgePadding);
//        make.size.equalTo(CGSizeMake1(STATUS_VIEW_DIMENSION));
//    }];
}

- (void)bindView {
    RAC(self.iconImageView, imageURL) = RACObserve(self, imageURL);
//    [[RACObserve(self, imageURL) filter:^BOOL(NSURL *url) {
//        return [url isValid];
//    }] subscribeNext:^(NSURL *url) {
//        [self.iconImageView sd_setImageWithURL:url];
//    }];
    
    RAC(self.nameLabel, text) = RACObserve(self, nameText);
//    RAC(self.statusView, view) = RACObserve(self, statusView);
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

//- (THLStatusView *)newStatusView {
//    THLStatusView *statusView = [THLStatusView new];
//    return statusView;
//}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

@end
