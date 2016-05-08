//
//  THLGuestlistTicketView.m
//  Hype
//
//  Created by Edgar Li on 2/28/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLGuestlistTicketView.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"
#import "THLAlertView.h"
#import "Intercom/intercom.h"

@interface THLGuestlistTicketView()

@property (nonatomic, strong) THLActionButton *viewPartyButton;
@property (nonatomic, strong) THLActionButton *contactConceirgeButton;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UIBarButtonItem *eventDetailsButton;
@property (nonatomic, strong) UILabel *ticketInstructionLabel;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *venueNameLabel;
@property (nonatomic, strong) UILabel *eventDateLabel;
@property (nonatomic, strong) UILabel *arrivalMessageLabel;
@end

@implementation THLGuestlistTicketView
- (void)showAlertView {
    THLAlertView *alertView = [THLAlertView new];
    [alertView setTitle:@"Success"];
    [alertView setMessage:@"Please arrive on time and show your ticket at the door for entrance. Your ticket + guestlist can always be found in the 'My Events' tab. If you have any questions, you can contact the concierge anytime in your messages"];
    
    [self.navigationController.view addSubview:alertView];
    [alertView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    [self.navigationController.view bringSubviewToFront:alertView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    _ticketInstructionLabel = [self newTicketInstructionLabel];
    _dismissButton = [self newDismissButton];
    _eventDetailsButton = [self newEventDetailsButton];
    _venueNameLabel = [self newVenueNameLabel];
    _eventDateLabel = [self newEventDateLabel];
    _arrivalMessageLabel = [self newArrivalMessageLabel];
    _viewPartyButton = [self newViewPartyButton];
    _contactConceirgeButton = [self newContactConciergeButton];
    _qrCodeImageView = [self newQRCodeImageView];
    
}

- (void)layoutView {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.rightBarButtonItem = _eventDetailsButton;
    self.navigationItem.title = @"TICKET";
    
    UIView *ticketBox = [UIView new];
    [ticketBox.layer setBorderWidth:3.0];
    [ticketBox.layer setCornerRadius:2.0];
    [ticketBox.layer setBorderColor:[[UIColor colorWithRed:0.773 green:0.702 blue:0.345 alpha:1] CGColor]];
    
    [self.view addSubviews:@[_ticketInstructionLabel, ticketBox, _viewPartyButton, _contactConceirgeButton]];
    WEAKSELF();

    [_ticketInstructionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(75);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [ticketBox makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF ticketInstructionLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.equalTo(kTHLEdgeInsetsInsanelyHigh());
//        make.bottom.equalTo([WSELF viewPartyButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_contactConceirgeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
    [_viewPartyButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.contactConceirgeButton.mas_top).insets(kTHLEdgeInsetsHigh());
        make.left.right.equalTo(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
    [ticketBox addSubviews:@[_qrCodeImageView, _venueNameLabel, _eventDateLabel, _arrivalMessageLabel]];

    
    [_qrCodeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(SCREEN_HEIGHT*0.25);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF qrCodeImageView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF eventDateLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());

        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_eventDateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF arrivalMessageLabel].mas_top).insets(kTHLEdgeInsetsLow());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_arrivalMessageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    if (_showInstruction) {
        [self showAlertView];
        _showInstruction = FALSE;
    }
}

- (void)bindView {
    RAC(self, dismissButton.rac_command) = RACObserve(self, dismissCommand);
    RAC(self, viewPartyButton.rac_command) = RACObserve(self, viewPartyCommand);
    RAC(self, eventDetailsButton.rac_command) = RACObserve(self, viewEventDetailsCommand);
    
    WEAKSELF();
    RACSignal *imageURLSignal = [RACObserve(self, qrCode) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.qrCodeImageView sd_setImageWithURL:url];
    }];

    RAC(self, venueNameLabel.text) = RACObserve(self, venueName);
    RAC(self, eventDateLabel.text) = RACObserve(self, eventDate);
    RAC(self, arrivalMessageLabel.text  ) = RACObserve(self, arrivalMessage);

}


#pragma mark - Constructors
- (UILabel *)newTicketInstructionLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.text = @"PRESENT TICKET TO DOORMAN";
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newListNumberLabel {
    UILabel *label = [UILabel new];
    label.text = @"1";
    [label setFont:[UIFont systemFontOfSize:200 weight:0.25]];
    label.textColor = kTHLNUIAccentColor;
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

- (UILabel *)newVenueNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newEventDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newArrivalMessageLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIBarButtonItem *)newDismissButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (UIBarButtonItem *)newEventDetailsButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Detail Disclosure Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}


- (UIImageView *)newQRCodeImageView
{
    UIImageView *view = [UIImageView new];
    view.contentMode = YES;
    return view;
}



- (THLActionButton *)newViewPartyButton {
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button
     setTitle:@"View Party"];

    return button;
}

- (THLActionButton *)newContactConciergeButton {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"Contact Concierge"];
    [button addTarget:self action:@selector(openUpChat) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)openUpChat
{
    [Intercom presentMessageComposer];
}

@end
