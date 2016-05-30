//
//  THLPartyViewController.h
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@interface THLPartyViewController : PFQueryCollectionViewController
- (instancetype)initWithClassName:(NSString *)className withGuestlist:(PFObject *)guestlist;
@end
