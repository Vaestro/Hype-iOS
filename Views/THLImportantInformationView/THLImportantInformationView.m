//
//  THLImportantInformationView.m
//  Hype
//
//  Created by Edgar Li on 5/31/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLImportantInformationView.h"
#import "THLAppearanceConstants.h"

@implementation THLImportantInformationView
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    [self.importantInformationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
}

- (UILabel *)importantInformationLabel {
    if (!_importantInformationLabel) {
        _importantInformationLabel = THLNUILabel(kTHLNUIDetailTitle);
        _importantInformationLabel.adjustsFontSizeToFitWidth = YES;
        _importantInformationLabel.minimumScaleFactor = 0.5;
        _importantInformationLabel.textAlignment = NSTextAlignmentLeft;
        _importantInformationLabel.numberOfLines = 0;
        [self.contentView addSubview:_importantInformationLabel];
    }

    return _importantInformationLabel;
}

@end
