//
//  THLEventTicketView.m
//  Hype
//
//  Created by Edgar Li on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventTicketViewController.h"
#import "THLAppearanceConstants.h"
#import <Parse/Parse.h>
#import "THLUser.h"

@interface THLEventTicketViewController()
@property (nonatomic, strong) UILabel *ticketInstructionLabel;
@property (nonatomic, strong) UILabel *ticketTypeLabel;

@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *venueNameLabel;
@property (nonatomic, strong) UILabel *eventDateLabel;
@property (nonatomic, strong) UILabel *arrivalMessageLabel;
@property (nonatomic, strong) PFObject *guestlistInvite;
@property (nonatomic, strong) UILabel *creditsMessageLabel;

@end

@implementation THLEventTicketViewController
#pragma mark -
#pragma mark UIView
- (id)initWithGuestlistInvite:(PFObject *)guestlistInvite {
    if (self = [super init]) {
        _guestlistInvite = guestlistInvite;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    WEAKSELF();
    
    [self.ticketTypeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.ticketInstructionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.ticketTypeLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.qrCodeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.ticketInstructionLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(SCREEN_HEIGHT*0.25);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];

    [self.venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF qrCodeImageView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
//    [self.creditsMessageLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([WSELF venueNameLabel].mas_bottom).insets(kTHLEdgeInsetsInsanelyHigh());
//        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
//    }];
    
//    [self.eventDateLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([WSELF venueNameLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
//        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
//    }];


    [self.arrivalMessageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];

}

#pragma mark -
#pragma mark Accessors

- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [UIImageView new];
        _qrCodeImageView.contentMode = YES;
        
        PFFile *imageFile =  _guestlistInvite[@"qrCode"];
        
        [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageFile.url]];

        [self.view addSubview:_qrCodeImageView];
    }
    return _qrCodeImageView;
}

- (UILabel *)ticketInstructionLabel {
    if (!_ticketInstructionLabel) {
        _ticketInstructionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _ticketInstructionLabel.adjustsFontSizeToFitWidth = YES;
        _ticketInstructionLabel.numberOfLines = 1;
        _ticketInstructionLabel.minimumScaleFactor = 0.5;
        _ticketInstructionLabel.textAlignment = NSTextAlignmentCenter;
        _ticketInstructionLabel.text = @"PRESENT TICKET TO DOORMAN";

        [self.view addSubview:_ticketInstructionLabel];
    }
    return _ticketInstructionLabel;
}

- (UILabel *)ticketTypeLabel {
    if (!_ticketTypeLabel) {
        _ticketTypeLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _ticketTypeLabel.adjustsFontSizeToFitWidth = YES;
        _ticketTypeLabel.numberOfLines = 1;
        _ticketTypeLabel.minimumScaleFactor = 0.5;
        _ticketTypeLabel.textAlignment = NSTextAlignmentCenter;
        NSString *ticketTypeText = _guestlistInvite[@"admissionDescription"];
        NSString *upperCasedText = [ticketTypeText uppercaseString];
        _ticketTypeLabel.text = upperCasedText;
        
        [self.view addSubview:_ticketTypeLabel];
    }
    return _ticketTypeLabel;
}

- (UILabel *)venueNameLabel {
    if (!_venueNameLabel) {
        _venueNameLabel = THLNUILabel(kTHLNUIRegularDetailTitle);
        _venueNameLabel.adjustsFontSizeToFitWidth = YES;
        _venueNameLabel.numberOfLines = 1;
        _venueNameLabel.minimumScaleFactor = 0.5;
        _venueNameLabel.textAlignment = NSTextAlignmentCenter;
        
        _venueNameLabel.text = [THLUser currentUser].fullName;
        [self.view addSubview:_venueNameLabel];
    }
    return _venueNameLabel;
}

- (UILabel *)eventDateLabel {
    if (!_eventDateLabel) {
        _eventDateLabel = THLNUILabel(kTHLNUIDetailTitle);
        _eventDateLabel.adjustsFontSizeToFitWidth = YES;
        _eventDateLabel.numberOfLines = 1;
        _eventDateLabel.minimumScaleFactor = 0.5;
        _eventDateLabel.textAlignment = NSTextAlignmentCenter;
        [_eventDateLabel setTextColor:kTHLNUIGrayFontColor];
        NSDate *date = (NSDate *)_guestlistInvite[@"Guestlist"][@"event"][@"date"];
        _eventDateLabel.text = date.thl_weekdayString;
        
        [self.view addSubview:_eventDateLabel];
    }
    return _eventDateLabel;
}

- (UILabel *)arrivalMessageLabel {
    if (!_arrivalMessageLabel) {
        _arrivalMessageLabel = THLNUILabel(kTHLNUIDetailTitle);
        _arrivalMessageLabel.adjustsFontSizeToFitWidth = YES;
        _arrivalMessageLabel.numberOfLines = 1;
        _arrivalMessageLabel.minimumScaleFactor = 0.5;
        _arrivalMessageLabel.textAlignment = NSTextAlignmentCenter;

        [_arrivalMessageLabel setTextColor:kTHLNUIGrayFontColor];
        NSDate *date = (NSDate *)_guestlistInvite[@"Guestlist"][@"event"][@"date"];
//        _arrivalMessageLabel.text = [NSString stringWithFormat:@"Please arrive by %@", date.thl_timeString];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Best time to arrive: "
                                                                                 attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", date.thl_timeString]
                                                                                 attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                              NSBackgroundColorAttributeName: [UIColor clearColor]}]];
        _arrivalMessageLabel.attributedText = attributedString;
        [self.view addSubview:_arrivalMessageLabel];
    }
    return _arrivalMessageLabel;
}

- (UILabel *)creditsMessageLabel {
    if (!_creditsMessageLabel) {
        _creditsMessageLabel = THLNUILabel(kTHLNUIDetailTitle);
        _creditsMessageLabel.adjustsFontSizeToFitWidth = YES;
        _creditsMessageLabel.numberOfLines = 2;
        _creditsMessageLabel.minimumScaleFactor = 0.5;
        _creditsMessageLabel.textAlignment = NSTextAlignmentCenter;
        
        [_creditsMessageLabel setTextColor:kTHLNUIGrayFontColor];
//        _creditsMessageLabel.text = [NSString stringWithFormat:@"Get your ticket scanned at the venue to receive your $%@.00 credits", _guestlistInvite[@"Guestlist"][@"event"][@"creditsPayout"]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Get your ticket scanned at the venue to receive your "
                                                                                 attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString
                                                                                             stringWithFormat:@"$%@.00 credits", _guestlistInvite[@"Guestlist"][@"event"][@"creditsPayout"]]
                                                                                 attributes:@{NSForegroundColorAttributeName: kTHLNUIAccentColor,
                                                                                              NSBackgroundColorAttributeName: [UIColor clearColor]}]];
        _creditsMessageLabel.attributedText = attributedString;
        [self.view addSubview:_creditsMessageLabel];
    }
    return _creditsMessageLabel;
}
@end
