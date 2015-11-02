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
//#import "THLPersonIconView.h"

@interface THLGuestlistReviewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) THLStatusView *statusView;

@end

static CGFloat const STATUS_VIEW_DIMENSION = 20;

@implementation THLGuestlistReviewCell
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
    self.contentView.backgroundColor = kTHLNUISecondaryBackgroundColor;

    [self addSubviews:@[_iconImageView, _nameLabel]];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsHigh());
//        [_nameLabel c_makeRequiredContentCompressionResistanceAndContentHuggingPriority];
    }];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameLabel.mas_top).insets(kTHLEdgeInsetsHigh());
        make.top.insets(kTHLEdgeInsetsHigh()).priorityHigh();
        make.left.top.insets(kTHLEdgeInsetsLow());
        make.right.insets(kTHLEdgeInsetsLow());
        make.width.equalTo(_iconImageView.mas_height);
        make.centerX.offset(0);
    }];
    
//    [_statusView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.insets(kTHLEdgePadding);
//        make.size.equalTo(CGSizeMake1(STATUS_VIEW_DIMENSION));
//    }];
}

- (void)bindView {
    [RACObserve(self, iconImageURL) subscribeNext:^(id x) {
        [_iconImageView sd_setImageWithURL:(NSURL *)x];
    }];
    
    RAC(self.nameLabel, text) = RACObserve(self, name);
//    RAC(self.statusView, view) = RACObserve(self, statusView);
}

#pragma mark - Constructors
- (UIImageView *)newIconImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UILabel *)newNameLabel {
    UILabel *label = [[UILabel alloc] init];
    label.nuiClass = kTHLNUIRegularTitle;
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
