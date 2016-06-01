//
//  THLAttendingEventCell.h
//  Hype
//
//  Created by Edgar Li on 6/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCollectionViewCell.h"

@interface THLAttendingEventCell : PFCollectionViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *venueNameLabel;
@property (nonatomic, strong) UILabel *partyTypeLabel;
@property (nonatomic, strong) UIImageView *venueImageView;

+ (NSString *)identifier;
@end

