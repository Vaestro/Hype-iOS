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
#import "BLKFlexibleHeightBarSubviewLayoutAttributes.h"
#import "THLAlertView.h"
#import "SquareCashStyleBehaviorDefiner.h"

@interface THLEventNavigationBar()

@property (nonatomic, strong) UIImageView *scrollUpIcon;
@property (nonatomic) int numberOfLayouts;

@end

@implementation THLEventNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.behaviorDefiner = [SquareCashStyleBehaviorDefiner new];
        self.minimumBarHeight = 65;
        self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        self.userInteractionEnabled = YES;
        _numberOfLayouts = 0;
        
        WEAKSELF();
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.insets(UIEdgeInsetsZero);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF scrollUpIcon].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF titleLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];

        [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.insets(kTHLEdgeInsetsSuperHigh());
            make.top.offset(30);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [self.minimumTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30);
            make.centerX.equalTo(SV([WSELF minimumTitleLabel]).mas_centerX);
        }];
        
        [self.scrollUpIcon makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.insets(kTHLEdgeInsetsNone());
            make.centerX.equalTo(SV([WSELF scrollUpIcon]).mas_centerX);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [self bindView];

    }
    return self;
}

- (void)bindView {
    WEAKSELF();
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

- (void)addGradientLayer {
#warning some hacky shit to make sure the gradient layer doesnt draw again so you cant see the event image
    if (_numberOfLayouts < 2) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.frame = self.imageView.bounds;
        gradient.colors = @[(id)[UIColor clearColor].CGColor,
                            (id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor,
                            (id)[UIColor clearColor].CGColor];
        gradient.locations = @[@0.0, @0.25, @0.25, @1.0];
        
        self.imageView.layer.mask = gradient;
        _numberOfLayouts += 1;
    }
}

- (void)showExplanationView {
    THLAlertView *alertView = [THLAlertView new];
    [alertView setTitle:@"Exclusive Event"];
    [alertView setMessage:@"This is an event with limited VIP guestlist spots. Your guestlist needs to be approved by a host in order to attend. To guarantee RSVP, submit a guestlist and ask your host to book bottle service"];
    
    [self.superview addSubview:alertView];
    [self.superview bringSubviewToFront:alertView];
    [alertView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

#pragma mark - Constructors
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIBoldTitle);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 1;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_titleLabel addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_titleLabel addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UILabel *)minimumTitleLabel {
    if (!_minimumTitleLabel) {
        _minimumTitleLabel = THLNUILabel(kTHLNUIRegularTitle);
        [self addSubview:_minimumTitleLabel];
    }
    return _minimumTitleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = kTHLNUIPrimaryFontColor;
        _dateLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];

        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_dateLabel addLayoutAttributes:initialLayoutAttributes forProgress:0.75];

        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_dateLabel addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
        [self addSubview:_dateLabel];
        }
    return _dateLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;

        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_imageView addLayoutAttributes:initialLayoutAttributes forProgress:0.75];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_imageView addLayoutAttributes:finalLayoutAttributes forProgress:1.0];
        [self addSubview:_imageView];

    }
    return _imageView;
}

- (UIImageView *)scrollUpIcon {
    if (!_scrollUpIcon) {
        _scrollUpIcon = [UIImageView new];
        _scrollUpIcon.image = [UIImage imageNamed:@"scroll_up_icon"];
        _scrollUpIcon.contentMode = UIViewContentModeScaleAspectFit;
        _scrollUpIcon.clipsToBounds = YES;
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_scrollUpIcon addLayoutAttributes:initialLayoutAttributes forProgress:0.1];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_scrollUpIcon addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
        [self addSubview:_scrollUpIcon];

    }
    return _scrollUpIcon;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc]init];
        _dismissButton.frame = CGRectMake(0, 0, 50, 50);
        [_dismissButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
        [self addSubview:_dismissButton];

    }

    return _dismissButton;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end