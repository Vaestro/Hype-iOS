//
//  THLUserProfileTableViewCell.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfileTableViewCell.h"
#import "THLAppearanceConstants.h"

@interface THLUserProfileTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *disclosureIcon;

@end

@implementation THLUserProfileTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        
    }
    return self;
}

- (void)constructView {
    _titleLabel = [self newTitleLabel];
    _disclosureIcon = [self newDisclosureIcon];
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel, _disclosureIcon]];
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.insets(kTHLEdgeInsetsNone());
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.right.equalTo([WSELF titleLabel].mas_left);
    }];
    
    [_disclosureIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.insets(kTHLEdgeInsetsNone());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
        make.size.equalTo(CGSizeMake1(20));
    }];

}

- (void)bindView {
    RAC(self.titleLabel, text) = RACObserve(self, title);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.textColor = [UIColor whiteColor];
    return label;
}

- (UIImageView *)newDisclosureIcon {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"cell_disclosure_icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end