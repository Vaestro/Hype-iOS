//
//  THLPerksCell.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerksCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"

@interface THLPerksCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *perkTitleLabel;
@property (nonatomic, strong) UILabel *perkCreditsLabel;
@property (nonatomic, strong) UILabel *perkDescriptionLabel;
@end


@implementation THLPerksCell
@synthesize name;
@synthesize description;
@synthesize image;
@synthesize credits;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _imageView = [self newImageView];
    _perkTitleLabel = [self newPerkTitleLabel];
    _perkCreditsLabel = [self newPerkCreditsLabel];
    _perkDescriptionLabel = [self newPerkDescriptionLabel];
    
}

- (void)layoutView {
    
    [self.contentView addSubviews:@[_imageView,
                                    _perkTitleLabel,
                                    _perkCreditsLabel,
                                    _perkDescriptionLabel]];
    
//    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.top.left.right.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_perkTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
        make.top.left.right.left.insets(kTHLEdgeInsetsNone());
        
    }];
    
    [_perkCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.insets(kTHLEdgeInsetsLow());
        make.top.right.lessThanOrEqualTo(SV(_imageView)).insets(kTHLEdgeInsetsHigh());
    }];
    
    
}

- (void)bindView {
    RAC(self.perkTitleLabel, text) = RACObserve(self, name);
    RAC(self.perkDescriptionLabel, text) = RACObserve(self, description);
        
    WEAKSELF();
    [[RACObserve(self, credits) map:^id(id creditsInt) {
        return [NSString stringWithFormat:@"%@ credits", creditsInt];
    }] subscribeNext:^(NSString *convertedCredit) {
        [WSELF.perkCreditsLabel setText:convertedCredit];
    }];
    
    
    [[RACObserve(self, image) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
}


#pragma mark - Constructors

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView dimView];
    return imageView;
}

- (UILabel *)newPerkTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


- (UILabel *)newPerkDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newPerkCreditsLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}
@end
