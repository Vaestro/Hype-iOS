//
//  THLEventDetailMusicTypesView.m
//  Hype
//
//  Created by Edgar Li on 1/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventDetailMusicTypesView.h"
#import "THLAppearanceConstants.h"

@interface THLEventDetailMusicTypesView()
@property (nonatomic, strong) UILabel *musicTypesLabel;

@end

@implementation THLEventDetailMusicTypesView
- (void)constructView {
    [super constructView];
    _musicTypesLabel = [self newMusicTypesLabel];
}

- (void)layoutView {
    [super layoutView];
    [self.contentView addSubviews:@[_musicTypesLabel]];
    
    [_musicTypesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsNone());
        make.bottom.left.right.equalTo(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    [super bindView];
    RAC(self.musicTypesLabel, text) = RACObserve(self, musicTypesInfo);
}

- (void)updateConstraints {
    [super updateConstraints];
}

#pragma mark - Constructors
- (UILabel *)newMusicTypesLabel {
    UILabel *musicTypesLabel = THLNUILabel(kTHLNUIDetailTitle);
    musicTypesLabel.adjustsFontSizeToFitWidth = YES;
    musicTypesLabel.minimumScaleFactor = 0.5;
    return musicTypesLabel;
}
@end