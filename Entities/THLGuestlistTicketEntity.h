//
//  THLGuestlistTicketEntity.h
//  Hype
//
//  Created by Daniel Aksenov on 5/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLGuestlistEntity;
@class THLGuestEntity;

@interface THLGuestlistTicketEntity : THLEntity
@property (nonatomic, strong) THLGuestEntity *sender;
@property (nonatomic, strong) THLGuestlistEntity *guestlist;
@property (nonatomic, copy) NSURL *qrCode;
@property (nonatomic) bool scanned;
@end
