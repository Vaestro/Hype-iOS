//
//  THLDashboardViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardViewController.h"
#import "THLAppearanceConstants.h"
#import "ORStackScrollView.h"
#import "THLEventTicketView.h"

@interface THLDashboardViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *acceptedSectionLabel;
@property (nonatomic, strong) THLEventTicketView *eventTicketView;
@end

@implementation THLDashboardViewController
@synthesize locationImageURL;
@synthesize hostImageURL;
@synthesize hostName;
@synthesize eventName;
@synthesize eventDate;
@synthesize locationName;
@synthesize contactHostCommand;
@synthesize actionButtonCommand;
@synthesize viewAppeared;

#pragma mark VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)constructView {
    _scrollView = [self newScrollView];
    _acceptedSectionLabel = [self newAcceptedSectionLabel];
    _eventTicketView = [self newEventTicketView];
}

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    [self.view addSubviews:@[_scrollView]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.top.bottom.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_scrollView.stackView addSubview:_acceptedSectionLabel
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [_scrollView.stackView addSubview:_eventTicketView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
}

- (void)bindView {
    RAC(self.eventTicketView, locationImageURL) = RACObserve(self, locationImageURL);
    RAC(self.eventTicketView, locationName, @"") = RACObserve(self, locationName);
    RAC(self.eventTicketView, eventDate, @"") = RACObserve(self, eventDate);
    RAC(self.eventTicketView, hostImageURL) = RACObserve(self, hostImageURL);
    RAC(self.eventTicketView, hostName, @"") = RACObserve(self, hostName);
    
    RAC(self.eventTicketView, actionButtonCommand) = RACObserve(self, actionButtonCommand);
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (UILabel *)newAcceptedSectionLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.text = @"YOUR NEXT EVENT";
    label.alpha = 0.7;
    return label;
}

- (THLEventTicketView *)newEventTicketView {
    THLEventTicketView *eventTicketView = [THLEventTicketView new];
    return eventTicketView;
}
@end
