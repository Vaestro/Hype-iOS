//
//  THLEventHostingTableCellViewModel.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventHostingTableCellView.h"

@protocol THLEventHostingTableCellView;
@class THLGuestlistEntity;

@interface THLEventHostingTableCellViewModel : NSObject
@property (nonatomic, readonly) THLGuestlistEntity *guestlistEntity;

- (instancetype)initWithGuestlistEntity:(THLGuestlistEntity *)guestlist;
- (void)configureView:(id<THLEventHostingTableCellView>)view;
@end
