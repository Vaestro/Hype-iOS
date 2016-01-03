//
//  THLMenuView.h
//  Hype
//
//  Created by Daniel Aksenov on 12/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface THLMenuView : FXBlurView
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *menuAddGuestsCommand;
@property (nonatomic, strong) RACCommand *menuLeaveGuestCommand;
@property (nonatomic, strong) RACCommand *menuEventDetailsCommand;
@property (nonatomic, strong) RACCommand *menuContactHostCommand;
- (void)hostLayoutUpdate;
- (void)guestLayoutUpdate;
@end
