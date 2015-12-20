//
//  THLPerkDetailView.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLPerkDetailView <NSObject>
@property (nonatomic, copy) NSURL *perkStoreItemImage;
@property (nonatomic, copy) NSString *perkStoreItemName;
@property (nonatomic, copy) NSString *perkStoreItemDescription;
@property (nonatomic) int credits;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *purchaseCommand;
- (void)showRedeemPerkView:(UIView *)redeemPerkView;
- (void)hideRedeemPerkView:(UIView *)redeemPerkView;
//@property (nonatomic, strong) RACCommand *actionBarButtonCommand;
//@property (nonatomic) BOOL viewAppeared;

@end
