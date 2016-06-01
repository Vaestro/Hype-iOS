//
//  THLFAQSectionView.m
//  Hype
//
//  Created by Nik Cane on 02/02/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLFAQSectionView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLFQASectionImageViewHeight = 150;
static CGFloat const kTHLFAQSectionTitleFontSize = 22.0;
static CGFloat const kTHLFAQSectionDescriptionFontSize = 14.0;
static CGFloat const kTHLFAQSectionDescriptionHeight = 40.0;
static CGFloat const kTHLFAQSectionSeparatorHeight = 2.0;

@interface THLFAQSectionView()

@property (nonatomic, strong) UILabel *howTitle;
@property (nonatomic, strong) UILabel *howDescription;
@property (nonatomic, strong) UIImageView *howImage;
@property (nonatomic, strong) UIView *separator;

@end

@implementation THLFAQSectionView

#pragma mark - View cycle

- (void) constructView
{
    _howTitle = [self newTitleLabel];
    _howDescription = [self newDescriptionLabel];
    _howImage = [self newImageView];
    _separator = [self newSeparatorView];
}

- (void) layoutView
{
    [self.contentView addSubviews:@[_howTitle,
                                    _howImage,
                                    _howDescription,
                                    _separator]];
    @weakify(self)
    [_howTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsLow());
        make.left.right.equalTo(kTHLEdgeInsetsNone());
    }];
    [_howImage makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(kTHLEdgeInsetsNone());
        make.top.equalTo([self howTitle].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(kTHLEdgeInsetsHigh());
        make.height.equalTo(kTHLFQASectionImageViewHeight);
    }];
    [_howDescription makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo([self howImage].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.right.equalTo(kTHLEdgeInsetsNone());
        make.height.equalTo(kTHLFAQSectionDescriptionHeight);
    }];
    [_separator makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kTHLEdgeInsetsHigh());
        make.height.equalTo(kTHLFAQSectionSeparatorHeight);
        make.bottom.equalTo(kTHLEdgeInsetsNone());
    }];
}

- (void) bindView
{
    RAC(self.howTitle, text) = RACObserve(self, titleString);
    RAC(self.howImage, image) = RACObserve(self, image);
    RAC(self.howDescription, text) = RACObserve(self, descriptionString);
}

#pragma mark constructors

- (UILabel *) newTitleLabel
{
    UILabel* titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:kTHLFAQSectionTitleFontSize];
    return titleLabel;
}

- (UILabel *) newDescriptionLabel
{
    UILabel *descriptionLabel = [UILabel new];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont systemFontOfSize:kTHLFAQSectionDescriptionFontSize];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return descriptionLabel;
}

- (UIImageView *) newImageView
{
    UIImageView *image = [UIImageView new];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    return image;
}

- (UIView *) newSeparatorView
{
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [UIColor whiteColor];
    return separatorView;
}

@end
