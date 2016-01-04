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
@property (nonatomic, strong) UILabel *ageRequirementLabel;
@property (nonatomic, strong) UILabel *attireRequirementLabel;
@end

@implementation THLNeedToKnowInfoView
- (void)constructView {
    [super constructView];
    _ratioInfoLabel = [self newRatioInfoLabel];
    _coverInfoLabel = [self newCoverInfoLabel];
    _photoIdLabel = [self newPhotoIdLabel];
    _ageRequirementLabel = [self newAgeRequirementLabel];
    _attireRequirementLabel = [self newAttireRequirementLabel];
}

- (void)layoutView {
    [super layoutView];
    [self.contentView addSubviews:@[_ratioInfoLabel, _coverInfoLabel, _photoIdLabel, _ageRequirementLabel, _attireRequirementLabel]];
    WEAKSELF();
    [_ratioInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_coverInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF ratioInfoLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_attireRequirementLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF coverInfoLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_photoIdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF attireRequirementLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_ageRequirementLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF photoIdLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    [super bindView];

    RAC(self.ratioInfoLabel, infoText, @"") = RACObserve(self, ratioText);
    RAC(self.coverInfoLabel, infoText, @"") = RACObserve(self, coverFeeText);
    RAC(self.attireRequirementLabel, text, @"") = RACObserve(self, attireRequirement);
}

- (THLPromotionInfoView *)newRatioInfoLabel {
    THLPromotionInfoView *ratioInfoLabel = [THLPromotionInfoView new];
    ratioInfoLabel.labelText = @"Suggested Ratio";
    return ratioInfoLabel;
}

- (THLPromotionInfoView *)newCoverInfoLabel {
    THLPromotionInfoView *coverInfoLabel = [THLPromotionInfoView new];
    coverInfoLabel.labelText = @"Venue Cover";
    return coverInfoLabel;
}

- (UILabel *)newPhotoIdLabel {
    UILabel *photoIdLabel = THLNUILabel(kTHLNUIDetailTitle);
    photoIdLabel.text = @"Photo ID Required";
    photoIdLabel.adjustsFontSizeToFitWidth = YES;
    photoIdLabel.minimumScaleFactor = 0.5;
    photoIdLabel.textAlignment = NSTextAlignmentLeft;
    photoIdLabel.numberOfLines = 0;
    return photoIdLabel;
}

- (UILabel *)newAgeRequirementLabel {
    UILabel *ageRequirementLabel = THLNUILabel(kTHLNUIDetailTitle);
    ageRequirementLabel.text = @"21+";
    ageRequirementLabel.adjustsFontSizeToFitWidth = YES;
    ageRequirementLabel.minimumScaleFactor = 0.5;
    ageRequirementLabel.textAlignment = NSTextAlignmentLeft;
    ageRequirementLabel.numberOfLines = 0;
    return ageRequirementLabel;
}

- (UILabel *)newAttireRequirementLabel {
    UILabel *attireRequirementLabel = THLNUILabel(kTHLNUIDetailTitle);
    return attireRequirementLabel;
}

@end
