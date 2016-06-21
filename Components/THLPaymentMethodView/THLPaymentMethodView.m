//
//  THLPaymentMethodView.m
//  Hype
//
//  Created by Edgar Li on 5/31/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPaymentMethodView.h"
#import "THLAppearanceConstants.h"

@interface THLPaymentMethodView()
@property (nonatomic, strong) UIImageView *paymentCardIcon;
@property (nonatomic, strong) UIImageView *disclosureIcon;

@end

@implementation THLPaymentMethodView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.disclosureIcon makeConstraints:^(MASConstraintMaker *make) {
            make.right.insets(kTHLEdgeInsetsNone());
            make.centerY.equalTo(0);
        }];
        
        [self.paymentCardIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.insets(kTHLEdgeInsetsNone());
            make.centerY.equalTo(0);
        }];
        WEAKSELF();
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(WSELF.paymentCardIcon.mas_right).insets(kTHLEdgeInsetsHigh());
            make.centerY.equalTo(0);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_paymentTitleLabel) {
        _paymentTitleLabel = THLNUILabel(kTHLNUIDetailTitle);
        [self addSubview:_paymentTitleLabel];
    }
    return _paymentTitleLabel;
}


- (UIImageView *)paymentCardIcon {
    if (!_paymentCardIcon) {
        _paymentCardIcon = [UIImageView new];
        _paymentCardIcon.image = [UIImage imageNamed:@"payment_card"];
        _paymentCardIcon.contentMode = UIViewContentModeScaleAspectFit;
        _paymentCardIcon.clipsToBounds = YES;
        [self addSubview:_paymentCardIcon];
    }
    
    return _paymentCardIcon;
}

- (UIImageView *)disclosureIcon {
    if (!_disclosureIcon) {
        _disclosureIcon = [UIImageView new];
        _disclosureIcon.image = [UIImage imageNamed:@"disclosure_icon"];
        _disclosureIcon.contentMode = UIViewContentModeScaleAspectFit;
        _disclosureIcon.clipsToBounds = YES;
        [self addSubview:_disclosureIcon];
    }
    return _disclosureIcon;
}


@end
