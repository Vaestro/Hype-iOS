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
    self.accessoryView = [[ UIImageView alloc ]
                            initWithImage:[UIImage imageNamed:@"cell_disclosure_icon" ]];
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel]];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.insets(kTHLEdgeInsetsNone());
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.right.equalTo(kTHLEdgeInsetsNone());
    }];

}

- (void)bindView {
    RAC(self.titleLabel, text) = RACObserve(self, title);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = kTHLNUISecondaryBackgroundColor;
    label.font = [UIFont fontWithName:@"OpenSans-Light" size:16];

    label.textColor = [UIColor whiteColor];
    return label;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end