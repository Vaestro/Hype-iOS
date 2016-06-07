//
//  THLPermissionRequestViewController.m
//  Hype
//
//  Created by Edgar Li on 6/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPermissionRequestViewController.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"
#import <Parse/Parse.h>
#import "Intercom/intercom.h"

@interface THLPermissionRequestViewController()
<
UIApplicationDelegate
>

@property (nonatomic, strong) THLActionButton *allowButton;
@property (nonatomic, strong) UIButton *declineButton;
@property (nonatomic, strong) UIImageView *previewImage;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THLPermissionRequestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WEAKSELF();
    self.view.backgroundColor = [UIColor blackColor];
    [self.declineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [self.allowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsInsanelyHigh());
        make.bottom.equalTo(WSELF.declineButton.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.previewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(WSELF.allowButton.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCREEN_WIDTH*0.69);
        make.centerX.equalTo(0);
        make.bottom.equalTo(WSELF.previewImage.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];

}

- (void)requestPermission {
    UIApplication *application = [UIApplication sharedApplication];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];   
}

- (void)declinePermission {
    [self.delegate permissionViewControllerDeclinedPermission];
}

#pragma mark - Accessors

- (UIImageView *)previewImage {
    if (!_previewImage) {
        _previewImage = [UIImageView new];
        _previewImage.image = [UIImage imageNamed:@"push_notification_preview"];
        _previewImage.contentMode = UIViewContentModeScaleAspectFit;
        _previewImage.clipsToBounds = YES;
        [self.view addSubview:_previewImage];
    }
    
    return _previewImage;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIRegularTitle);
        _titleLabel.text = @"Get notified when your friends invite you to party";
        _titleLabel.numberOfLines = 0;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (THLActionButton *)allowButton
{
    if (!_allowButton) {
        _allowButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_allowButton setTitle:@"ALLOW NOTIFICATIONS"];
        [_allowButton addTarget:self action:@selector(requestPermission) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_allowButton];
    }
    return _allowButton;
}

- (UIButton *)declineButton
{
    if (!_declineButton) {
        _declineButton = [UIButton new];
        [_declineButton setTitle:@"No thanks, I like partying by myself" forState:UIControlStateNormal];
        [_declineButton setTitleColor:kTHLNUIPrimaryFontColor];
        [_declineButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-Regular" size:13.0f]];
        [_declineButton addTarget:self action:@selector(declinePermission) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_declineButton];
    }
    return _declineButton;
}

@end
