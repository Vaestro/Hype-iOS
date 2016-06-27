//
//  THLUserProfileFooterView.m
//  TheHypelist
//
//  Created by Edgar Li on 12/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfileFooterView.h"
#import "THLAppearanceConstants.h"
#import "THLUser.h"

@interface THLUserProfileFooterView()
@property (nonatomic, strong) UIButton *contactUsButton;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UILabel *appDetailsLabel;
@end

@implementation THLUserProfileFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAndLayoutView];
    }
    return self;
}

- (void)setupAndLayoutView {
    _contactUsButton = [self newContactUsButton];
    _logoutButton = [self newLogoutButton];
    _appDetailsLabel = [self newAppDetailsLabel];
    
//    [self.contentView addSubviews:@[_appDetailsLabel]];
//
//    [_appDetailsLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(kTHLEdgeInsetsHigh());
//        make.left.right.insets(kTHLEdgeInsetsHigh());
//        make.bottom.insets(kTHLEdgeInsetsHigh());
//    }];
    

    RAC(self.contactUsButton, rac_command) = RACObserve(self, emailCommand);
    RAC(self.logoutButton, rac_command) = RACObserve(self, logoutCommand);
}

- (UIButton *)newContactUsButton {
    UIButton *button = [[UIButton alloc]init];
    button.tintColor = [UIColor clearColor];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[kTHLNUIAccentColor CGColor]];
    [button setCornerRadius:kTHLCornerRadius];
    [button setTitle:@"Contact Us" forState:UIControlStateNormal];
    [button setTitleColor:kTHLNUIPrimaryFontColor forState:UIControlStateNormal];
    return button;
}

- (UIButton *)newLogoutButton {
    UIButton *button = [[UIButton alloc]init];
    button.tintColor = [UIColor clearColor];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[kTHLNUIAccentColor CGColor]];
    [button setCornerRadius:kTHLCornerRadius];
    [button setTitle:@"Logout" forState:UIControlStateNormal];
    [button setTitleColor:kTHLNUIPrimaryFontColor forState:UIControlStateNormal];
    return button;
}

- (UILabel *)newAppDetailsLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.text = [NSString stringWithFormat:@"Version %@\nCopyright © %@ HypeList, LLC", APP_VERSION, NSStringFromInt([[NSDate date] year])];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}
@end
