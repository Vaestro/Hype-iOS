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

- (void)constructView {
    _logoImageView = [self newImageView];
}

- (void)layoutView {
    [self.contentView addSubview:_logoImageView];
    
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.edges.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    WEAKSELF();
    [[RACObserve(self, logoImageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView dimView];
    return imageView;
}

@end
