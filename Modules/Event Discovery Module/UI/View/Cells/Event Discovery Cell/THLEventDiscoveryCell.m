//
//  THLEventDiscoveryCell.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryCell.h"
#import "THLEventTitlesView.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"

@interface THLEventDiscoveryCell()
@property (nonatomic, strong) THLEventTitlesView *titlesView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation THLEventDiscoveryCell
@synthesize locationName;
@synthesize eventName;
@synthesize locationNeighborhood;
@synthesize time;
@synthesize imageURL;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _titlesView = [self newTitlesView];
    _imageView = [self newImageView];
}

- (void)layoutView {
    [self.contentView addSubviews:@[_imageView,
                                    _titlesView]];
    
    WEAKSELF();
    [_titlesView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.top.left.greaterThanOrEqualTo(SV(WSELF.titlesView)).insets(kTHLEdgeInsetsHigh());
        make.bottom.right.lessThanOrEqualTo(SV(WSELF.titlesView)).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.edges.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    RAC(self.titlesView, titleText) = RACObserve(self, eventName);
    RAC(self.titlesView, dateText) = RACObserve(self, time);
    RAC(self.titlesView, locationNameText) = RACObserve(self, locationName);
    RAC(self.titlesView, locationNeighborhoodText) = RACObserve(self, locationNeighborhood);
    WEAKSELF();
    [[RACObserve(self, imageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
}

#pragma mark - Constructors
- (THLEventTitlesView *)newTitlesView {
    THLEventTitlesView *titlesView = [THLEventTitlesView new];
    titlesView.separatorColor = [UIColor whiteColor];
    return titlesView;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView dimView];
    return imageView;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}
@end
