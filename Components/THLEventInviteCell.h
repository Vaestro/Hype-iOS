//
//  THLEventInviteCell.h
//  Hype
//
//  Created by Edgar Li on 5/24/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCollectionViewCell.h"

@class THLPersonIconView;
@class THLStatusView;

@interface THLEventInviteCell : PFCollectionViewCell
@property (nonatomic, strong, readonly) THLPersonIconView *personIconView;

@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UILabel *locationNameLabel;
@property (nonatomic, strong, readonly) UILabel *senderIntroductionLabel;
@property (nonatomic, strong, readonly) THLStatusView *statusView;

+ (NSString *)identifier;

@end
