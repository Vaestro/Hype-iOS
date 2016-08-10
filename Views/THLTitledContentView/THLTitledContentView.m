//
//  THLTitledContentView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"
#import "THLAppearanceConstants.h"

@interface THLTitledContentView()
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UILabel *contentTextLabel;

@end

@implementation THLTitledContentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.insets(kTHLEdgeInsetsNone());
        }];
        
        WEAKSELF();
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF titleLabel].mas_baseline).insets(kTHLEdgeInsetsHigh());
            make.left.equalTo([WSELF titleLabel]);
            make.size.equalTo(CGSizeMake(40, 2.5));
        }];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF separatorView].mas_bottom);
            make.left.right.equalTo([WSELF titleLabel]);
            make.bottom.insets(kTHLEdgeInsetsNone());
        }];
    }
    return self;
}

- (void)addContentText:(NSString *)text {
    self.contentTextLabel.text = text;
    [self.contentTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsLow());
        make.bottom.left.right.equalTo(kTHLEdgeInsetsNone());
    }];
}

#pragma mark - Accessors

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUISectionTitle);
        _titleLabel.adjustsFontSizeToFitWidth = true;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentTextLabel {
    if (!_contentTextLabel) {
        _contentTextLabel = THLNUILabel(kTHLNUIDetailTitle);
        _contentTextLabel.textAlignment = NSTextAlignmentLeft;
        _contentTextLabel.numberOfLines = 0;
        [_contentView addSubview:_contentTextLabel];

    }
    return _contentTextLabel;
}


- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = THLNUIView(kTHLNUIUndef);
        _separatorView.backgroundColor = kTHLNUIAccentColor;
        [self addSubview:_separatorView];
    }
    return _separatorView;
}

- (void)dealloc {
    NSLog(@"YA BOY %@ DEALLOCATED", [self class]);
}

@end
