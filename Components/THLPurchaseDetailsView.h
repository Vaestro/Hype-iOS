//
//  THLPurchaseDetailsView.h
//  Hype
//
//  Created by Edgar Li on 5/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"

@interface THLPurchaseDetailsView : THLTitledContentView
@property (nonatomic, copy) NSString *purchaseTitleText;

@property (nonatomic, copy) NSString *subtotalAmount;
@property (nonatomic, copy) NSString *serviceChargeAmount;
@property (nonatomic, copy) NSString *totalAmount;

@end