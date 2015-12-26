//
//  THLPerkDetailViewController.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailViewController.h"
#import "ORStackScrollView.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "THLActionBarButton.h"
#import "THLRedeemPerkView.h"


@interface THLPerkDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UITextView *infoText;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *itemCreditsLabel;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) THLActionBarButton *barButton;
@property (nonatomic, strong) THLRedeemPerkView *redeemPerkView;
// action bar
@end


@implementation THLPerkDetailViewController
@synthesize perkStoreItemImage;
@synthesize perkStoreItemDescription;
@synthesize perkStoreItemName = _perkStoreItemName;
@synthesize credits;
//@synthesize viewAppeared;
@synthesize dismissCommand = _dismissCommand;
@synthesize purchaseCommand = _purchaseCommand;

#pragma mark VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self configureBindings];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)constructView {
    
    _scrollView = [self newScrollView];
    _imageView = [self newImageView];
    _dismissButton = [self newDismissButton];
    _itemNameLabel = [self newItemNameLabel];
    _itemCreditsLabel = [self newCreditsNameLabel];
    _infoText = [self newTextView];
    _barButton = [self newBarButton];
}

- (void)showRedeemPerkView:(UIView *)redeemPerkView {
    [self.parentViewController.view addSubview:redeemPerkView];
    [redeemPerkView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:redeemPerkView];
}

- (void)hideRedeemPerkView:(UIView *)redeemPerkView {
    [redeemPerkView removeFromSuperview];
}


- (void)layoutView {
    [self.view addSubviews:@[_scrollView, _imageView, _itemNameLabel, _itemCreditsLabel, _barButton]];
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = [_perkStoreItemName uppercaseString];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.height.equalTo([WSELF view].height).multipliedBy(0.33);
    }];
    
    [_itemNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo([WSELF imageView]).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_itemCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF itemNameLabel].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.right.equalTo([WSELF imageView]).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF imageView].mas_bottom);
        make.right.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_scrollView.stackView addSubview:_infoText
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];
    
    [_barButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF scrollView].mas_bottom);
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    
}

- (void)configureBindings {
    WEAKSELF();
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
    
    [[RACObserve(self, perkStoreItemImage) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
    
    RAC(self.itemNameLabel, text) = RACObserve(self, perkStoreItemName);
    
    RAC(self.infoText, text) = RACObserve(self, perkStoreItemDescription);
    
    RAC(self.barButton, rac_command) = RACObserve(self, purchaseCommand);
    
    [[RACObserve(self, credits) map:^id(id creditsInt) {
        return [NSString stringWithFormat:@"$%@", creditsInt];
    }] subscribeNext:^(NSString *convertedCredit) {
        [WSELF.itemCreditsLabel setText:convertedCredit];
    }];
}

#pragma mark - Constructors

- (THLActionBarButton *)newBarButton {
    THLActionBarButton *barButton = [THLActionBarButton new];
    barButton.backgroundColor = kTHLNUIAccentColor;
    [barButton.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"REDEEM CREDITS", nil)];
    return barButton;
}

- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    scrollView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    return scrollView;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView dimView];
    return imageView;
}

- (UIBarButtonItem *)newDismissButton {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel X Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [barButtonItem setTintColor:[UIColor whiteColor]];
    return barButtonItem;
}

- (UILabel *)newItemNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 2;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UILabel *)newCreditsNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textColor = kTHLNUIGrayFontColor;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    [textView setEditable:NO];
    [textView setClipsToBounds:YES];
    [textView setTextAlignment:NSTextAlignmentLeft];
    return textView;
}

@end

