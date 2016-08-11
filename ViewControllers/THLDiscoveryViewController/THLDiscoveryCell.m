//
//  THLDiscoveryCellCollectionViewCell.m
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLDiscoveryCell.h"
#import "THLAppearanceConstants.h"
#import "THLEventTitlesView.h"
#import <ParseUI/PFImageView.h>
#import "UIView+DimView.h"

@implementation THLDiscoveryCell

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews
{
    WEAKSELF();

    [self.venueImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WSELF);
    }];
    
    [self.titlesView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(UIEdgeInsetsZero);
        make.center.equalTo(WSELF);
    }];
    
}

#pragma mark -
#pragma mark Accessors
- (THLEventTitlesView *)titlesView
{
    if (!_titlesView) {
        _titlesView = [THLEventTitlesView new];
        [self.contentView addSubview:_titlesView];
    }
    return _titlesView;
}

- (UILabel *)eventCategoryLabel
{
    if (!_eventCategoryLabel) {
        _eventCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 125.0, 30.0)];
        _eventCategoryLabel.font = [UIFont fontWithName:@"OpenSans-ExtraBold" size:12.0];
        _eventCategoryLabel.text = @"FEATURED EVENT";
        _eventCategoryLabel.textColor = [UIColor blackColor];
        _eventCategoryLabel.numberOfLines = 1;
        _eventCategoryLabel.textAlignment = NSTextAlignmentCenter;
        _eventCategoryLabel.adjustsFontSizeToFitWidth = YES;
        _eventCategoryLabel.minimumScaleFactor = 0.5;
        _eventCategoryLabel.backgroundColor = kTHLNUIAccentColor;
        [self.contentView addSubview:_eventCategoryLabel];
    }
    return _eventCategoryLabel;
}

- (PFImageView *)venueImageView {
    if (!_venueImageView) {
        _venueImageView = [[PFImageView alloc] initWithFrame:CGRectZero];
        _venueImageView.contentMode = UIViewContentModeScaleAspectFill;
        _venueImageView.clipsToBounds = YES;
        _venueImageView.layer.cornerRadius = 5;
        _venueImageView.layer.masksToBounds = YES;
        [_venueImageView dimView];
        [self.contentView addSubview:_venueImageView];
    }
    return _venueImageView;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
