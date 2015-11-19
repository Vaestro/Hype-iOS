//
//  THLEventTicketView.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventTicketView.h"
#import "THLAppearanceConstants.h"
#import "THLActionBarButton.h"
#import "THLPersonIconView.h"
#import "THLEventTicketVenueView.h"
#import "THLEventTicketPromotionView.h"

@interface THLEventTicketView()
@property (nonatomic, strong) THLEventTicketVenueView *venueView;
@property (nonatomic, strong) THLEventTicketPromotionView *promotionView;
@property (nonatomic, strong) THLActionBarButton *actionButton;

@end

@implementation THLEventTicketView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _venueView = [self newVenueView];
    _promotionView = [self newPromotionView];
    _actionButton = [self newActionButton];
}

- (void)layoutView {
    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;

    [self addSubviews:@[_venueView,
                             _promotionView,
                        _actionButton]];
    
    [_venueView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(125);
    }];
    
    [_promotionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_venueView.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_actionButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_promotionView.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    RAC(self.venueView, locationImageURL) = RACObserve(self, locationImageURL);
    RAC(self.venueView, locationName, @"") = RACObserve(self, locationName);
    RAC(self.promotionView, eventTime, @"") = RACObserve(self, eventDate);
    RAC(self.promotionView, hostImageURL) = RACObserve(self, hostImageURL);
    RAC(self.promotionView, hostName, @"") = RACObserve(self, hostName);
    
    RAC(self.actionButton, rac_command) = RACObserve(self, actionButtonCommand);
}

#pragma mark - Constructors

- (THLEventTicketVenueView *)newVenueView {
    THLEventTicketVenueView *venueView = [THLEventTicketVenueView new];
    return venueView;
}

- (THLEventTicketPromotionView *)newPromotionView {
    THLEventTicketPromotionView *promotionView = [THLEventTicketPromotionView new];
    return promotionView;
}

- (THLActionBarButton *)newActionButton {
    THLActionBarButton *button = [[THLActionBarButton alloc] initWithFrame:CGRectZero];
    button.backgroundColor = [button tealColor];
    [button setTitle:@"VIEW EVENT" animateChanges:NO];
    return button;
}

@end
