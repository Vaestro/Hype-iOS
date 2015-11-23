//
//  THLEventHostingTableCellView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol THLEventHostingTableCellView <NSObject>
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *guestlistTitle;
@property (nonatomic) THLStatus guestlistReviewStatus;
@property (nonatomic, copy) NSString *guestlistReviewStatusTitle;
@end