//
//  THLPurchaseDetailsView.h
//  Hype
//
//  Created by Edgar Li on 5/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"

@interface THLPurchaseDetailsView : THLTitledContentView
@property (nonatomic, strong) UILabel *purchaseTitleLabel;
@property (nonatomic, strong) UILabel *subtotalLabel;
@property (nonatomic, strong) UILabel *serviceChargeLabel;
@property (nonatomic, strong) UILabel *taxLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *serviceChargeDesciptionLabel;
@property (nonatomic, strong) UILabel *taxDescriptionLabel;
@property (nonatomic, strong) UILabel *tipDescriptionLabel;

- (instancetype)initForTableReservationWithSubtotal:(NSString *)subtotal purchaseTitle:(NSString *)purchaseTitle tax:(NSString *)tax tip:(NSString *)tip total:(NSString *)total;

- (instancetype)initForTicketWithSubtotal:(NSString *)subtotal purchaseTitle:(NSString *)purchaseTitle serviceCharge:(NSString *)serviceCharge total:(NSString *)total;

@end