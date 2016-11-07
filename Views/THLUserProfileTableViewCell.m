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

@end

@implementation THLUserProfileTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.accessoryView = [[ UIImageView alloc ]
//                              initWithImage:[UIImage imageNamed:@"cell_disclosure_icon" ]];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.insets(kTHLEdgeInsetsNone());
            make.left.offset(20);
        }];
    }
    return self;
}

#pragma mark - Constructors
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }

    return _titleLabel;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
