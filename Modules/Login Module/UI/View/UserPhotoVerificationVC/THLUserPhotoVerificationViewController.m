//
//  THLUserPhotoVerificationViewController.m
//  Hype
//
//  Created by Nik Cane on 27/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLUserPhotoVerificationViewController.h"
#import "THLActionBarButton.h"
#import "THLAppearanceConstants.h"
#import "OLFacebookImage.h"
#import "THLPersonIconView.h"
#import "THLUser.h"
#import "THLUserDataWorker.h"

@interface THLUserPhotoVerificationViewController() <OLFacebookImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) THLActionBarButton *submitButton;
@property (nonatomic, strong) UITapGestureRecognizer *photoTapRecognizer;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) OLFacebookImagePickerController *imagePicker;
@property (nonatomic, strong) NSURL *userImageURL;
@property (nonatomic, strong) THLPersonIconView *userImageView;
@property (nonatomic, assign) BOOL needHideSubmitButton;

@end

@implementation THLUserPhotoVerificationViewController


#pragma mark default Initialization

- (instancetype) init {
    if (self == [super init]){
        self.needHideSubmitButton = NO;
    }
    return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.needHideSubmitButton = NO;
    }
    return self;
}

#pragma mark - Initialization with Navigation Controller

- (instancetype) initForNavigationController {
    if (self == [super init]){
        [self configureBarButtons];
        self.needHideSubmitButton = YES;
    }
    return self;
}

- (void) configureBarButtons {
    self.navigationItem.leftBarButtonItem = [self newBackBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self newSaveBarButtonItem];
}


- (UIBarButtonItem *)newBackBarButtonItem {
    return [self createBarButtonWithTitle:@"Back"
                                 selector:@selector(handleCancelAction)];
}

- (UIBarButtonItem *)newSaveBarButtonItem {
    return [self createBarButtonWithTitle:@"Save"
                                 selector:@selector(updateUserPhoto)];
}

- (UIBarButtonItem *) createBarButtonWithTitle:(NSString *) title selector:(SEL) selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:selector];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
    
}


#pragma mark - Initialization as Modal View Controller

- (instancetype) initwithSubmitButton {
    if (self == [super init]){
        self.needHideSubmitButton = NO;
    }
    return self;
}

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    [self setDefaultPhoto];
}

- (void)constructView {
    _userImageView = [self newIconView];
    _photoTapRecognizer = [self tapGestureRecognizer];
    _descriptionLabel = [self newDescriptionLabel];
    _titleLabel = [self newTitleLabel];
    _submitButton = [self newSubmitButton];
    if (_needHideSubmitButton){
        _submitButton.alpha = 0.0;
    }
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    self.navigationItem.title = @"Check photo";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:kTHLNUIPrimaryFontColor,
       NSFontAttributeName:[UIFont fontWithName:@"Raleway-Regular" size:21]}];
    
    [self.view addSubviews:@[_userImageView,
                             _submitButton,
                             _descriptionLabel,
                             _titleLabel]];
    [_userImageView addGestureRecognizer:_photoTapRecognizer];
    
    WEAKSELF();
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = SCREEN_WIDTH * 0.50;
        make.height.mas_equalTo(width);
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(WSELF.submitButton.centerX);
        make.centerY.mas_equalTo(WSELF.view.centerX);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo([WSELF submitButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.66);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.66);
    }];
}

- (void) bindView {
    @weakify(self)
    [[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        filter:^BOOL(id value) {
          @strongify(self)
            return [self.userImageView.image isValid];}]
        subscribeNext:^(id x) {
              [self updateUserPhoto];
          }];
    RAC(self.userImageView, imageURL) = RACObserve(self, userImageURL);
}

#pragma mark - Photo processing

- (NSURL *) remoteUserImageURL {
    return [NSURL URLWithString:[THLUser currentUser].image.url];
}

- (void) setDefaultPhoto {
     _userImageView.imageURL = [self remoteUserImageURL];
}

- (void) updateUserPhoto {
    if (self.delegate != nil) {
        [self.delegate userPhotoVerificationView:self
                             userDidConfirmPhoto:self.userImageView.image];
    } else {
        [THLUserDataWorker addProfileImage:self.userImageView.image
                                   forUser:[THLUser currentUser]
                                  delegate:nil];
        [_renewImageDelegate reloadUserImageWithURL:self.userImageView.imageURL];
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

    }
}

#pragma mark - Constructors

- (THLPersonIconView *)newIconView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UITapGestureRecognizer *) tapGestureRecognizer{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callFacebookPicker:)];
    return tapRecognizer;
}

- (THLActionBarButton *)newSubmitButton {
    THLActionBarButton *button = [THLActionBarButton new];
    [button setTitle:@"Continue" forState:UIControlStateNormal];
    return button;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Choose an accurate picture of yourself by tapping on the screen so that the host can find you at the venue";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (UILabel *) newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = @"Profile Picture";
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (void) facebookUserImage:(UIImage *) image{
    _userImageView.image = image;
}

- (void) loadFacebookUserImageWithURL:(NSURL *) imageURL {
    _userImageView.imageURL = imageURL;
}

#pragma mark GestureRecognizer call Facebook picker

- (void) callFacebookPicker:(UITapGestureRecognizer *) recognizer{
    _imagePicker = [[OLFacebookImagePickerController alloc] init];
    _imagePicker.delegate = self;
    [self presentViewController:_imagePicker
                      animated:YES
                    completion:nil];
}

#pragma mark - OLFacebookImagePickerControllerDelegate methods

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    [self facebookPickerError:error];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray *)images {
    OLFacebookImage *userImage = images.firstObject;
    [self loadFacebookUserImageWithURL: userImage.thumbURL];
    [self loadFacebookUserImageWithURL: userImage.fullURL];
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) facebookImagePicker:(OLFacebookImagePickerController *)imagePicker shouldSelectImage:(OLFacebookImage *)image{
    return imagePicker.selected.count < 1;
}

- (void) facebookImagePickerFailToLoadImage:(NSError *)error {
    [self facebookPickerError:error];
}

- (void) facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didSelectImage:(OLFacebookImage *)image{
    
}

- (void) facebookPickerError:(NSError *) error {
    [[[UIAlertView alloc] initWithTitle:@"Oops"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark dismiss as UINavigationController

- (void)handleCancelAction {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
