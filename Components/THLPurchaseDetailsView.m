//
//  THLPurchaseDetailsView.m
//  Hype
//
//  Created by Edgar Li on 5/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPurchaseDetailsView.h"
#import "THLAppearanceConstants.h"
#import "THLPromotionInfoView.h"

@interface THLPurchaseDetailsView()
@property (nonatomic, strong) UILabel *purchaseTitleLabel;
@property (nonatomic, strong) UILabel *subtotalLabel;
@property (nonatomic, strong) UILabel *serviceChargeLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIView *lineItemSeparatorView;

@end

@implementation THLPurchaseDetailsView
- (void)constructView {
    [super constructView];
    _purchaseTitleLabel = [self newPurchaseTitleLabel];
    _subtotalLabel = [self newSubtotalLabel];
    _serviceChargeLabel = [self newServiceChargeLabel];
    _totalLabel = [self newTotalLabel];
    _lineItemSeparatorView = [self newLineItemSeparatorView];

}

- (void)layoutView {
    [super layoutView];
    UILabel *subtotalDesciptionLabel = THLNUILabel(kTHLNUIDetailTitle);
    subtotalDesciptionLabel.text = @"Subtotal";
    UILabel *serviceChargeDesciptionLabel = THLNUILabel(kTHLNUIDetailTitle);
    serviceChargeDesciptionLabel.text = @"Service Charge";
    UILabel *totalDescriptionLabel = THLNUILabel(kTHLNUIDetailTitle);
    totalDescriptionLabel.text = @"Total";
    
    [self.contentView addSubviews:@[_purchaseTitleLabel, subtotalDesciptionLabel, _subtotalLabel, serviceChargeDesciptionLabel, _serviceChargeLabel, totalDescriptionLabel, _totalLabel, _lineItemSeparatorView]];
    
    WEAKSELF();
    [_purchaseTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [subtotalDesciptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF purchaseTitleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_subtotalLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF purchaseTitleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo(subtotalDesciptionLabel.mas_right);
        make.right.insets(kTHLEdgeInsetsNone());
    }];
    

    [serviceChargeDesciptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subtotalDesciptionLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_serviceChargeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF subtotalLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo(serviceChargeDesciptionLabel.mas_right);
        make.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_lineItemSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceChargeDesciptionLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsLow());
        make.height.equalTo(0.5);
    }];
    
    [totalDescriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF lineItemSeparatorView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_totalLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF lineItemSeparatorView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo(totalDescriptionLabel.mas_right);
        make.right.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    [super bindView];
    RAC(self.purchaseTitleLabel, text, @"") = RACObserve(self, purchaseTitleText);
    RAC(self.subtotalLabel, text, @"") = RACObserve(self, subtotalAmount);
    RAC(self.serviceChargeLabel, text, @"") = RACObserve(self, serviceChargeAmount);
    RAC(self.totalLabel, text, @"") = RACObserve(self, totalAmount);
}

- (UILabel *)newPurchaseTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [label setTintColor:kTHLNUIAccentColor];
    return label;
}

- (UILabel *)newSubtotalLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newServiceChargeLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newTotalLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 0;
    return label;
}

- (UIView *)newLineItemSeparatorView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = [UIColor grayColor];
    return view;
}

@end
