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

static NSString * const kDefaultOnboardingFont = @"Helvetica-Light";

#define DEFAULT_TEXT_COLOR [UIColor whiteColor];

static CGFloat const kContentWidthMultiplier = 0.9;
static CGFloat const kDefaultRightSideBodyPadding = 67;

//static CGFloat const kDefaultImageViewSize = 100;
static CGFloat const kDefaultTopPadding = 60;
static CGFloat const kDefaultUnderIconPadding = 30;
static CGFloat const kDefaultUnderTitlePadding = 30;
static CGFloat const kDefaultUnderSubtitlePadding = 30;
static CGFloat const kDefaultBottomPadding = 0;
static CGFloat const kDefaultUnderPageControlPadding = 0;
static CGFloat const kDefaultTitleFontSize = 38;
static CGFloat const kDefaultBodyFontSize = 28;
static CGFloat const kDefaultButtonFontSize = 24;

static CGFloat const kActionButtonHeight = 60;
static CGFloat const kMainPageControlHeight = 35;

@interface OnboardingContentViewController ()

@end

@implementation OnboardingContentViewController

+ (instancetype)contentWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action secondaryButtonText:(NSString *)secondaryButtonText secondaryAction:(dispatch_block_t)secondaryAction {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title subtitle:subtitle body:body image:image buttonText:buttonText action:action secondaryButtonText:secondaryButtonText secondaryAction:secondaryAction];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action secondaryButtonText:(NSString *)secondaryButtonText secondaryAction:(dispatch_block_t)secondaryAction {
    return [self initWithTitle:title
                      subtitle:subtitle
                          body:body
                         image:image
                    buttonText:buttonText
                   actionBlock:^(OnboardingViewController *onboardController) {
                       if(action) action();
                   }
           secondaryButtonText:secondaryButtonText
          secondaryActionBlock:^(OnboardingViewController *onboardController) {
              if(secondaryAction) secondaryAction();
          }];
}

+ (instancetype)contentWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock secondaryButtonText:(NSString *)secondaryButtonText secondaryActionBlock:(action_callback)secondaryActionBlock {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title subtitle:subtitle body:body image:image buttonText:buttonText actionBlock:actionBlock secondaryButtonText:secondaryButtonText secondaryActionBlock:secondaryActionBlock];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock secondaryButtonText:(NSString *)secondaryButtonText secondaryActionBlock:(action_callback)secondaryActionBlock {
    self = [super init];
    
    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _titleText = title;
    _subtitleText = subtitle;
    _body = body;
    _image = image;
    _buttonText = buttonText;
    _secondaryButtonText = secondaryButtonText;
    
    self.buttonActionHandler = actionBlock;
    self.secondaryButtonActionHandler = secondaryActionBlock;

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
    
    // default title properties
    self.titleFontName = kDefaultOnboardingFont;
    self.titleFontSize = kDefaultTitleFontSize;
    
    // default subtitle properties
    self.subtitleFontName = kDefaultOnboardingFont;
    self.subtitleFontSize = kDefaultTitleFontSize;
    
    // default body properties
    self.bodyFontName = kDefaultOnboardingFont;
    self.bodyFontSize = kDefaultBodyFontSize;
    
    // default button properties
    self.buttonFontName = kDefaultOnboardingFont;
    self.buttonFontSize = kDefaultButtonFontSize;
    
    // default padding values
    self.topPadding = kDefaultTopPadding;
    self.underIconPadding = kDefaultUnderIconPadding;
    self.underTitlePadding = kDefaultUnderTitlePadding;
    self.underSubtitlePadding = kDefaultUnderSubtitlePadding;
    self.bottomPadding = kDefaultBottomPadding;
    self.underPageControlPadding = kDefaultUnderPageControlPadding;
    
    // default colors
    self.titleTextColor = DEFAULT_TEXT_COLOR;
    self.subtitleTextColor = DEFAULT_TEXT_COLOR;
    self.bodyTextColor = DEFAULT_TEXT_COLOR;
    self.buttonTextColor = DEFAULT_TEXT_COLOR;
    
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
    [self generateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a delegate set, mark ourselves as the next page now that we're
    // about to appear
    if (self.delegate) {
        [self.delegate setNextPage:self];
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

- (void)generateView {
    // we want our background to be clear so we can see through it to the image provided
    self.view.backgroundColor = [UIColor clearColor];
    
    // do some calculation for some common values we'll need, namely the width of the view,
    // the center of the width, and the content width we want to fill up, which is some
    // fraction of the view width we set in the multipler constant
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat horizontalCenter = viewWidth / 2;
    CGFloat contentWidth = viewWidth * kContentWidthMultiplier;
    
    // create the image view with the appropriate image, size, and center in on screen
    _imageView = [[UIImageView alloc] initWithImage:_image];
    [_imageView setFrame:CGRectMake(horizontalCenter - (self.iconWidth / 2), self.topPadding, self.iconWidth, self.iconHeight)];
    [self.view addSubview:_imageView];
    
    // create and configure the main text label sitting underneath the icon with the provided padding
    _mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.underIconPadding, contentWidth, 0)];
    _mainTextLabel.text = _titleText;
    _mainTextLabel.textColor = self.titleTextColor;
    _mainTextLabel.font = [UIFont fontWithName:self.titleFontName size:self.titleFontSize];
    _mainTextLabel.numberOfLines = 0;
    _mainTextLabel.textAlignment = NSTextAlignmentLeft;
    [_mainTextLabel sizeToFit];
//    _mainTextLabel.center = CGPointMake(horizontalCenter, _mainTextLabel.center.y);
    [self.view addSubview:_mainTextLabel];
    
    // create and configure the sub text label
    _subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_mainTextLabel.frame) + self.underTitlePadding, contentWidth, 0)];
    _subTextLabel.text = _subtitleText;
    _subTextLabel.textColor = self.subtitleTextColor;
    _subTextLabel.font = [UIFont fontWithName:self.subtitleFontName size:self.subtitleFontSize];
    _subTextLabel.numberOfLines = 0;
    _subTextLabel.textAlignment = NSTextAlignmentLeft;
    [_subTextLabel sizeToFit];
//    _subTextLabel.center = CGPointMake(horizontalCenter, _subTextLabel.center.y);
    [self.view addSubview:_subTextLabel];
    
    // create and configure the body text label

    _bodyTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_mainTextLabel.frame) + self.underSubtitlePadding, contentWidth - kDefaultRightSideBodyPadding, 0)];
    _bodyTextLabel.text = _body;
    _bodyTextLabel.textColor = self.bodyTextColor;
    _bodyTextLabel.font = [UIFont fontWithName:self.bodyFontName size:self.bodyFontSize];
    _bodyTextLabel.numberOfLines = 0;
    _bodyTextLabel.textAlignment = NSTextAlignmentLeft;
    [_bodyTextLabel sizeToFit];
//    _bodyTextLabel.center = CGPointMake(horizontalCenter, _bodyTextLabel.center.y);
    [self.view addSubview:_bodyTextLabel];

    // create the action button if we were given button text
    if (_buttonText) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - 2*kMainPageControlHeight - kActionButtonHeight - self.bottomPadding, contentWidth, kActionButtonHeight)];
        _actionButton.titleLabel.font = [UIFont fontWithName:self.buttonFontName size:16];
        _actionButton.backgroundColor = kTHLNUIBlueColor;
        [_actionButton setTitle:_buttonText forState:UIControlStateNormal];
        [_actionButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionButton];
    }
    
    // create the second button if we were given button text
    if (_secondaryButtonText) {
        _secondaryButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - 2*kMainPageControlHeight, contentWidth, kActionButtonHeight)];
        _secondaryButton.titleLabel.font = [UIFont fontWithName:self.buttonFontName size:16];
        [_secondaryButton setTitle:_secondaryButtonText forState:UIControlStateNormal];
        [_secondaryButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [_secondaryButton addTarget:self action:@selector(handleSecondaryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_secondaryButton];
    }
}


#pragma mark - Transition alpha

- (void)updateAlphas:(CGFloat)newAlpha {
    _imageView.alpha = newAlpha;
    _mainTextLabel.alpha = newAlpha;
    _subTextLabel.alpha = newAlpha;
    _bodyTextLabel.alpha = newAlpha;
    _actionButton.alpha = newAlpha;
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