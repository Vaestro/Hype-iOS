//
//  THLEventDetailViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailViewController.h"
#import "ORStackScrollView.h"

//Subviews
#import "THLEventDetailsLocationInfoView.h"
#import "THLEventDetailsMapView.h"
#import "THLEventDetailsPromotionInfoView.h"
#import "THLActionBarButton.h"

#import "THLAppearanceConstants.h"
#import "THLPromotionInfoView.h"

@interface THLEventDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
@property (nonatomic, strong) THLActionBarButton *bottomBar;
@property (nonatomic, strong) THLPromotionInfoView *ratioInfoLabel;
@property (nonatomic, strong) THLPromotionInfoView *coverInfoLabel;
@property (nonatomic) BOOL showPromotionInfoView;
@end


@implementation THLEventDetailViewController
@synthesize locationImageURL;
@synthesize promoImageURL;
@synthesize eventName;
@synthesize eventDate;
@synthesize promoInfo;
@synthesize ratioInfo;
@synthesize coverInfo;
@synthesize locationName;
@synthesize locationInfo;
@synthesize locationAddress;
@synthesize dismissCommand;
@synthesize locationPlacemark;
@synthesize actionBarButtonStatus;
@synthesize actionBarButtonCommand;
@synthesize viewAppeared;

#pragma mark VC Lifecycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewAppeared = TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = FALSE;
}

- (void)constructView {
    _scrollView = [self newScrollView];
    _promotionInfoView = [self newPromotionInfoView];
    _eventNameLabel = [self newEventNameLabel];
    _dateLabel = [self newDateLabel];
    _ratioInfoLabel = [self newRatioInfoLabel];
    _coverInfoLabel = [self newCoverInfoLabel];
    _bottomBar = [self newBottomBar];
}

- (void)showDetailsView:(UIView *)detailView {
    [self.parentViewController.view addSubview:detailView];
    [detailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:detailView];
}

- (void)hideDetailsView:(UIView *)detailView {
    [detailView removeFromSuperview];
}

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    [self.view addSubviews:@[_scrollView, _bottomBar]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.top.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_scrollView.stackView addSubview:_eventNameLabel
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [_scrollView.stackView addSubview:_dateLabel
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [_scrollView.stackView addSubview:_ratioInfoLabel
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [_scrollView.stackView addSubview:_coverInfoLabel
                  withPrecedingMargin:2*kTHLPaddingNone()
                           sideMargin:kTHLPaddingNone()];
    
    [_scrollView.stackView addSubview:_promotionInfoView
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    

    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(_scrollView.mas_bottom);
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.eventNameLabel, text, @"") = RACObserve(self, eventName);
    RAC(self.dateLabel, text, @"") = RACObserve(self, eventDate);
    RAC(self.ratioInfoLabel, infoText, @"") = RACObserve(self, ratioInfo);
    RAC(self.coverInfoLabel, infoText, @"") = RACObserve(self, coverInfo);
    
    RAC(self.promotionInfoView, promotionInfo) = RACObserve(self, promoInfo);
    RAC(self.promotionInfoView, promoImageURL) = RACObserve(self, promoImageURL);
    
    [RACObserve(WSELF, actionBarButtonStatus) subscribeNext:^(id _) {
        [WSELF updateBottomBar];
    }];
    
    RAC(self.bottomBar, rac_command) = RACObserve(self, actionBarButtonCommand);
}

- (void)updateBottomBar {
    WEAKSELF();
    switch (actionBarButtonStatus) {
        case THLGuestlistStatusPendingInvite:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIPendingColor;
            break;
            
        case THLGuestlistStatusPendingHost:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW PENDING GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIPendingColor;
            break;
            
        case THLGuestlistStatusAccepted:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW YOUR GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIAccentColor;
            break;
            
        case THLGuestlistStatusDeclined:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"CREATE A GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIActionColor;
            break;
        
        case THLGuestlistStatusUnavailable:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"UNAVAILABLE", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIPendingColor;
            break;
            
        default:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"CREATE A GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIActionColor;
            break;
    }
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (THLEventDetailsPromotionInfoView *)newPromotionInfoView {
    THLEventDetailsPromotionInfoView *promoInfoView = [THLEventDetailsPromotionInfoView new];
    promoInfoView.title = NSLocalizedString(@"EVENT DETAILS", nil);
    promoInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    promoInfoView.dividerColor = [UIColor whiteColor];
    return promoInfoView;
}

- (THLActionBarButton *)newBottomBar {
    THLActionBarButton *bottomBar = [THLActionBarButton new];
//    [bottomBar.morphingLabel setTextWithoutMorphing:NSLocalizedString(actionBarButtonStatus, nil)];
    return bottomBar;
}

- (THLPromotionInfoView *)newRatioInfoLabel {
    THLPromotionInfoView *ratioInfoLabel = [THLPromotionInfoView new];
    ratioInfoLabel.labelText = @"Ratio";
    return ratioInfoLabel;
}

- (THLPromotionInfoView *)newCoverInfoLabel {
    THLPromotionInfoView *coverInfoLabel = [THLPromotionInfoView new];
    coverInfoLabel.labelText = @"Venue Cover";
    return coverInfoLabel;
}

- (UILabel *)newEventNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.alpha = 0.67;
    return label;
}


//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
