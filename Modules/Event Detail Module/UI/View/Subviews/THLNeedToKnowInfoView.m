//
//  THLNeedToKnowInfoView.m
//  Hype
//
//  Created by Edgar Li on 12/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLNeedToKnowInfoView.h"
#import "THLPromotionInfoView.h"
#import "THLAppearanceConstants.h"

@interface THLNeedToKnowInfoView()
@property (nonatomic, strong) THLPromotionInfoView *ratioInfoLabel;
@property (nonatomic, strong) THLPromotionInfoView *coverInfoLabel;
@property (nonatomic, strong) UILabel *photoIdLabel;
@property (nonatomic, strong) UILabel *attireRequirementLabel;
@property (nonatomic, strong) UILabel *doormanDiscretionLabel;
@end

@implementation THLNeedToKnowInfoView
- (void)constructView {
    _ratioInfoLabel = [self newRatioInfoLabel];
    _coverInfoLabel = [self newCoverInfoLabel];
    _photoIdLabel = [self newPhotoIdLabel];
    _attireRequirementLabel = [self newAttireRequirementLabel];
    _doormanDiscretionLabel = [self newDoormanDiscretionLabel];
}

- (void)layoutView {
    [self.contentView addSubviews:@[_ratioInfoLabel, _coverInfoLabel, _photoIdLabel, _attireRequirementLabel, _doormanDiscretionLabel]];
    
    WEAKSELF();
    [_ratioInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_coverInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF ratioInfoLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    
    [_photoIdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF coverInfoLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_attireRequirementLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF photoIdLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];

    
    [_doormanDiscretionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF attireRequirementLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.ratioInfoLabel, infoText, @"") = RACObserve(self, ratioText);
    RAC(self.coverInfoLabel, infoText, @"") = RACObserve(self, coverFeeText);
    RAC(self.attireRequirementLabel, text, @"") = RACObserve(self, attireRequirement);
    [[RACObserve(self, ageRequirement) filter:^BOOL(NSString *value) {
        return value.length > 2;
    }] subscribeNext:^(NSString *x) {
        [WSELF.photoIdLabel setText: [NSString stringWithFormat:@"Must have valid %@+ ID",x]];
    }];

}

- (THLPromotionInfoView *)newRatioInfoLabel {
    THLPromotionInfoView *ratioInfoLabel = [THLPromotionInfoView new];
    ratioInfoLabel.labelText = @"Suggested Ratio";
    return ratioInfoLabel;
}

- (THLPromotionInfoView *)newCoverInfoLabel {
    THLPromotionInfoView *coverInfoLabel = [THLPromotionInfoView new];
    coverInfoLabel.labelText = @"Ticket Price";
    return coverInfoLabel;
}

- (UILabel *)newPhotoIdLabel {
    UILabel *photoIdLabel = THLNUILabel(kTHLNUIDetailTitle);
    photoIdLabel.text = @"Must have valid 21+ ID";
    photoIdLabel.adjustsFontSizeToFitWidth = YES;
    photoIdLabel.minimumScaleFactor = 0.5;
    photoIdLabel.textAlignment = NSTextAlignmentLeft;
    photoIdLabel.numberOfLines = 0;
    return photoIdLabel;
}

- (UILabel *)newAttireRequirementLabel {
    UILabel *attireRequirementLabel = THLNUILabel(kTHLNUIDetailTitle);
    return attireRequirementLabel;
}

- (UILabel *)newDoormanDiscretionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Final admission at doorman’s discretion.";
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

@end
