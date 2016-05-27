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
@synthesize titlesView = _titlesView;
@synthesize venueImageView = _venueImageView;


#pragma mark -
#pragma mark UIView

- (void)layoutSubviews
{
    WEAKSELF();
    [_titlesView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.top.left.greaterThanOrEqualTo(SV(WSELF.titlesView)).insets(kTHLEdgeInsetsHigh());
        make.bottom.right.lessThanOrEqualTo(SV(WSELF.titlesView)).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_venueImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
        make.top.left.right.bottom.insets(UIEdgeInsetsZero);
    }];
    
    [self.contentView bringSubviewToFront:_titlesView];

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

- (PFImageView *)venueImageView {
    if (!_venueImageView) {
        _venueImageView = [[PFImageView alloc] initWithFrame:CGRectZero];
        _venueImageView.contentMode = UIViewContentModeScaleAspectFill;
        _venueImageView.clipsToBounds = YES;
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
