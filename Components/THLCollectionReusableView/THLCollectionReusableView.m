//
//  THLCollectionReusableView.m
//  Hype
//
//  Created by Daniel Aksenov on 6/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLCollectionReusableView.h"
#import "THLAppearanceConstants.h"

@interface THLCollectionReusableView()
@property (nonatomic, strong, readonly) UIView *separatorView;
@end

@implementation THLCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _label = THLNUILabel(kTHLNUISectionTitle);
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.numberOfLines = 1;
    _label.adjustsFontSizeToFitWidth = true;

    [self addSubview:_label];
    
    _subtitleLabel = THLNUILabel(kTHLNUIDetailTitle);
    _subtitleLabel.textColor = [UIColor whiteColor];

    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.numberOfLines = 1;
    _subtitleLabel.adjustsFontSizeToFitWidth = TRUE;
    [self addSubview:_subtitleLabel];
    
    _separatorView = THLNUIView(kTHLNUIUndef);
    _separatorView.backgroundColor = kTHLNUIAccentColor;
    [self addSubview:_separatorView];
    
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WEAKSELF();
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF label].mas_baseline).insets(kTHLEdgeInsetsLow());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF subtitleLabel].mas_baseline).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF label]);
        make.bottom.insets(kTHLEdgeInsetsHigh());
        
        make.size.equalTo(CGSizeMake(40, 2.5));
        
    }];
    //    _label.frame = self.bounds;
}

@end
