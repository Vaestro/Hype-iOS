//
//  THLFAQSectionView.m
//  HypeUp
//
//  Created by Nik Cane on 02/02/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLFAQSectionView.h"

@interface THLFAQSectionView()

@property (nonatomic, strong) UILabel *howTitle;
@property (nonatomic, strong) UILabel *howDescription;
@property (nonatomic, strong) UIImageView *howImage;
@property (nonatomic, strong) UIView *separator;

@end

@implementation THLFAQSectionView

#pragma mark - View cycle

- (instancetype) initWithTitle:(NSString *)title
                   description:(NSString *)description
                         image:(UIImage *)image
                separatorStyle:(FAQSeparatorStyle)separatorStyle
{
    if (self == [super init]){
        [self newTitlLabelWithText:title];
        [self newDescriptionLabelWithText:description];
        [self newImageViewWithImage: image];
        [self newSeparatorViewWithStyle: separatorStyle];
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self addSubviews:@[_howTitle, _howImage, _howDescription, _separator]];
    [self layoutView];
    
}

- (void) layoutView
{
    [_howTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(_howImage.top);
    }];
    [_howImage makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.bounds.size.width / 3);
        make.center.equalTo(self.center);
    }];
    [_howDescription makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_howImage.bottom);
        make.width.equalTo(self.width);
        make.height.equalTo(40);
    }];
    [_separator makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.bounds.size.width / 5 * 4);
        make.height.equalTo(2);
    }];
}
    
#pragma mark constructors

- (void) newTitlLabelWithText:(NSString *) title
{
    _howTitle = [UILabel new];
    _howTitle.text = title;
    _howTitle.textAlignment = NSTextAlignmentCenter;
    _howTitle.textColor = [UIColor whiteColor];
    _howTitle.font = [UIFont systemFontOfSize:22.0];
}

- (void) newDescriptionLabelWithText:(NSString *) description
{
    _howDescription = [UILabel new];
    _howDescription.text = description;
    _howDescription.textAlignment = NSTextAlignmentCenter;
    _howDescription.textColor = [UIColor whiteColor];
    _howDescription.font = [UIFont systemFontOfSize:14.0];
    _howDescription.numberOfLines = 0;
    _howDescription.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void) newImageViewWithImage:(UIImage *) image
{
    _howImage = [UIImageView new];
    _howImage.image = image;
}

- (void) newSeparatorViewWithStyle:(FAQSeparatorStyle) separatorStyle
{
    _separator = [UIView new];
    switch (separatorStyle) {
        case SlimWhiteLine:
            _separator.backgroundColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

@end
