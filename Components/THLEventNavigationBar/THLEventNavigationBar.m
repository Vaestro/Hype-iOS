//
//  THLEventNavigationBar.m
//  Hypelist2point0
//
//  Created by Edgar Li on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventNavigationBar.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "THLEventDetailsPromotionInfoView.h"
#import "BLKFlexibleHeightBarSubviewLayoutAttributes.h"
#import "THLAlertView.h"

@interface THLEventNavigationBar()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *scrollUpIcon;
@property (nonatomic, strong) UILabel *minimumTitleLabel;
@end

@implementation THLEventNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)constructView {
    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    _promotionInfoView = [self newPromotionInfoView];
    _dismissButton = [self newDismissButton];
    _dateLabel = [self newDateLabel];
    _titleLabel = [self newTitleLabel];
    _imageView = [self newImageView];
    _scrollUpIcon = [self newScrollUpIcon];
    _minimumTitleLabel = [self newMinimumTitleLabel];
}

- (void)layoutView {
    [self addSubviews:@[_imageView, _titleLabel, _dateLabel, _promotionInfoView, _dismissButton, _minimumTitleLabel, _scrollUpIcon]];
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(UIEdgeInsetsZero);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF promotionInfoView].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF titleLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_promotionInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF scrollUpIcon].mas_top);
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.top.offset(30);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_minimumTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.equalTo(SV([WSELF minimumTitleLabel]).mas_centerX);
    }];
    
    [_scrollUpIcon makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.insets(kTHLEdgeInsetsNone());
        make.centerX.equalTo(SV([WSELF scrollUpIcon]).mas_centerX);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.titleLabel, text, @"") = RACObserve(self, titleText);
    RAC(self.minimumTitleLabel, text, @"") = RACObserve(self, titleText);
    RAC(self.dateLabel, text, @"") = RACObserve(self, dateText);
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
    RAC(self.promotionInfoView, promotionInfo) = RACObserve(self, promotionInfo);

    RACSignal *imageURLSignal = [RACObserve(self, locationImageURL) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
}

- (void)setEventName:(NSString *)eventName {
    [self.titleLabel setText:eventName];
}

- (void)setPromoImageURL:(NSURL *)promoImageURL {
    [self.imageView sd_setImageWithURL:promoImageURL];
}

- (void)setExclusiveEventLabel {
    UIView *exclusiveLabelBackground = [UIView new];
    exclusiveLabelBackground.backgroundColor = [UIColor redColor];
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [exclusiveLabelBackground addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [exclusiveLabelBackground addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
    
    [self addSubview:exclusiveLabelBackground];
    
    WEAKSELF();
    [exclusiveLabelBackground makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF dateLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    UIButton *exclusiveLabel = [self newExclusiveEventLabel];
    [exclusiveLabelBackground addSubview:exclusiveLabel];
    [exclusiveLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kTHLEdgeInsetsSuperHigh());
        make.top.bottom.equalTo(kTHLEdgeInsetsNone());
    }];
}

- (void)addGradientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.imageView.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor clearColor].CGColor];
    gradient.locations = @[@0.0, @0.25, @0.25, @1.0];
    
    self.imageView.layer.mask = gradient;

}

- (void)showExplanationView {
    THLAlertView *alertView = [THLAlertView new];
    [alertView showWithTitle:@"Exclusive Event"
                     message:@"This is an event with limited VIP guestlist spots. Your guestlist needs to be approved by a host in order to attend. To guarantee RSVP, please book bottle service."];
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [label addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [label addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
    
    return label;
}

- (UILabel *)newMinimumTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [label addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [label addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
    return label;
}

- (UIButton *)newExclusiveEventLabel {
    UIButton *label = [UIButton new];
    [label setTitle:@"Limited Guestlist Space" forState:UIControlStateNormal];
    [label addTarget:self
                 action:@selector(showExplanationView)
       forControlEvents:UIControlEventTouchUpInside];
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [label addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [label addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
    return label;
}

- (THLEventDetailsPromotionInfoView *)newPromotionInfoView {
    THLEventDetailsPromotionInfoView *promoInfoView = [THLEventDetailsPromotionInfoView new];
    promoInfoView.title = NSLocalizedString(@"EVENT DETAILS", nil);
    promoInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    promoInfoView.dividerColor = [UIColor whiteColor];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [promoInfoView addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [promoInfoView addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
    
    return promoInfoView;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [imageView addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [imageView addLayoutAttributes:finalLayoutAttributes forProgress:1.0];
    
    return imageView;
}

- (UIImageView *)newScrollUpIcon {
    UIImageView *icon = [UIImageView new];
    icon.image = [UIImage imageNamed:@"scroll_up_icon"];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.clipsToBounds = YES;
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributes.alpha = 1.0;
    [icon addLayoutAttributes:initialLayoutAttributes forProgress:0.1];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    finalLayoutAttributes.alpha = 0.0;
    [icon addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
    
    return icon;
}

- (UIButton *)newDismissButton {
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 50, 50);
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    return button;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end