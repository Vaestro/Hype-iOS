//
//  THLTableReservationViewController.h
//  Hype
//
//  Created by Edgar Li on 6/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;
@interface THLTableReservationViewController : UIViewController
<
UICollectionViewDelegate
>
- (instancetype)initWithGuestlistInvite:(PFObject *)guestlistInvite;

@end
