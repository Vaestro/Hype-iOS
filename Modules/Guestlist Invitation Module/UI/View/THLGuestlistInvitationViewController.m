//
//  THLGuestlistInvitationViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationViewController.h"
#import "THLGuestlistInvitationViewEventHandler.h"
#import "THLSearchViewDataSource.h"

//Views
#import "THLGuestlistInvitationView.h"
#import "THContactPickerView.h"
#import "THLContactTableViewCell.h"

//Utilities
#import "SVProgressHUD.h"
#import "THLAppearanceConstants.h"

//Entities
#import "THLUserEntity.h"
#import "THLGuestEntity.h"
#import "UIView+DimView.h"

#define kContactPickerViewHeight 100.0

@implementation THLGuestlistInvitationViewController
@synthesize existingGuests = _existingGuests;
@synthesize eventHandler = _eventHandler;
@synthesize dataSource = _dataSource;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize creditsPayout = _creditsPayout;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self constructView];
    [self layoutView];
    [self bindView];
}

- (void)dealloc {
	_eventHandler = nil;
//    NSLog(@"Destroyed %@", self);
}

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

- (void)setEventHandler:(id<THLGuestlistInvitationViewEventHandler>)eventHandler {
	_eventHandler = eventHandler;
}

#pragma mark - View Setup
- (void)constructView {
    _contactPickerView = [self newContactPickerView];
	_tableView = [self newTableView];
	_cancelButton = [self newCancelBarButtonItem];
	_cancelButton.rac_command = [self newCancelCommand];
	_commitButton = [self newCommitBarButtonItem];
	_commitButton.rac_command = [self newCommitCommand];
	_addedGuests = [NSMutableSet new];
    _invitationDetailsView = [self newInvitationDetailsView];
    _invitationDetailsLabel = [self newInvitationDetailsLabel];
}

- (void)layoutView {
	[self.view addSubviews:@[_tableView, _contactPickerView, _invitationDetailsView]];
    [_invitationDetailsView addSubview:_invitationDetailsLabel];
    [_invitationDetailsView bringSubviewToFront:_invitationDetailsLabel];
	self.navigationItem.leftBarButtonItem = _cancelButton;
	self.navigationItem.rightBarButtonItem = _commitButton;
    self.navigationItem.title = @"INVITE";
}

- (void)configureDataSource {
	_tableView.dataSource = _dataSource;
	_dataSource.tableView = _tableView;

	[_tableView registerClass:[THLContactTableViewCell class] forCellReuseIdentifier:[[THLContactTableViewCell class] identifier]];

	_dataSource.cellCreationBlock = (^id(id object, UITableView* parentView, NSIndexPath *indexPath) {
		if ([object isKindOfClass:[THLGuestEntity class]]) {
			return [parentView dequeueReusableCellWithIdentifier:[THLContactTableViewCell identifier] forIndexPath:indexPath];
		}
		return nil;
	});

	WEAKSELF();
	_dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
		if ([object isKindOfClass:[THLGuestEntity class]] && [cell isKindOfClass:[THLContactTableViewCell class]]) {
			THLContactTableViewCell *tvCell = (THLContactTableViewCell *)cell;
			THLGuestEntity *guest = (THLGuestEntity *)object;

			tvCell.name = guest.fullName;
			tvCell.phoneNumber = guest.phoneNumber;

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

- (void)bindView {
    WEAKSELF();
    RAC(self.invitationDetailsLabel, text, @"") = RACObserve(self, creditsPayout);
    
	[RACObserve(self, dataSource) subscribeNext:^(id x) {
		[WSELF configureDataSource];
	}];
    
    [RACObserve(WSELF, showActivityIndicator) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - Constructors
- (UITableView *)newTableView {
	CGRect tableFrame = CGRectMake(0, _contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height);
	UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	tableView.delegate = self;
    tableView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    tableView.separatorColor = kTHLNUIPrimaryBackgroundColor;
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
	return tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)newInvitationDetailsView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height - 20, self.view.frame.size.width, 60)];
    view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    return view;
}

- (UILabel *)newInvitationDetailsLabel {
    
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.frame = CGRectMake(0, 0, _invitationDetailsView.frame.size.width*0.67, _invitationDetailsView.frame.size.height);
    label.center = CGPointMake(_invitationDetailsView.bounds.size.width  / 2,
                                     _invitationDetailsView.bounds.size.height / 2);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (THContactPickerView *)newContactPickerView {
	THContactPickerView *pickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kContactPickerViewHeight)];
	pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
	pickerView.delegate = self;
    pickerView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    [pickerView setPlaceholderLabelText:@"Type a name or phone number"];
    [pickerView setPlaceholderLabelTextColor:kTHLNUIGrayFontColor];
    THContactViewStyle *contactViewStyle = [[THContactViewStyle alloc] initWithTextColor:kTHLNUIPrimaryFontColor backgroundColor:kTHLNUIAccentColor cornerRadiusFactor:0];
    THContactViewStyle *selectedContactViewStyle = [[THContactViewStyle alloc] initWithTextColor:kTHLNUIPrimaryFontColor backgroundColor:[kTHLNUIAccentColor colorWithAlphaComponent:0.67f] cornerRadiusFactor:0];
    
    [pickerView setContactViewStyle:contactViewStyle selectedStyle:selectedContactViewStyle];
	return pickerView;
}

- (UIBarButtonItem *)newCancelBarButtonItem {
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:NULL];

    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
	return item;
}

- (UIBarButtonItem *)newCommitBarButtonItem {
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Submit " style:UIBarButtonItemStylePlain target:nil action:NULL];

    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
	return item;
}

- (RACCommand *)newCommitCommand {
	WEAKSELF();
	RACCommand *command = [[RACCommand alloc] initWithEnabled:[RACObserve(self, addedGuests) map:^id(NSSet *value) {
		return @(value.count > 0);
	}] signalBlock:^RACSignal *(id input) {
		[WSELF.eventHandler viewDidCommitInvitations:WSELF];
		return [RACSignal empty];
	}];
	return command;
}

- (RACCommand *)newCancelCommand {
	WEAKSELF();
	RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[WSELF.eventHandler viewDidCancelInvitations:WSELF];
		return [RACSignal empty];
	}];
	return command;
}

#pragma mark - Layout
- (void)viewDidLayoutSubviews {
	[self adjustTableFrame];
}

- (void)adjustTableFrame {
	CGFloat yOffset = _contactPickerView.frame.origin.y + _contactPickerView.frame.size.height;

	CGRect tableFrame = CGRectMake(0, yOffset, SCREEN_WIDTH, self.view.frame.size.height - yOffset);
	_tableView.frame = tableFrame;
}

- (void)adjustTableViewInsetTop:(CGFloat)topInset {
	[self adjustTableViewInsetTop:topInset bottom:_tableView.contentInset.bottom];
}

- (void)adjustTableViewInsetBottom:(CGFloat)bottomInset {
	[self adjustTableViewInsetTop:_tableView.contentInset.top bottom:bottomInset];
}

- (void)adjustTableViewInsetTop:(CGFloat)topInset bottom:(CGFloat)bottomInset {
	_tableView.contentInset = UIEdgeInsetsMake(topInset,
												   _tableView.contentInset.left,
												   bottomInset,
												   _tableView.contentInset.right);
	_tableView.scrollIndicatorInsets = _tableView.contentInset;
}



#pragma  mark - NSNotificationCenter
- (void)keyboardDidShow:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
	CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
	[self adjustTableViewInsetBottom:_tableView.frame.origin.y + _tableView.frame.size.height - kbRect.origin.y];
}

- (void)keyboardDidHide:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
	CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
	[self adjustTableViewInsetBottom:_tableView.frame.origin.y + _tableView.frame.size.height - kbRect.origin.y];
}

#pragma mark - Adding/Removing
- (void)addGuest:(THLGuestEntity *)guest {
	[self willChangeValueForKey:@"addedGuests"];
	[_addedGuests addObject:guest];
	[self didChangeValueForKey:@"addedGuests"];
}

- (void)removeGuest:(THLGuestEntity *)guest {
	[self willChangeValueForKey:@"addedGuests"];
	[_addedGuests removeObject:guest];
	[self didChangeValueForKey:@"addedGuests"];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	THLGuestEntity *guest = [_dataSource untransformedItemAtIndexPath:indexPath];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	if (![_addedGuests containsObject:guest]) {
		[_eventHandler view:self didAddGuest:guest];
		[self addGuest:guest];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[_contactPickerView addContact:guest withName:guest.fullName];
	} else {
		[_eventHandler view:self didRemoveGuest:guest];
		[self removeGuest:guest];
		cell.accessoryType = UITableViewCellAccessoryNone;
		[_contactPickerView removeContact:guest];
	}

	[_tableView reloadData];

}

#pragma mark - THContactPickerDelegate
- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
	[_dataSource setSearchString:textViewText];
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
	CGRect frame = _tableView.frame;
	frame.origin.y = contactPickerView.frame.size.height + contactPickerView.frame.origin.y;
	_tableView.frame = frame;
}

- (void)contactPickerDidRemoveContact:(id)contact {
    [_eventHandler view:self didRemoveGuest:contact];
    [self removeGuest:contact];
    [_tableView reloadData];
}

- (BOOL)contactPickerTextFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length > 0){

	}
	return YES;
}

@end
