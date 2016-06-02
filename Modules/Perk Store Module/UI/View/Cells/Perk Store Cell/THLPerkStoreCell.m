//
//  THLPerkStoreCell.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"

@interface THLPerkStoreCell()

@end


@implementation THLPerkStoreCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}


- (void)layoutView {
    
    WEAKSELF();
    [self.perkImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.edges.equalTo(WSELF);
    }];
    
    [self.perkTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.centerY).insets(kTHLEdgeInsetsNone());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.perkCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.centerY).insets(kTHLEdgeInsetsNone());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    
}

#pragma mark - Constructors

- (UIImageView *)perkImageView {
    if (!_perkImageView) {
        _perkImageView = [UIImageView new];
        _perkImageView.contentMode = UIViewContentModeScaleAspectFill;
        _perkImageView.clipsToBounds = YES;
        _perkImageView.layer.cornerRadius = 5;
        _perkImageView.layer.masksToBounds = YES;
        [_perkImageView dimView];
        [self.contentView addSubview:_perkImageView];
    }

    return _perkImageView;
}

- (UILabel *)perkTitleLabel {
    if (!_perkTitleLabel) {
        _perkTitleLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _perkTitleLabel.adjustsFontSizeToFitWidth = YES;
        _perkTitleLabel.numberOfLines = 2;
        _perkTitleLabel.minimumScaleFactor = 0.5;
        _perkTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_perkTitleLabel];
    }
    
    return _perkTitleLabel;
  
}

- (UILabel *)perkCreditsLabel {
    if (!_perkCreditsLabel) {
        _perkCreditsLabel = THLNUILabel(kTHLNUIDetailTitle);
        _perkCreditsLabel.numberOfLines = 1;
        _perkCreditsLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_perkCreditsLabel];
    }
    return _perkCreditsLabel;

}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}
@end
