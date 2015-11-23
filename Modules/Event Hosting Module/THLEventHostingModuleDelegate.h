//
//  THLEventHostingModuleDelegate.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPromotionEntity;
@class THLGuestlistEntity;

@protocol THLEventHostingModuleInterface;
@protocol THLEventHostingModuleDelegate <NSObject>
- (void)eventHostingModule:(id<THLEventHostingModuleInterface>)module userDidSelectGuestlistEntity:(THLGuestlistEntity *)guestlistEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller;
- (void)dismissEventHostingWireframe;
@end

