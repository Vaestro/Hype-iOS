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


@interface THLPerkDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UITextView *infoText;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *itemCreditsLabel;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
// action bar
@end


@implementation THLPerkDetailViewController
@synthesize perkStoreItemImage;
@synthesize perkStoreItemDescription;
@synthesize perkStoreItemName = _perkStoreItemName;
@synthesize credits;
//@synthesize viewAppeared;
@synthesize dismissCommand = _dismissCommand;

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
    _itemNameLabel = [self newLabelwithConstant:kTHLNUIBoldTitle];
    _itemCreditsLabel = [self newLabelwithConstant:kTHLNUIBoldTitle];
    _infoText = [self newTextView];
    
    
}

- (void)layoutView {
    [self.view addSubviews:@[_scrollView, _imageView, _itemNameLabel, _itemCreditsLabel]];
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = [_perkStoreItemName uppercaseString];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.height.equalTo([WSELF view].height).multipliedBy(0.33);
    }];
    
    [_itemNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo([WSELF imageView]);
        
    }];
    
    [_itemCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo([WSELF imageView]);
    }];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF imageView].mas_bottom);
        make.right.left.bottom.insets(kTHLEdgeInsetsNone());
    }];
    
    [_scrollView.stackView addSubview:_infoText
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
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
    
    [[RACObserve(self, credits) map:^id(id creditsInt) {
        return [NSString stringWithFormat:@"%@ credits", creditsInt];
    }] subscribeNext:^(NSString *convertedCredit) {
        [WSELF.itemCreditsLabel setText:convertedCredit];
    }];

    
}

#pragma mark - Constructors

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

- (UILabel *)newLabelwithConstant:(NSString *)constant {
    UILabel *label = THLNUILabel(constant);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 3;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    [textView setEditable:NO];
    [textView setTextAlignment:NSTextAlignmentCenter];
    return textView;
}

@end

