//
//  THLPartyInvitationViewController.m
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPartyInvitationViewController.h"
#import "THLSearchViewDataSource.h"
#import "THLViewDataSourceFactoryInterface.h"
#import "THLYapDatabaseManager.h"
#import "THLViewDataSourceFactory.h"
#import "THLYapDatabaseViewFactory.h"
#import "APAddressBook.h"
#import "APContact.h"
//Views
#import "THContactPickerView.h"
#import "THLContactTableViewCell.h"

//Utilities
#import "SVProgressHUD.h"
#import "THLAppearanceConstants.h"
#import "THLGuestEntity.h"
#import "THLEvent.h"
#import "THLGuestlist.h"
#import "THLGuestlistInvite.h"
#import "THLDataStore.h"

#define kContactPickerViewHeight 100.0
static NSString *const kGuestEntityFirstNameKey = @"firstName";
static NSString *const kGuestEntityLastNameKey = @"lastName";
static NSString *const kGuestEntityPhoneNumberKey = @"phoneNumber";
static NSString *const kGuestEntityObjectIdKey = @"objectId";
static NSString *const kTHLGuestlistInvitationSearchViewKey = @"kTHLGuestlistInvitationSearchViewKey";

@interface THLPartyInvitationViewController()
@property (nonatomic, strong) NSArray *existingGuests;
@property (nonatomic, strong) THLSearchViewDataSource *dataSource;
@property (nonatomic, strong) NSString *creditsPayout;
@property (nonatomic) BOOL showActivityIndicator;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic, strong) UIView *invitationDetailsView;
@property (nonatomic, strong) UILabel *invitationDetailsLabel;

@property (nonatomic) BOOL newAdditions;
@property (nonatomic, strong) NSMutableArray *addedGuests;
@property (nonatomic, strong) NSMutableArray *addedGuestDigits;
@property (nonatomic, strong) NSArray *currentGuests;

@property (nonatomic, strong) UIBarButtonItem *submitButton;

@property (nonatomic, strong) NSString *guestlistId;
@property (nonatomic, strong) THLEvent *event;
@property (nonatomic, strong) THLViewDataSourceFactory *viewDataSourceFactory;
@property (nonatomic, strong) THLYapDatabaseViewFactory *yapDatabaseViewFactory;
@property (nonatomic, strong) THLYapDatabaseManager *databaseManager;

@property (nonatomic, strong) APAddressBook *addressBook;
@property (nonatomic, strong) THLDataStore *dataStore;

@end

@implementation THLPartyInvitationViewController
- (id)initWithEvent:(THLEvent *)event
        guestlistId:(NSString *)guestlistId
             guests:(NSArray *)guests
    databaseManager:(THLYapDatabaseManager *)databaseManager
          dataStore:(THLDataStore *)dataStore
viewDataSourceFactory:(THLViewDataSourceFactory *)viewDataSourceFactory
        addressBook:(APAddressBook *)addressBook {
    if (self = [super init]) {
        self.event = event;
        self.creditsPayout = [NSString stringWithFormat:@"%d", event.creditsPayout];
        self.databaseManager = databaseManager;
        self.viewDataSourceFactory = viewDataSourceFactory;
        self.addressBook = addressBook;
        self.dataStore = dataStore;
        self.guestlistId = guestlistId;
        self.addedGuests = [NSMutableArray new];
        
        [self.addedGuestDigits removeAllObjects];

        self.currentGuests = guests;
    }
    return self;
}

#pragma mark - VC Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*Register for keyboard notifications*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.creditsPayout != nil) {
        [self.invitationDetailsView addSubview:self.invitationDetailsLabel];
    }
    self.navigationItem.rightBarButtonItem = self.submitButton;
    self.navigationItem.title = @"INVITE";
    
    self.dataSource = [self getDataSource];
    [self configureDataSource];
}

#pragma mark - Layout
- (void)viewDidLayoutSubviews {
    [self adjustTableFrame];
}

- (void)adjustTableFrame {
    CGFloat yOffset = self.contactPickerView.frame.origin.y + self.contactPickerView.frame.size.height;
    
    CGRect tableFrame = CGRectMake(0, yOffset, SCREEN_WIDTH, self.view.frame.size.height - yOffset);
    self.tableView.frame = tableFrame;
}

- (void)adjustTableViewInsetTop:(CGFloat)topInset {
    [self adjustTableViewInsetTop:topInset bottom:self.tableView.contentInset.bottom];
}

- (void)adjustTableViewInsetBottom:(CGFloat)bottomInset {
    [self adjustTableViewInsetTop:self.tableView.contentInset.top bottom:bottomInset];
}

- (void)adjustTableViewInsetTop:(CGFloat)topInset bottom:(CGFloat)bottomInset {
    self.tableView.contentInset = UIEdgeInsetsMake(topInset,
                                               self.tableView.contentInset.left,
                                               bottomInset,
                                               self.tableView.contentInset.right);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

#pragma mark - Data Source

- (void)configureDataSource {
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    
    [self.tableView registerClass:[THLContactTableViewCell class] forCellReuseIdentifier:[[THLContactTableViewCell class] identifier]];
    
    self.dataSource.cellCreationBlock = (^id(id object, UITableView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLGuestEntity class]]) {
            return [parentView dequeueReusableCellWithIdentifier:[THLContactTableViewCell identifier] forIndexPath:indexPath];
        }
        return nil;
    });
    
    WEAKSELF();
    self.dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLGuestEntity class]] && [cell isKindOfClass:[THLContactTableViewCell class]]) {
            THLContactTableViewCell *tvCell = (THLContactTableViewCell *)cell;
            THLGuestEntity *guest = (THLGuestEntity *)object;
            
            tvCell.name = guest.fullName;
            tvCell.phoneNumber = guest.phoneNumber;
            tvCell.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;

            if ([WSELF.addedGuests containsObject:guest]) {
                tvCell.tintColor = kTHLNUIAccentColor;
                tvCell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                tvCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            if ([WSELF.existingGuests containsObject:guest.intPhoneNumberFormat]) {
                tvCell.name = [NSString stringWithFormat:@"%@ (Already Invited!)", guest.fullName];
                tvCell.userInteractionEnabled = NO;
                tvCell.alpha = 0.5;
                [tvCell maskView].alpha = 0.5;
            }
            
            if ([tvCell respondsToSelector:@selector(setSeparatorInset:)]) {
                [tvCell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([tvCell respondsToSelector:@selector(setLayoutMargins:)]) {
                [tvCell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
}

- (THLSearchViewDataSource *)getDataSource {
    [self loadContacts];
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLSearchResultsViewDataSourceHandler *handler = [self viewHandler];
    THLSearchViewDataSource *searchDataSource = [self.viewDataSourceFactory createSearchDataSourceWithGrouping:grouping sorting:sorting handler:handler searchableProperties:@[kGuestEntityFirstNameKey, kGuestEntityLastNameKey, kGuestEntityObjectIdKey, kGuestEntityPhoneNumberKey] key:kTHLGuestlistInvitationSearchViewKey];
    return searchDataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLGuestEntity class]]) {
            THLGuestEntity *guest = (THLGuestEntity *)entity;
            if (guest.firstName) {
                return [guest.firstName substringToIndex:1];
            } else if (guest.lastName) {
                return [guest.lastName substringToIndex:1];
            } else {
                return @"123?";
            }
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLGuestEntity *guest1 = (THLGuestEntity *)entity1;
        THLGuestEntity *guest2 = (THLGuestEntity *)entity2;
        return [guest1.fullName compare:guest2.fullName];
    }];
}

- (THLSearchResultsViewDataSourceHandler *)viewHandler {
    return [THLSearchResultsViewDataSourceHandler withBlock:^(NSMutableDictionary *dict, NSString *collection, id object) {
        if ([object isKindOfClass:[THLGuestEntity class]]) {
            THLGuestEntity *guest = (THLGuestEntity *)object;
            dict[kGuestEntityFirstNameKey] = guest.firstName;
            dict[kGuestEntityLastNameKey] = guest.lastName;
            dict[kGuestEntityPhoneNumberKey] = guest.phoneNumber;
            dict[kGuestEntityObjectIdKey] = guest.objectId;
        }
    }];
}



#pragma  mark - NSNotificationCenter
- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    [self adjustTableViewInsetBottom:self.tableView.frame.origin.y + self.tableView.frame.size.height - kbRect.origin.y];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    [self adjustTableViewInsetBottom:self.tableView.frame.origin.y + self.tableView.frame.size.height - kbRect.origin.y];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    THLGuestEntity *guest = [self.dataSource untransformedItemAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.addedGuests.count <= 9) {
        
        self.submitButton.title = @"Submit";
        
        if (![self.addedGuests containsObject:guest]) {
            [self addGuest:guest];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.contactPickerView addContact:guest withName:guest.fullName];
        } else {
            [self removeGuest:guest];
            if (self.addedGuests.count == 0) self.submitButton.title = @"Skip";
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.contactPickerView removeContact:guest];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"You can only add 10 people at a time"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [_tableView reloadData];
    
}

#pragma mark - THContactPickerDelegate
- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    [self.dataSource setSearchString:textViewText];
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
    CGRect frame = self.tableView.frame;
    frame.origin.y = contactPickerView.frame.size.height + contactPickerView.frame.origin.y;
    self.tableView.frame = frame;
}

- (void)contactPickerDidRemoveContact:(id)contact {
//    [_eventHandler view:self didRemoveGuest:contact];
    [self removeGuest:contact];
    [self.tableView reloadData];
}

- (BOOL)contactPickerTextFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0){
        
    }
    return YES;
}

- (void)checkForGuestlist {
    NSAssert(_guestlistId != nil, @"_guestlistId must be set prior to this call!");
}

- (BOOL)isGuestInvited:(THLGuestEntity *)guest {
    //	[self checkForGuestlist];
    return [_currentGuests containsObject:guest.intPhoneNumberFormat] || [_addedGuests containsObject:guest];
}


#pragma mark - Adding/Removing
- (void)addGuest:(THLGuestEntity *)guest {
    [self willChangeValueForKey:@"addedGuests"];
    if ([self canAddGuest:guest]) {
        [_addedGuests addObject:guest];
    }
    [self didChangeValueForKey:@"addedGuests"];
}

- (void)removeGuest:(THLGuestEntity *)guest {
    [self willChangeValueForKey:@"addedGuests"];
    if ([self canRemoveGuest:guest]) {
        [_addedGuests removeObject:guest];
    }
    [self didChangeValueForKey:@"addedGuests"];
    
}

- (BOOL)canAddGuest:(THLGuestEntity *)guest {
    //	[self checkForGuestlist];
    return ![self isGuestInvited:guest];
}

- (BOOL)canRemoveGuest:(THLGuestEntity *)guest {
    //	[self checkForGuestlist];
    return [_addedGuests containsObject:guest];
}


- (NSArray *)obtainDigits:(NSArray<THLGuestEntity *> *)addedGuests {
    return [addedGuests linq_select:^id(id guest) {
        return [guest intPhoneNumberFormat];
    }];
}

- (void)commitChangesToGuestlist {
    if (!_addedGuests || !_addedGuests.count) {
        [[self getOwnerInviteForEvent] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *fetchTask) {
            [self.delegate partyInvitationViewControllerDidSkipSendingInvitesAndWantsToShowTicket:fetchTask.result];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"Guestlist Submitted" properties:@{
                                                                @"Number Of Invites": NSStringWithFormat(@"%lu", (unsigned long)_addedGuests.count)
                                                                }];
            [mixpanel.people increment:@"guestlist invites sent" by: [NSNumber numberWithUnsignedInteger:_addedGuests.count]];
            return nil;
        }];
    } else {
        [[self submitInvites:[self obtainDigits:_addedGuests] forGuestlist:_guestlistId atEvent:_event] continueWithSuccessBlock:^id(BFTask *task) {
            [[self getOwnerInviteForEvent] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *fetchTask) {
                [self.delegate partyInvitationViewControllerDidSubmitInvitesAndWantsToShowTicket:fetchTask.result];
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel track:@"Guestlist Submitted" properties:@{
                                                                    @"Number Of Invites": NSStringWithFormat(@"%lu", (unsigned long)_addedGuests.count)
                                                                    }];
                [mixpanel.people increment:@"guestlist invites sent" by: [NSNumber numberWithUnsignedInteger:_addedGuests.count]];
                return nil;
            }];
        return nil;
        }];
    }
}

- (BFTask *)getOwnerInviteForEvent {
    return [[self fetchGuestlistInviteForEvent] continueWithSuccessBlock:^id(BFTask *task) {
        return task;
    }];
}

- (BFTask *)fetchGuestlistInviteForEvent
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [[self queryForGuestlistInviteForEvent:_event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *error) {
        if (!error) {
            PFObject *guestlist = guestlistInvite[@"Guestlist"];
            [guestlistInvite setObject:guestlist forKey:@"Guestlist"];
            PFObject *owner = guestlistInvite[@"Guestlist"][@"Owner"];
            [guestlist setObject:owner forKey:@"Owner"];
            PFObject *fetchedEvent = guestlistInvite[@"Guestlist"][@"event"];
            [guestlist setObject:fetchedEvent forKey:@"event"];
            PFObject *location = guestlistInvite[@"Guestlist"][@"event"][@"location"];
            [fetchedEvent setObject:location forKey:@"location"];
            [completionSource setResult:guestlistInvite];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

- (PFQuery *)queryForGuestlistInviteForEvent:(NSString *)eventId {
    
    PFQuery *eventQuery = [THLEvent query];
    [eventQuery includeKey:@"location"];
    [eventQuery includeKey:@"host"];
    [eventQuery whereKey:@"objectId" equalTo:eventId];
    
    PFQuery *guestlistQuery = [THLGuestlist query];
    [guestlistQuery includeKey:@"Owner"];
    [guestlistQuery includeKey:@"event"];
    [guestlistQuery includeKey:@"event.host"];
    [guestlistQuery includeKey:@"event.location"];
    [guestlistQuery whereKey:@"event" matchesQuery:eventQuery];
    
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.host"];
    [query includeKey:@"Guestlist.event.location"];
    [query whereKey:@"Guest" equalTo:[THLUser currentUser]];
    [query whereKey:@"Guestlist" matchesQuery:guestlistQuery];
    [query whereKey:@"response" notEqualTo:[NSNumber numberWithInteger:-1]];
    return query;
}


- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId {
    return [[self fetchInvitesOnGuestlist:[THLGuestlist objectWithoutDataWithObjectId:guestlistId]] continueWithSuccessBlock:^id(BFTask *task) {
        NSArray<THLGuestEntity *> *guests = [self convertUsers:task.result];
        [self storeGuests:guests];
        return [BFTask taskWithResult:guests];
    }];
}

- (BFTask *)fetchInvitesOnGuestlist:(THLGuestlist *)guestlist
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlistInvites = [NSMutableArray new];
    [[self queryForInvitesOnGuestlist:guestlist] findObjectsInBackgroundWithBlock:^(NSArray *guestlistInvites, NSError *error) {
        for (PFObject *guestlistInvite in guestlistInvites) {
            PFObject *guest = guestlistInvite[@"Guest"];
            if (guest != nil) {
                [guestlistInvite setObject:guest forKey:@"guest"];
            }
            else {
                THLUser *dummyGuest = [THLUser new];
                dummyGuest.firstName = @"Pending Signup";
                [guestlistInvite setObject:dummyGuest forKey:@"guest"];
            }
            [completedGuestlistInvites addObject:guestlistInvite];
        }
        [completionSource setResult:completedGuestlistInvites];
    }];
    return completionSource.task;
}

- (PFQuery *)queryForInvitesOnGuestlist:(THLGuestlist *)guestlist {
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.host"];
    [query includeKey:@"Guestlist.event.location"];
    [query whereKey:@"Guestlist" equalTo:guestlist];
    return query;
}

- (BFTask *)submitInvites:(NSArray *)guestPhoneNumbers forGuestlist:(NSString *)guestlistId atEvent:(THLEvent *)event
{
    return [[self updateGuestlist:guestlistId withInvites:guestPhoneNumbers forEvent:event] continueWithSuccessBlock:^id(BFTask * task) {
        return [BFTask taskWithResult:nil];
    }];
}

- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forEvent:(THLEvent *)event
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [PFCloud callFunctionInBackground:@"sendOutInvitations"
                       withParameters:@{@"eventId": event.objectId,
                                        @"eventName":event.location.name,
                                        @"eventTime": event.date,
                                        @"guestPhoneNumbers": guestPhoneNumbers,
                                        @"guestlistId": guestlistId}
                                block:^(id response, NSError *error) {
                                    
                                    if (!error){
                                        [completionSource setResult:nil];
                                    } else {
                                        [completionSource setError:error];
                                    }
                                }];
    return completionSource.task;
}

- (void)loadContacts {
    [[self getContactsTasks] continueWithSuccessBlock:^id(BFTask *task) {
        NSArray<THLGuestEntity *> *guestContacts = [self convertContacts:task.result];
        [self storeGuests:guestContacts];
        return nil;
    }];
}

- (BFTask *)getContactsTasks {
    return [[self getAddressBookAccessTask] continueWithSuccessBlock:^id(BFTask *task) {
        return [self loadContactsTask];
    }];
}

- (BFTask *)loadContactsTask {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    self.addressBook.filterBlock = ^BOOL(APContact *contact) {
        return ((contact.name.firstName != NULL || contact.name.lastName != NULL) && contact.phones.count > 0);
    };
    
    self.addressBook.fieldsMask = APContactFieldDefault;
    
    [self.addressBook loadContacts:^(NSArray *contacts, NSError *error) {
        if (error) {
            [completionSource setError:error];
        } else {
            [completionSource setResult:contacts];
        }
    }];
    
    return completionSource.task;
}

- (BFTask *)getAddressBookAccessTask {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [[self.addressBook class] requestAccess:^(BOOL granted, NSError *error) {
        if (error) {
            [completionSource setError:error];
        } else {
            [completionSource setResult:@(granted)];
        }
    }];
    return completionSource.task;
}

- (NSArray<THLGuestEntity *> *)convertContacts:(NSArray<APContact *> *)contacts {
    return [contacts linq_select:^id(id item) {
        APContact *contact = (APContact *)item;
        return [THLGuestEntity fromContact:contact];
    }];
}

- (NSArray<THLGuestEntity *> *)convertUsers:(NSArray<THLUserEntity *> *)users {
    return [users linq_select:^id(id item) {
        return [THLGuestEntity fromUser:(THLUserEntity *)item];
    }];
}

- (void)storeGuests:(NSArray<THLGuestEntity *> *)guests {
    [self.dataStore updateOrAddEntities:[NSSet setWithArray:guests]];
}

#pragma mark - Constructors
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableFrame = CGRectMake(0, _contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _tableView.separatorColor = kTHLNUIPrimaryBackgroundColor;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)invitationDetailsView {
    if (!_invitationDetailsView) {
        _invitationDetailsView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height - 20, self.view.frame.size.width, 60)];
        _invitationDetailsView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        [self.view addSubview:_invitationDetailsView];
    }
    return _invitationDetailsView;
}

- (UILabel *)invitationDetailsLabel {
    if (!_invitationDetailsLabel) {
        _invitationDetailsLabel = THLNUILabel(kTHLNUIDetailTitle);
        _invitationDetailsLabel.frame = CGRectMake(0, 0, _invitationDetailsView.frame.size.width*0.67, _invitationDetailsView.frame.size.height);
        _invitationDetailsLabel.center = CGPointMake(_invitationDetailsView.bounds.size.width  / 2,
                                                     _invitationDetailsView.bounds.size.height / 2);
        _invitationDetailsLabel.numberOfLines = 0;
        _invitationDetailsLabel.textAlignment = NSTextAlignmentCenter;
        if (_event.creditsPayout > 0) _invitationDetailsLabel.text = [NSString stringWithFormat:@"Get $%d.00 for every friend you invite that attends this event", _event.creditsPayout];
    }
    
    return _invitationDetailsLabel;
}

- (THContactPickerView *)contactPickerView {
    if (!_contactPickerView) {
        _contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kContactPickerViewHeight)];
        _contactPickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        _contactPickerView.delegate = self;
        _contactPickerView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        [_contactPickerView setPlaceholderLabelText:@"Type a name or phone number"];
        [_contactPickerView setPlaceholderLabelTextColor:kTHLNUIGrayFontColor];
        THContactViewStyle *contactViewStyle = [[THContactViewStyle alloc] initWithTextColor:[UIColor blackColor] backgroundColor:kTHLNUIAccentColor cornerRadiusFactor:0];
        THContactViewStyle *selectedContactViewStyle = [[THContactViewStyle alloc] initWithTextColor:[UIColor blackColor] backgroundColor:[kTHLNUIAccentColor colorWithAlphaComponent:0.67f] cornerRadiusFactor:0];
        
        [_contactPickerView setContactViewStyle:contactViewStyle selectedStyle:selectedContactViewStyle];
        [self.view addSubview:_contactPickerView];
    }
    return _contactPickerView;
}

- (UIBarButtonItem *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(commitChangesToGuestlist)];
        
        [_submitButton setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                                     forState:UIControlStateNormal];
    }
    return _submitButton;
}




@end
