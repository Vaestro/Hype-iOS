//
//  THLPartyInvitationViewController.h
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THContactPickerView.h"

@class THLGuestEntity;
@class THLSearchViewDataSource;
@class THLEvent;
@class THLYapDatabaseManager;
@class THLDataStore;
@class THLViewDataSourceFactory;
@class APAddressBook;
@class PFObject;

@protocol THLPartyInvitationViewControllerDelegate <NSObject>
- (void)partyInvitationViewControllerDidSkipSendingInvitesAndWantsToShowTicket:(PFObject *)invite;
- (void)partyInvitationViewControllerDidSubmitInvitesAndWantsToShowTicket:(PFObject *)invite;

@end


@interface THLPartyInvitationViewController : UIViewController
<
UITableViewDelegate,
THContactPickerDelegate
>
@property (nonatomic, weak) id<THLPartyInvitationViewControllerDelegate> delegate;
- (id)initWithEvent:(THLEvent *)event
        guestlistId:(NSString *)guestlistId
             guests:(NSArray *)guests
    databaseManager:(THLYapDatabaseManager *)databaseManager
          dataStore:(THLDataStore *)dataStore
viewDataSourceFactory:(THLViewDataSourceFactory *)viewDataSourceFactory
        addressBook:(APAddressBook *)addressBook;

@end
