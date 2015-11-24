//
//  THLEventHostingTableCell.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingTableCell.h"
#import "THLAppearanceConstants.h"

#import "THLPersonIconView.h"
#import "THLStatusView.h"

@interface THLEventHostingTableCell()
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) UILabel *guestlistTitleLabel;
@property (nonatomic, strong) THLStatusView *statusView;
@property (nonatomic, strong) UILabel *guestlistReviewStatusLabel;
@end

@implementation THLEventHostingTableCell
@synthesize guestlistReviewStatus;
@synthesize guestlistReviewStatusTitle;
@synthesize guestlistTitle;
@synthesize imageURL;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        
    }
    return self;
}

- (void)constructView {
    _iconImageView = [self newIconImageView];
    _guestlistTitleLabel = [self newGuestlistTitleLabel];
    _statusView = [self newStatusView];
    _guestlistReviewStatusLabel = [self newGuestlistReviewStatusLabel];
}

- (void)layoutView {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
    WEAKSELF();
    [self addSubviews:@[_iconImageView, _guestlistTitleLabel, _statusView, _guestlistReviewStatusLabel]];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.insets(kTHLEdgeInsetsHigh());
        make.width.equalTo([WSELF iconImageView].mas_height);
    }];
    
    [_guestlistTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF guestlistTitleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.right.equalTo([WSELF guestlistReviewStatusLabel].mas_left);
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.insets(kTHLEdgeInsetsHigh());
        make.height.mas_equalTo([WSELF guestlistReviewStatusLabel].mas_height);
        make.width.mas_equalTo([WSELF statusView].mas_height);
    }];
    
    [_guestlistReviewStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF guestlistTitleLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.right.insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF statusView].mas_right);
        make.bottom.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    RAC(_iconImageView, imageURL) = RACObserve(self, imageURL);
    RAC(_guestlistTitleLabel, text) = RACObserve(self, guestlistTitle);
    RAC(_statusView, status) = RACObserve(self, guestlistReviewStatus);
    RAC(_guestlistReviewStatusLabel, text) = RACObserve(self, guestlistReviewStatusTitle);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.layer.cornerRadius = ViewWidth(_iconImageView)/2.0;
}

#pragma mark - Constructors
- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *imageView = [THLPersonIconView new];
    return imageView;
}

- (UILabel *)newGuestlistTitleLabel {
    UILabel *guestlistTitleLabel = THLNUILabel(kTHLNUIDetailTitle);
    return guestlistTitleLabel;
}

- (THLStatusView *)newStatusView {
    THLStatusView *statusView = [THLStatusView new];
    [statusView setScale:0.5];
    return statusView;
}

- (UILabel *)newGuestlistReviewStatusLabel {
    UILabel *guestlistReviewStatusLabel = THLNUILabel(kTHLNUIDetailTitle);
    return guestlistReviewStatusLabel;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}

@end
