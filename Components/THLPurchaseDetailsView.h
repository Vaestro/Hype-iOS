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
@property (nonatomic, strong) UILabel *totalLabel;
@end