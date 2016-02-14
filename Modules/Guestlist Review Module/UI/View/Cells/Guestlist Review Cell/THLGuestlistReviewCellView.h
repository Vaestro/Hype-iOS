//
//  THLGuestlistReviewCellView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/1/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLGuestlistReviewCellView <NSObject>
@property (nonatomic, copy) NSString *nameText;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic) THLStatus guestlistInviteStatus;
@end