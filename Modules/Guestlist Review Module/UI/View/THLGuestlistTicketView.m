//
//  THLGuestlistTicketView.m
//  HypeUp
//
//  Created by Edgar Li on 2/28/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLGuestlistTicketView.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"

@interface THLGuestlistTicketView()

@property (nonatomic, strong) THLActionButton *viewPartyButton;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UIButton *eventDetailsButton;
@property (nonatomic, strong) UILabel *ticketInstructionLabel;
@property (nonatomic, strong) UILabel *listNumberLabel;
@property (nonatomic, strong) UILabel *venueNameLabel;
@property (nonatomic, strong) UILabel *eventDateLabel;
@property (nonatomic, strong) UILabel *arrivalMessageLabel;
@end

@implementation THLGuestlistTicketView
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    _ticketInstructionLabel = [self newTicketInstructionLabel];
    _listNumberLabel = [self newListNumberLabel];
    _dismissButton = [self newDismissButton];
    _eventDetailsButton = [self newEventDetailsButton];
    _venueNameLabel = [self newVenueNameLabel];
    _eventDateLabel = [self newEventDateLabel];
    _arrivalMessageLabel = [self newArrivalMessageLabel];
    _viewPartyButton = [self newViewPartyButton];
}

- (void)layoutView {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = @"TICKET";
    
    UIView *ticketBox = [UIView new];
    [ticketBox.layer setBorderWidth:3.0];
    [ticketBox.layer setCornerRadius:2.0];
    [ticketBox.layer setBorderColor:[[UIColor colorWithRed:0.773 green:0.702 blue:0.345 alpha:1] CGColor]];
    
    [self.view addSubviews:@[_ticketInstructionLabel, ticketBox, _viewPartyButton]];
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
    
    [_viewPartyButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
    [ticketBox addSubviews:@[_listNumberLabel, _venueNameLabel, _eventDateLabel, _arrivalMessageLabel]];

    
    [_listNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(SCREEN_HEIGHT*0.25);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF listNumberLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
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
}

- (void)bindView {
    RAC(self, dismissButton.rac_command) = RACObserve(self, dismissCommand);
    RAC(self, viewPartyButton.rac_command) = RACObserve(self, viewPartyCommand);
    RAC(self, eventDetailsButton.rac_command) = RACObserve(self, viewEventDetailsCommand);

    RAC(self, listNumberLabel.text) = RACObserve(self, listNumber);
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (UIButton *)newEventDetailsButton {
    UIButton *button = [UIButton new];
    return button;
}

- (THLActionButton *)newViewPartyButton {
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button
     setTitle:@"View Party"];

    return button;
}


@end
