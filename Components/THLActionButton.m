//
//  THLActionButton.m
//  HypeUp
//
//  Created by Edgar Li on 1/31/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLActionButton.h"
#import "THLAppearanceConstants.h"
#import "FXLabel.h"

@interface THLActionButton()
@property (nonatomic, strong) FXLabel *fxLabel;
@property (nonatomic) BOOL inverse;

@end

@implementation THLActionButton
- (instancetype)initWithDefaultStyle {
    if (self = [super init]) {
        self.inverse = FALSE;
        [self.fxLabel setBackgroundColor:kTHLNUIAccentColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.layer setCornerRadius:2.0];

    }
    return self;
}

- (instancetype)initWithInverseStyle {
    if (self = [super init]) {
        self.inverse = TRUE;
        [self setTintColor:[UIColor clearColor]];
        [self.fxLabel setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:1.0];
        [self.layer setCornerRadius:2.0];

//        Accent Color with opacity set at 0.5
        [self.layer setBorderColor:[[UIColor colorWithRed:0.773 green:0.702 blue:0.345 alpha:0.5] CGColor]];
        [self setTitleColor:kTHLNUIPrimaryFontColor forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self addSubview:self.fxLabel];
    WEAKSELF();
    [_fxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(WSELF.titleEdgeInsets);
    }];
}

- (void)setTitle:(NSString *)title {
    [self.fxLabel setText:title];
    if (_inverse) {
        [self.fxLabel setTextColor:kTHLNUIPrimaryFontColor];
    } else {
        [self.fxLabel setTextColor:[UIColor blackColor]];
    }

}

- (FXLabel *)fxLabel {
    if (!_fxLabel) {
        FXLabel *label = [[FXLabel alloc] init];
        //        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.characterSpacing = 0.25f;
        label.font = [UIFont fontWithName:@"Raleway-Regular" size:14];
        _fxLabel = label;
    }
    return _fxLabel;
}
@end
