//
//  THLMessageListTableViewCell.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"

@interface THLMessageListCell ()

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * locationAddressTitleLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * lastMessageLabel;
@property (nonatomic, strong) UILabel * unreadMessageCountLabel;


@end

@implementation THLMessageListCell
@synthesize unreadMessageCount;
@synthesize locationAddress;
@synthesize lastMessage;
@synthesize logoImageURL;
@synthesize time;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)setup {
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    _logoImageView = [self newImageView];
    _locationAddressTitleLabel = [self newLocationAddressLabel];
    _timeLabel = [self newTimeLabel];
    _lastMessageLabel = [self newLastMessageLabel];
    _unreadMessageCountLabel = [self newUnReadMessageCountLabel];
}

- (void)layoutView {
    [self.contentView addSubviews:@[_logoImageView,
                                    _locationAddressTitleLabel,
                                    _lastMessageLabel,
                                    _timeLabel,
                                    _unreadMessageCountLabel]];
    
    WEAKSELF();
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(SV(WSELF.logoImageView)).insets(kTHLEdgeInsetsHigh());
        make.bottom.lessThanOrEqualTo(SV(WSELF.logoImageView)).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsHigh());
        make.height.equalTo(SV(WSELF.logoImageView)).sizeOffset(CGSizeMake(100, -40));
        make.width.equalTo([WSELF logoImageView].mas_height);
        make.centerY.equalTo(0);
    }];
    
    [_locationAddressTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoImageView.mas_right).with.insets(kTHLEdgeInsetsHigh());
        make.top.equalTo(WSELF.contentView.mas_top).with.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_unreadMessageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(WSELF.contentView.centerY);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.right.equalTo(WSELF.contentView).with.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.contentView).with.insets(kTHLEdgeInsetsHigh());
        make.right.equalTo(WSELF.contentView).with.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_locationAddressTitleLabel.mas_bottom);
        make.left.equalTo(_logoImageView.mas_right).with.insets(kTHLEdgeInsetsHigh());
        make.right.equalTo(_unreadMessageCountLabel.mas_left).with.insets(kTHLEdgeInsetsLow());
    }];
}

- (void)bindView {
    RAC(self.locationAddressTitleLabel, text) = RACObserve(self, locationAddress);
    RAC(self.lastMessageLabel, text) = RACObserve(self, lastMessage);
    //RAC(self.timeLabel, text) = RACObserve(self, time);
    //RAC(self.unreadMessageCountLabel, text) = RACObserve(self, unreadMessageCount);
    
    WEAKSELF();
    [[RACObserve(self, logoImageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.logoImageView sd_setImageWithURL:url];
    }];
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.backgroundColor = UIColor.greenColor;
    [imageView dimView];
    return imageView;
}

- (UILabel *)newLocationAddressLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newLastMessageLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 2;
    label.text = @"This last message write writt me an d irort gort vjttgr fsdf sfrtert trre";
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UILabel *)newTimeLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentRight;
    //label.backgroundColor = UIColor.magentaColor;
    label.text = @"9:42";
    return label;
}

- (UILabel *)newUnReadMessageCountLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.text = @"3";
    label.layer.cornerRadius = 25 / 2;
    label.backgroundColor = kTHLNUIAccentColor;
    label.clipsToBounds = true;
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

@end
