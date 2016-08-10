//
//  THLSelectView.m
//  Hype
//
//  Created by Edgar Li on 7/28/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLSelectView.h"
#import "THLAppearanceConstants.h"
#import "FXLabel.h"

@interface THLSelectView()
@property (nonatomic, strong) UIButton *increaseButton;
@property (nonatomic, strong) UIButton *decreaseButton;
@property (nonatomic) int selectedIndex;
@end

@implementation THLSelectView
- (instancetype)initWithValues:(NSArray *)values {
    if (self = [super init]) {
        self.values = values;
        self.selectedIndex = 0;
        WEAKSELF();
        [self.selectedItemLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(WSELF);
        }];
        
        [self.descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.selectedItemLabel.mas_bottom);
            make.centerX.equalTo(WSELF);
            make.width.equalTo(SCREEN_WIDTH*0.67);
        }];
        
        [self.increaseButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(WSELF);
            make.centerY.equalTo(WSELF);
        }];
        
        [self.decreaseButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(WSELF);
            make.centerY.equalTo(WSELF);
        }];
    }
    return self;
}

- (void)handleIncreaseAction {
    NSUInteger availableIndexes = self.values.count - 1;
    if (self.selectedIndex < availableIndexes) {
        self.selectedIndex += 1;
        self.selectedItemLabel.text = self.values[self.selectedIndex];
        [self.delegate selectViewDidChangeValue];
    }
}

- (void)handleDecreaseAction {
    if (self.selectedIndex > 0) {
        self.selectedIndex -= 1;
        self.selectedItemLabel.text = self.values[self.selectedIndex];
        [self.delegate selectViewDidChangeValue];
    }
}

- (UILabel *)selectedItemLabel {
    if (!_selectedItemLabel) {
        _selectedItemLabel = [UILabel new];
        _selectedItemLabel.font = [UIFont systemFontOfSize:36.0f];
        _selectedItemLabel.textColor = [UIColor whiteColor];
        _selectedItemLabel.text = self.values[0];
        _selectedItemLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_selectedItemLabel];
    }
    return _selectedItemLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.adjustsFontSizeToFitWidth = true;
        _descriptionLabel.numberOfLines = 0;
        [self addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

- (UIButton *)increaseButton {
    if (!_increaseButton) {
        _increaseButton = [UIButton new];
        _increaseButton.frame = CGRectMake(0, 0, 50, 50);

        [_increaseButton setImage:[UIImage imageNamed:@"incrementor"] forState:UIControlStateNormal];

        [_increaseButton addTarget:self action:@selector(handleIncreaseAction) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_increaseButton];
    }
    return _increaseButton;
}

- (UIButton *)decreaseButton {
    if (!_decreaseButton) {
        _decreaseButton = [UIButton new];
        _decreaseButton.frame = CGRectMake(0, 0, 50, 50);

        [_decreaseButton setImage:[UIImage imageNamed:@"incrementor"] forState:UIControlStateNormal];
        _decreaseButton.transform = CGAffineTransformMakeScale(-1, 1);

        [_decreaseButton addTarget:self action:@selector(handleDecreaseAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_decreaseButton];
    }
    return _decreaseButton;
}

@end