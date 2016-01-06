//
//  THLDashboardTicketCell.m
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardTicketCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"
#import "THLEventTicketVenueView.h"
#import "THLEventTicketPromotionView.h"

@interface THLDashboardTicketCell()
@property (nonatomic, strong) THLEventTicketVenueView *venueView;
@property (nonatomic, strong) THLEventTicketPromotionView *promotionView;

@end

@implementation THLDashboardTicketCell
@synthesize locationImageURL;
@synthesize promotionMessage;
@synthesize hostImageURL;
@synthesize hostName;
@synthesize eventName;
@synthesize eventDate;
@synthesize locationName;
@synthesize guestlistReviewStatus;
@synthesize guestlistReviewStatusTitle;

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
}

- (void)layoutView {
    self.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    
    [self addSubviews:@[_venueView,
                        _promotionView]];
    WEAKSELF();

    [_venueView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(SV(WSELF.venueView)).sizeOffset(CGSizeMake(100, -160));
    }];
    
    [_promotionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF venueView].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    RAC(self.venueView, locationImageURL) = RACObserve(self, locationImageURL);
    RAC(self.venueView, locationName, @"") = RACObserve(self, locationName);
    RAC(self.promotionView, guestlistReviewStatus) = RACObserve(self, guestlistReviewStatus);
    RAC(self.promotionView, guestlistReviewStatusTitle, @"") = RACObserve(self, guestlistReviewStatusTitle);
    
    RAC(self.promotionView, promotionMessage, @"") = RACObserve(self, promotionMessage);
    RAC(self.promotionView, eventTime, @"") = RACObserve(self, eventDate);
    RAC(self.promotionView, hostImageURL) = RACObserve(self, hostImageURL);
    RAC(self.promotionView, hostName, @"") = RACObserve(self, hostName);
    
//    RAC(self.actionButton, rac_command) = RACObserve(self, actionButtonCommand);
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

//- (THLActionBarButton *)newActionButton {
//    THLActionBarButton *button = [[THLActionBarButton alloc] initWithFrame:CGRectZero];
//    button.backgroundColor = [button tealColor];
//    [button setTitle:@"VIEW EVENT" animateChanges:NO];
//    return button;
//}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
