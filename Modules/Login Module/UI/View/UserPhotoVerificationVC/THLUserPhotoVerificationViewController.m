//
//  THLUserPhotoVerificationViewController.m
//  HypeUp
//
//  Created by Nik Cane on 27/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLUserPhotoVerificationViewController.h"
#import "THLActionBarButton.h"
#import "THLAppearanceConstants.h"
#import "OLFacebookImage.h"

@interface THLUserPhotoVerificationViewController() <OLFacebookImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) THLActionBarButton *submitButton;
@property (nonatomic, strong) UITapGestureRecognizer *photoTapRecognizer;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) OLFacebookImagePickerController *imagePicker;

@end

@implementation THLUserPhotoVerificationViewController
@synthesize userImageView = _userImageView;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    _userImageView = [self newUserImage];
    _photoTapRecognizer = [self tapGestureRecognizer];
    _submitButton = [self newSubmitButton];
    _descriptionLabel = [self newDescriptionLabel];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    self.navigationItem.title = @"Check photo";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:kTHLNUIPrimaryFontColor,
       NSFontAttributeName:[UIFont fontWithName:@"Raleway-Regular" size:21]}];
    
    [self.view addSubviews:@[_userImageView,
                             _submitButton,
                             _descriptionLabel]];
    [self.view addGestureRecognizer:_photoTapRecognizer];
    
    WEAKSELF();
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = SCREEN_WIDTH * 0.80;
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

}

- (void) bindView {
    @weakify(self)
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self updateUserPhoto];
    }];
    RACSignal *imageUpdated = RACObserve(self.userImageView, image);
    [imageUpdated subscribeNext:^(UIImageView *imageView) {
        @strongify(self)
        if (imageView != nil) {
            [self makeImageRound: imageView];
        }
    }];
}

#pragma mark - Photo processing

- (BOOL) userPhotoValid {
    return _userImageView.image != nil;
}

- (void) updateUserPhoto {
    if ([self userPhotoValid]) {
        [self.delegate userPhotoVerificationView:self userDidConfirmPhoto:self.userImageView.image];
    }
}

- (void) makeImageRound:(UIImageView *) imageView {
//    imageView.layer.cornerRadius = imageView.frame.size.height / 2;
//    imageView.clipsToBounds = YES;
}

#pragma mark - Constructors

- (UIImageView *) newUserImage{
    UIImageView *imageView = [[UIImageView alloc] init];
    return imageView;
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
    label.text = @"Are your photo is completely describe your apperance? If you want to pass face control then tap on the screen to provide new photo from your FB profile.";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

- (void) facebookUserImage:(UIImage *) image{
    _userImageView.image = image;
}

- (void) loadFacebookUserImageWithURL:(NSURL *) imageURL {
    [self.userImageView sd_setImageWithURL:imageURL];
}

#pragma mark GestureRecognizer call Facebook picker

- (void) callFacebookPicker:(UITapGestureRecognizer *) recognizer{
    _imagePicker = [[OLFacebookImagePickerController alloc] init];
    _imagePicker.delegate = self;
    [self.delegate presentFacebookImagePicker:_imagePicker];
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

@end
