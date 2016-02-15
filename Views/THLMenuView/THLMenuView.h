//
//  THLMenuView.h
//  Hype
//
//  Created by Daniel Aksenov on 12/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLMenuView : UIView
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSURL *hostImageURL;

@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *menuAddGuestsCommand;
@property (nonatomic, strong) RACCommand *menuLeaveGuestCommand;
@property (nonatomic, strong) RACCommand *menuEventDetailsCommand;
@property (nonatomic, strong) RACCommand *menuChatHostCommand;
@property (nonatomic, strong) RACCommand *menuChatGroupCommand;
- (void)hostLayoutUpdate;
- (void)partyLeadLayoutUpdate;
- (void)guestLayoutUpdate;
@end
