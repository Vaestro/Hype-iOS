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
@property (nonatomic, strong) UILabel *purchaseTitleLabel;
@property (nonatomic, strong) UILabel *subtotalLabel;
@property (nonatomic, strong) UILabel *serviceChargeLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation THLPurchaseDetailsView
- (void)constructView {
    [super constructView];
    _purchaseTitleLabel = [self newPurchaseTitleLabel];
    _subtotalLabel = [self newSubtotalLabel];
    _serviceChargeLabel = [self newServiceChargeLabel];
    _totalLabel = [self newTotalLabel];
    _separatorView = [self newSeparatorView];

}

- (void)layoutView {
    [super layoutView];
    UILabel *subtotalDesciptionLabel = [UILabel new];
    subtotalDesciptionLabel.text = @"Subtotal";
    UILabel *serviceChargeDesciptionLabel = [UILabel new];
    serviceChargeDesciptionLabel.text = @"Service Charge";
    UILabel *totalDescriptionLabel = [UILabel new];
    totalDescriptionLabel.text = @"Total";
    
    [self.contentView addSubviews:@[_purchaseTitleLabel, subtotalDesciptionLabel, _subtotalLabel, serviceChargeDesciptionLabel, _serviceChargeLabel, totalDescriptionLabel, _totalLabel, _separatorView]];
    
    WEAKSELF();
    [_purchaseTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
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
        make.top.equalTo(subtotalDesciptionLabel.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_serviceChargeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF subtotalLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(serviceChargeDesciptionLabel.right);
        make.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF serviceChargeLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [totalDescriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF separatorView].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_totalLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF separatorView].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(totalDescriptionLabel.right);
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
    label.text = @"Photo ID";
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newSubtotalLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Photo ID";
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newServiceChargeLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"21+";
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newTotalLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    return label;
}

- (UIView *)newSeparatorView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = [UIColor grayColor];
    return view;
}

@end
