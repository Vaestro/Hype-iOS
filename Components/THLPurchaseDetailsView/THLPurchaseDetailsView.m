//
//  THLPurchaseDetailsView.m
//  Hype
//
//  Created by Edgar Li on 5/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPurchaseDetailsView.h"
#import "THLAppearanceConstants.h"

@interface THLPurchaseDetailsView()
@property (nonatomic, strong) UILabel *subtotalDesciptionLabel;
@property (nonatomic, strong) UILabel *totalDescriptionLabel;
@property (nonatomic, strong) UIView *lineItemSeparatorView;

@end

@implementation THLPurchaseDetailsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (instancetype)initForTableReservationWithSubtotal:(NSString *)subtotal purchaseTitle:(NSString *)purchaseTitle tax:(NSString *)tax tip:(NSString *)tip total:(NSString *)total {
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.text = @"Table Reservation Details";
        self.purchaseTitleLabel.text = purchaseTitle;
        self.subtotalLabel.text = subtotal;
        self.taxLabel.text = tax;
        self.tipLabel.text = tip;
        self.totalLabel.text = total;
        [self layoutView];
    }
    return self;
}

- (instancetype)initForTicketWithSubtotal:(NSString *)subtotal purchaseTitle:(NSString *)purchaseTitle serviceCharge:(NSString *)serviceCharge total:(NSString *)total {
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.text = @"Purchase Details";
        self.purchaseTitleLabel.text = purchaseTitle;
        self.subtotalLabel.text = subtotal;
        self.serviceChargeLabel.text = serviceCharge;
        self.totalLabel.text = total;
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    WEAKSELF();
    [self.purchaseTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.subtotalDesciptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF purchaseTitleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.subtotalLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF purchaseTitleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo(WSELF.subtotalDesciptionLabel.mas_right);
        make.right.insets(kTHLEdgeInsetsNone());
    }];
    
    if (_serviceChargeLabel.text) {
        [self.serviceChargeDesciptionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.subtotalLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.insets(kTHLEdgeInsetsNone());
        }];
        
        [self.serviceChargeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF subtotalLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.equalTo(WSELF.serviceChargeDesciptionLabel.mas_right);
            make.right.insets(kTHLEdgeInsetsNone());
        }];
    }

    if (_taxLabel.text) {

        [self.taxDescriptionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF subtotalLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.insets(kTHLEdgeInsetsNone());
        }];

        [self.taxLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF subtotalLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.equalTo(WSELF.taxDescriptionLabel.mas_right);
            make.right.insets(kTHLEdgeInsetsNone());
        }];
    }
    
    if (_tipLabel.text) {

        [self.tipDescriptionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF taxDescriptionLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.insets(kTHLEdgeInsetsNone());
        }];
        
        [self.tipLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF taxDescriptionLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.equalTo(WSELF.tipDescriptionLabel.mas_right);
            make.right.insets(kTHLEdgeInsetsNone());
        }];
        
        [self.lineItemSeparatorView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.tipDescriptionLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.right.insets(kTHLEdgeInsetsLow());
            make.height.equalTo(0.5);
        }];
    } else {
        [self.lineItemSeparatorView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.serviceChargeDesciptionLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.right.insets(kTHLEdgeInsetsLow());
            make.height.equalTo(0.5);
        }];
    }
    
    [self.totalDescriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF lineItemSeparatorView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.bottom.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.totalLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF lineItemSeparatorView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo(WSELF.totalDescriptionLabel.mas_right);
        make.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (UILabel *)subtotalDesciptionLabel {
    if (!_subtotalDesciptionLabel) {
        _subtotalDesciptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _subtotalDesciptionLabel.text = @"Subtotal";
        [self.contentView addSubview:_subtotalDesciptionLabel];
    }
    return _subtotalDesciptionLabel;
}

- (UILabel *)taxDescriptionLabel {
    if (!_taxDescriptionLabel && _taxLabel) {
        _taxDescriptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _taxDescriptionLabel.text = @"Tax (8.65%)";
        [self.contentView addSubview:_taxDescriptionLabel];
    }
    return _taxDescriptionLabel;
}

- (UILabel *)tipDescriptionLabel {
    if (!_tipDescriptionLabel && _tipLabel) {
        _tipDescriptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _tipDescriptionLabel.text = @"Tip (20%)";
        [self.contentView addSubview:_tipDescriptionLabel];
    }
    return _tipDescriptionLabel;
}

- (UILabel *)serviceChargeDesciptionLabel {
    if (!_serviceChargeDesciptionLabel && _serviceChargeLabel) {
        _serviceChargeDesciptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _serviceChargeDesciptionLabel.text = @"Service Charge";
        [self.contentView addSubview:_serviceChargeDesciptionLabel];
    }
    return _serviceChargeDesciptionLabel;
}

- (UILabel *)totalDescriptionLabel {
    if (!_totalDescriptionLabel) {
        _totalDescriptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _totalDescriptionLabel.text = @"Total";
        [self.contentView addSubview:_totalDescriptionLabel];
    }

    return _totalDescriptionLabel;
}

- (UILabel *)purchaseTitleLabel {
    if (!_purchaseTitleLabel) {
        _purchaseTitleLabel = THLNUILabel(kTHLNUIDetailTitle);
        _purchaseTitleLabel.adjustsFontSizeToFitWidth = YES;
        _purchaseTitleLabel.minimumScaleFactor = 0.5;
        _purchaseTitleLabel.textAlignment = NSTextAlignmentLeft;
        _purchaseTitleLabel.numberOfLines = 0;
        [_purchaseTitleLabel setTintColor:kTHLNUIAccentColor];
        [self.contentView addSubview:_purchaseTitleLabel];
    }

    return _purchaseTitleLabel;
}

- (UILabel *)subtotalLabel {
    if (!_subtotalLabel) {
        _subtotalLabel = THLNUILabel(kTHLNUIDetailTitle);
        _subtotalLabel.adjustsFontSizeToFitWidth = YES;
        _subtotalLabel.minimumScaleFactor = 0.5;
        _subtotalLabel.textAlignment = NSTextAlignmentRight;
        _subtotalLabel.numberOfLines = 0;
        [self.contentView addSubview:_subtotalLabel];
    }
    return _subtotalLabel;
}

- (UILabel *)taxLabel {
    if (!_taxLabel) {
        _taxLabel = THLNUILabel(kTHLNUIDetailTitle);
        _taxLabel.adjustsFontSizeToFitWidth = YES;
        _taxLabel.minimumScaleFactor = 0.5;
        _taxLabel.textAlignment = NSTextAlignmentRight;
        _taxLabel.numberOfLines = 0;
        [self.contentView addSubview:_taxLabel];
    }
    return _taxLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = THLNUILabel(kTHLNUIDetailTitle);
        _tipLabel.adjustsFontSizeToFitWidth = YES;
        _tipLabel.minimumScaleFactor = 0.5;
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.numberOfLines = 0;
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)serviceChargeLabel {
    if (!_serviceChargeLabel) {
        _serviceChargeLabel = THLNUILabel(kTHLNUIDetailTitle);
        _serviceChargeLabel.adjustsFontSizeToFitWidth = YES;
        _serviceChargeLabel.minimumScaleFactor = 0.5;
        _serviceChargeLabel.textAlignment = NSTextAlignmentRight;
        _serviceChargeLabel.numberOfLines = 0;
        [self.contentView addSubview:_serviceChargeLabel];
    }

    return _serviceChargeLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = THLNUILabel(kTHLNUIDetailTitle);
        _totalLabel.adjustsFontSizeToFitWidth = YES;
        _totalLabel.minimumScaleFactor = 0.5;
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.numberOfLines = 0;
        [self.contentView addSubview:_totalLabel];
    }
    return _totalLabel;
}

- (UIView *)lineItemSeparatorView {
    if (!_lineItemSeparatorView) {
        _lineItemSeparatorView = THLNUIView(kTHLNUIUndef);
        _lineItemSeparatorView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineItemSeparatorView];
    }

    return _lineItemSeparatorView;
}

- (void)display
{
    CALayer *layer = self.layer;
    [layer setNeedsDisplay];
    [layer displayIfNeeded];
}



@end
