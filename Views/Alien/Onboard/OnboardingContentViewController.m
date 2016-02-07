//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"
#import "THLAppearanceConstants.h"
#import "THLInformationViewController.h"
#import "THLResourceManager.h"

typedef NS_OPTIONS(NSInteger, THLOnboardingState) {
    THLOnboardingStateInitial = 0,
    THLOnboardingStateBody,
    THLOnboardingStateEnd
};

static const CGFloat kLogoImageSize = 50.0f;

@interface OnboardingContentViewController ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic) THLOnboardingState onboardingState;
@end

@implementation OnboardingContentViewController

+ (instancetype)initialContentWithTitle:(NSString *)title body:(NSString *)body backgroundVideo:(NSURL *)videoURL {
    OnboardingContentViewController *contentVC = [[self alloc] initWithInitialTitle:title body:body backgroundVideo:videoURL];
    return contentVC;
}

- (instancetype)initWithInitialTitle:(NSString *)title body:(NSString *)body backgroundVideo:(NSURL *)videoURL {
    self = [super init];
    
    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _onboardingState = THLOnboardingStateInitial;
    _titleText = title;
    _body = body;
    _videoURL = videoURL;
    self.moviePlayerController = [MPMoviePlayerController new];

    
    // default auto-navigation
    self.movesToNextViewController = NO;
    
    // default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};
    
    return self;
}

+ (instancetype)finalContentWithTitle:(NSString *)title body:(NSString *)body backgroundImage:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action secondaryButtonText:(NSString *)secondaryButtonText secondaryAction:(dispatch_block_t)secondaryAction {
    OnboardingContentViewController *contentVC = [[self alloc] initWithFinalTitle:title body:body backgroundImage:image buttonText:buttonText action:action secondaryButtonText:secondaryButtonText secondaryAction:secondaryAction];
    return contentVC;
}

- (instancetype)initWithFinalTitle:(NSString *)title body:(NSString *)body backgroundImage:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action secondaryButtonText:(NSString *)secondaryButtonText secondaryAction:(dispatch_block_t)secondaryAction {
    return [self initWithFinalTitle:title
                          body:body
                         backgroundImage:image
                    buttonText:buttonText
                   actionBlock:^(OnboardingViewController *onboardController) {
                       if(action) action();
                   }
           secondaryButtonText:secondaryButtonText
          secondaryActionBlock:^(OnboardingViewController *onboardController) {
              if(secondaryAction) secondaryAction();
          }];
}

+ (instancetype)finalContentWithTitle:(NSString *)title body:(NSString *)body backgroundImage:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock secondaryButtonText:(NSString *)secondaryButtonText secondaryActionBlock:(action_callback)secondaryActionBlock {
    OnboardingContentViewController *contentVC = [[self alloc] initWithFinalTitle:title body:body backgroundImage:image buttonText:buttonText actionBlock:actionBlock secondaryButtonText:secondaryButtonText secondaryActionBlock:secondaryActionBlock];
    return contentVC;
}

- (instancetype)initWithFinalTitle:(NSString *)title body:(NSString *)body backgroundImage:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock secondaryButtonText:(NSString *)secondaryButtonText secondaryActionBlock:(action_callback)secondaryActionBlock {
    self = [super init];
    
    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _onboardingState = THLOnboardingStateEnd;
    _subtitleText = title;
    _image = image;
    _buttonText = buttonText;
    _secondaryButtonText = secondaryButtonText;
    
    self.buttonActionHandler = actionBlock;
    self.secondaryButtonActionHandler = secondaryActionBlock;
    
    // default auto-navigation
    self.movesToNextViewController = NO;
    
    // default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};
    
    return self;
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body image:image];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image  {
    self = [super init];
    
    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _onboardingState = THLOnboardingStateBody;

    _titleText = title;
    _body = body;
    _image = image;

    // default auto-navigation
    self.movesToNextViewController = NO;
    
    // default icon properties
    if(_image) {
        self.iconHeight = SCREEN_HEIGHT;
        self.iconWidth = SCREEN_WIDTH;
    }
    
    else {
        self.iconHeight = SCREEN_HEIGHT;
        self.iconWidth = SCREEN_WIDTH;
    }
    
    // default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded we can generate the content
    [self constructView];
    if (_onboardingState == THLOnboardingStateInitial) {
        [self layoutInitialView];
    } else if (_onboardingState == THLOnboardingStateEnd) {
        [self layoutFinalView];
    } else {
        [self layoutView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a delegate set, mark ourselves as the next page now that we're
    // about to appear
    if (self.delegate) {
        [self.delegate setNextPage:self];
    }
    
    // if we have a video URL, start playing
    if (_videoURL) {
        [self.moviePlayerController play];
    }
    
    // call our view will appear block
    if (self.viewWillAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillAppearBlock();
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if we have a delegate set, mark ourselves as the current page now that
    // we've appeared
    if (self.delegate) {
        [self.delegate setCurrentPage:self];
    }
    
    // call our view did appear block
    if (self.viewDidAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidAppearBlock();
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // call our view will disappear block
    if (self.viewWillDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillDisappearBlock();
        });
    }

    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying && self.stopMoviePlayerWhenDisappear) {
        [self.moviePlayerController stop];
    }
}

- (void)handleAppEnteredForeground {
    // If the movie player is paused, as it does by default when backgrounded, start
    // playing again.
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePaused) {
        [self.moviePlayerController play];
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // call our view did disappear block
    if (self.viewDidDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidDisappearBlock();
        });
    }
}

- (void)setButtonActionHandler:(action_callback)actionBlock {
    _buttonActionHandler = actionBlock ?: ^(OnboardingViewController *controller){};
}

- (void)setSecondaryButtonActionHandler:(action_callback)secondaryActionBlock {
    _secondaryButtonActionHandler = secondaryActionBlock ?: ^(OnboardingViewController *controller){};
}

- (void)constructView {
    self.view.backgroundColor = [UIColor clearColor];
    
    _logoImageView = [self newLogoImageView];
    _imageView = [self newImageView];
    _mainTextLabel = [self newMainTextLabel];
    _subTextLabel = [self newSubTextLabel];
    _bodyTextLabel = [self newBodyTextLabel];
    _actionButton = [self newActionButton];
    _secondaryButton = [self newSecondActionButton];
    _attributedLabel = [self newAttributedLabel];
    // otherwise send the video view to the back if we have one
    if (_videoURL) {
        self.moviePlayerController.contentURL = _videoURL;
        self.moviePlayerController.view.frame = self.view.frame;
        self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
        
        [self.view addSubview:self.moviePlayerController.view];
        [self.view sendSubviewToBack:self.moviePlayerController.view];
    }
}

- (void)layoutInitialView {
    [self.view addSubviews:@[_logoImageView, _mainTextLabel, _bodyTextLabel]];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
    }];
    
    [_bodyTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-67);
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
    
    [_mainTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bodyTextLabel.mas_top).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
}

- (void)layoutView {
    [self.view addSubviews:@[_imageView, _mainTextLabel, _bodyTextLabel]];
    
    [_bodyTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-67);
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
    
    [_mainTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bodyTextLabel.mas_top).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(UIEdgeInsetsZero);
    }];
    
    [self.view sendSubviewToBack:_imageView];
}

- (void)layoutFinalView {
    [self.view addSubviews:@[_imageView, _logoImageView, _subTextLabel, _bodyTextLabel, _actionButton, _secondaryButton, _attributedLabel]];
    
    [_secondaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SV(_logoImageView).centerX);
        make.bottom.equalTo(SV(_logoImageView).centerY).insets(kTHLEdgeInsetsSuperHigh());
        make.size.mas_equalTo(CGSizeMake1(75.0f));
    }];
    
    [_subTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SV(_logoImageView).centerX);
        make.top.equalTo(SV(_logoImageView).centerY).insets(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(UIEdgeInsetsZero);
    }];
    
    [_actionButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_attributedLabel.mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.equalTo(SV(_actionButton).centerX);
        make.height.equalTo(58);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_attributedLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-35);
        make.centerX.equalTo(SV(_attributedLabel).centerX);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.view sendSubviewToBack:_imageView];
}

#pragma mark - Constructors
- (UIImageView *)newLogoImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];;
    return imageView;
}

- (UILabel *)newMainTextLabel {
    UILabel *mainTextLabel = [UILabel new];
    mainTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    mainTextLabel.text = _titleText;
    mainTextLabel.textColor = kTHLNUIPrimaryFontColor;
    mainTextLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:28];
    mainTextLabel.numberOfLines = 0;
    mainTextLabel.textAlignment = NSTextAlignmentLeft;
    [mainTextLabel sizeToFit];
    return mainTextLabel;
}

- (UILabel *)newSubTextLabel {
    UILabel *subTextLabel = [UILabel new];
    subTextLabel.text = _subtitleText;
    subTextLabel.textColor = kTHLNUIGrayFontColor;
    subTextLabel.font = [UIFont fontWithName:@"Raleway-Light" size:24];
    subTextLabel.numberOfLines = 0;
    subTextLabel.adjustsFontSizeToFitWidth = YES;
    subTextLabel.minimumScaleFactor = 0.5;
    subTextLabel.textAlignment = NSTextAlignmentCenter;
    [subTextLabel sizeToFit];
    return subTextLabel;
}

- (UILabel *)newBodyTextLabel {
    UILabel *bodyTextLabel = [UILabel new];
    bodyTextLabel.text = _body;
    bodyTextLabel.textColor = kTHLNUIGrayFontColor;
    bodyTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    bodyTextLabel.numberOfLines = 6;
    bodyTextLabel.adjustsFontSizeToFitWidth = YES;
    bodyTextLabel.minimumScaleFactor = 0.5;
    
    bodyTextLabel.textAlignment = NSTextAlignmentLeft;
    [bodyTextLabel sizeToFit];
    return bodyTextLabel;
}

- (THLActionButton *)newActionButton {
    THLActionButton *actionButton = [[THLActionButton alloc] initWithInverseStyle];
    [actionButton setTitle:@"Login with Facebook"];
    [actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    return actionButton;
}

- (UIButton *)newSecondActionButton {
    UIButton *secondButton = [UIButton new];
    secondButton.tintColor = [UIColor clearColor];
    [secondButton setTitle:@"Skip" forState:UIControlStateNormal];
    [secondButton setTitleColor:kTHLNUIGrayFontColor forState:UIControlStateNormal];
    secondButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:16];
    [secondButton addTarget:self action:@selector(handleSecondaryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    return secondButton;
}

- (TTTAttributedLabel *)newAttributedLabel {
    TTTAttributedLabel *tttLabel = [TTTAttributedLabel new];
    tttLabel.textColor = kTHLNUIGrayFontColor;
    tttLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    tttLabel.numberOfLines = 0;
    tttLabel.adjustsFontSizeToFitWidth = YES;
    tttLabel.minimumScaleFactor = 0.5;
    tttLabel.linkAttributes = @{NSForegroundColorAttributeName: kTHLNUIGrayFontColor,
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    tttLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    tttLabel.textAlignment = NSTextAlignmentCenter;
    NSString *labelText = @"By signing up, you agree to our Privacy Policy and Terms & Conditions";
    tttLabel.text = labelText;
    NSRange privacy = [labelText rangeOfString:@"Privacy Policy"];
    NSRange terms = [labelText rangeOfString:@"Terms & Conditions"];
    [tttLabel addLinkToURL:[NSURL URLWithString:@"action://show-privacy"] withRange:privacy];
    [tttLabel addLinkToURL:[NSURL URLWithString:@"action://show-terms"] withRange:terms];
    tttLabel.delegate = self;
    return tttLabel;
}

#pragma mark - Transition alpha

- (void)updateAlphas:(CGFloat)newAlpha {
    _imageView.alpha = newAlpha;
    _mainTextLabel.alpha = newAlpha;
    _subTextLabel.alpha = newAlpha;
    _bodyTextLabel.alpha = newAlpha;
    _actionButton.alpha = newAlpha;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-privacy"]) {
            THLInformationViewController *infoVC = [THLInformationViewController new];
            UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:infoVC];
            [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
            infoVC.displayText = [THLResourceManager privacyPolicyText];
            infoVC.title = @"Privacy Policy";
        } else if ([[url host] hasPrefix:@"show-terms"]) {
            THLInformationViewController *infoVC = [THLInformationViewController new];
            UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:infoVC];
            [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
            infoVC.displayText = [THLResourceManager termsOfUseText];
            infoVC.title = @"Terms Of Use";
        }
    } else {
        /* deal with http links here */
    }
}

#pragma mark - action button callback

- (void)handleButtonPressed {
    // if we want to navigate to the next view controller, tell our delegate
    // to handle it
    if (self.movesToNextViewController) {
        [self.delegate moveNextPage];
    }
    
    // call the provided action handler
    if (_buttonActionHandler) {
        _buttonActionHandler(self.delegate);
    }
}

- (void)handleSecondaryButtonPressed {
    // if we want to navigate to the next view controller, tell our delegate
    // to handle it
    if (self.movesToNextViewController) {
        [self.delegate moveNextPage];
    }
    
    // call the provided action handler
    if (_secondaryButtonActionHandler) {
        _secondaryButtonActionHandler(self.delegate);
    }
}

@end