//
//  THLHostDashboardTicketCell.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardTicketCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"

@interface THLHostDashboardTicketCell()
//@property (nonatomic, strong) THLEventTicketVenueView *venueView;
//@property (nonatomic, strong) THLEventTicketPromotionView *promotionView;
//@property (nonatomic, strong) THLActionBarButton *actionButton;

@end
//
@implementation THLHostDashboardTicketCell
//@synthesize locationImageURL;
//@synthesize eventName;
//@synthesize eventDate;
//@synthesize locationName;
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self constructView];
//        [self layoutView];
//        [self bindView];
//    }
//    return self;
//}
//
//- (void)constructView {
//    _venueView = [self newVenueView];
//    _promotionView = [self newPromotionView];
//}
//
//- (void)layoutView {
//    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
//    self.clipsToBounds = YES;
//    self.layer.cornerRadius = 5;
//    
//    [self addSubviews:@[_venueView,
//                        _promotionView]];
//    WEAKSELF();
//    
//    [_venueView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.insets(kTHLEdgeInsetsNone());
//        make.height.equalTo(SV(WSELF.venueView)).sizeOffset(CGSizeMake(100, -160));
//    }];
//    
//    [_promotionView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([WSELF venueView].mas_bottom).insets(kTHLEdgeInsetsHigh());
//        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
//        make.bottom.insets(kTHLEdgeInsetsHigh());
//        //        make.height.equalTo(SV(WSELF.venueView)).sizeOffset(CGSizeMake(100, -90));
//    }];
//    
//    //    [_actionButton makeConstraints:^(MASConstraintMaker *make) {
//    //        make.top.equalTo([WSELF promotionView].mas_bottom).insets(kTHLEdgeInsetsHigh());
//    //        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
//    //    }];
//}
//
//- (void)bindView {
//    RAC(self.venueView, locationImageURL) = RACObserve(self, locationImageURL);
//    RAC(self.venueView, locationName, @"") = RACObserve(self, locationName);
//    RAC(self.promotionView, eventTime, @"") = RACObserve(self, eventDate);
//    
//    //    RAC(self.actionButton, rac_command) = RACObserve(self, actionButtonCommand);
//}
//
//#pragma mark - Constructors
//
//- (THLEventTicketVenueView *)newVenueView {
//    THLEventTicketVenueView *venueView = [THLEventTicketVenueView new];
//    return venueView;
//}
//
//- (THLEventTicketPromotionView *)newPromotionView {
//    THLEventTicketPromotionView *promotionView = [THLEventTicketPromotionView new];
//    return promotionView;
//}

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