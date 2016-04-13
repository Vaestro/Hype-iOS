//
//  THLEventDetailsLocationInfoView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailsLocationInfoView.h"
#import "THLAppearanceConstants.h"

@interface THLEventDetailsLocationInfoView()
@property (nonatomic, strong) UILabel *locationInfoLabel;
@property (nonatomic, strong) UIButton *readMoreTextButton;
@property (nonatomic) BOOL infoLabelExpanded;
@end

@implementation THLEventDetailsLocationInfoView
- (void)constructView {
    [super constructView];
    _locationInfoLabel = [self newLocationInfoLabel];
    _readMoreTextButton = [self newReadMoreTextButton];
}

- (void)layoutView {
    [super layoutView];
    [self.contentView addSubviews:@[_locationInfoLabel, _readMoreTextButton]];
    
    WEAKSELF();
    [_locationInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsLow());
        make.left.right.equalTo(kTHLEdgeInsetsNone());
//        make.bottom.equalTo(kTHLEdgeInsetsHigh());
    }];
    
    [_readMoreTextButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.locationInfoLabel.mas_bottom);
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    [super bindView];
    RAC(self.locationInfoLabel, text) = RACObserve(self, locationInfo);
}

- (void)expandText {
    if (_infoLabelExpanded) {
        _locationInfoLabel.numberOfLines = 3;
        _infoLabelExpanded = FALSE;
        _readMoreTextButton.selected = FALSE;
    } else {
        _locationInfoLabel.numberOfLines = 0;
        _infoLabelExpanded = TRUE;
        _readMoreTextButton.selected = TRUE;
    }
    [self setNeedsLayout];
}

#pragma mark - Constructors
- (UILabel *)newLocationInfoLabel {
    UILabel *locationInfoLabel = THLNUILabel(kTHLNUIDetailTitle);
    locationInfoLabel.numberOfLines = 3;
    return locationInfoLabel;
}

- (UIButton *)newReadMoreTextButton {
    UIButton *button = [UIButton new];
    [button addTarget:self action:@selector(expandText) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = NSTextAlignmentLeft;
    [button setTitle:@"Read More" forState:UIControlStateNormal];
    [button setTitle:@"Read Less" forState:UIControlStateSelected];
    [button setTitleColor:kTHLNUIAccentColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Raleway-Regular" size:14.0]];
    
    return button;
}


#pragma mark - Update Layout

-(void)hideReadMoreTextButton {
    [self.readMoreTextButton setHidden:YES];
}
@end