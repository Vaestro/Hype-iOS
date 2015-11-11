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
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel]];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.insets(kTHLEdgeInsetsLow());
    }];
}

- (void)bindView {
    RAC(self.titleLabel, text) = RACObserve(self, title);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    return label;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end