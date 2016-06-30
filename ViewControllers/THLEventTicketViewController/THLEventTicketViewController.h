//
//  THLEventTicketView.h
//  Hype
//
//  Created by Edgar Li on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PFObject;
@interface THLEventTicketViewController : UIViewController
- (id)initWithGuestlistInvite:(PFObject *)guestlistInvite;

@end
