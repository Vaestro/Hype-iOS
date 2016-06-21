//
//  THLPartyMemberCell.h
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCollectionViewCell.h"

@class THLPersonIconView;
@class THLStatusView;

@interface THLPartyMemberCell : PFCollectionViewCell
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) THLStatusView *statusView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic) THLStatus guestlistInviteStatus;

+ (NSString *)identifier;
@end
