//
//  THLGuestlistInvitationViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationViewController.h"
#import "THLGuestlistInvitationView.h"
#import "THContactPickerView.h"
#import "THLAppearanceConstants.h"
#import "THLUserEntity.h"
#import "THLGuestlistInvitationViewEventHandler.h"
#import "THLContactTableViewCell.h"
#import "THLSearchViewDataSource.h"
#import "THLGuestEntity.h"
#import "SVProgressHUD.h"


#define kContactPickerViewHeight 100.0

@implementation THLGuestlistInvitationViewController
@synthesize existingGuests = _existingGuests;
@synthesize eventHandler = _eventHandler;
@synthesize dataSource = _dataSource;
@synthesize showActivityIndicator = _showActivityIndicator;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self constructView];
    [self layoutView];
    [self bindView];
}

- (void)dealloc {
	_eventHandler = nil;
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
	_tableView = [self newTableView];
	_contactPickerView = [self newContactPickerView];
	_cancelButton = [self newCancelBarButtonItem];
	_cancelButton.rac_command = [self newCancelCommand];
	_commitButton = [self newCommitBarButtonItem];
	_commitButton.rac_command = [self newCommitCommand];
	_addedGuests = [NSMutableSet new];
}

- (void)layoutView {
	[self.view addSubviews:@[_tableView, _contactPickerView]];
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

			tvCell.iconImageURL = guest.imageURL;
			tvCell.name = guest.fullName;
			tvCell.phoneNumber = guest.phoneNumber;

			if ([WSELF.addedGuests containsObject:guest]) {
				tvCell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				tvCell.accessoryType = UITableViewCellAccessoryNone;
			}

			if ([WSELF.existingGuests containsObject:guest]) {
				tvCell.userInteractionEnabled = NO;
				tvCell.alpha = 0.5;
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

	[RACObserve(self, dataSource) subscribeNext:^(id x) {
		[self configureDataSource];
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
	CGRect tableFrame = CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (THContactPickerView *)newContactPickerView {
	THContactPickerView *pickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kContactPickerViewHeight)];
	pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
	pickerView.delegate = self;
    pickerView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    [pickerView setPlaceholderLabelText:@"Type a name or phone number"];
    [pickerView setPlaceholderLabelTextColor:kTHLNUIGrayFontColor];
	return pickerView;
}

- (UIBarButtonItem *)newCancelBarButtonItem {
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:NULL];
//	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction:)];

    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
	return item;
}

- (UIBarButtonItem *)newCommitBarButtonItem {
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Submit " style:UIBarButtonItemStylePlain target:nil action:NULL];
//	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Submit " style:UIBarButtonItemStylePlain target:self action:@selector(handleCommitAction:)];

    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
	return item;
}

//- (void)handleCancelAction:(id)sender {
//	[self.eventHandler viewDidCancelInvitations:self];
//}
//
//- (void)handleCommitAction:(id)sender {
//	[self.eventHandler viewDidCommitInvitations:self];
//}


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
	CGFloat yOffset = self.contactPickerView.frame.origin.y + self.contactPickerView.frame.size.height;

	CGRect tableFrame = CGRectMake(0, yOffset, self.view.frame.size.width, self.view.frame.size.height - yOffset);
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

#pragma mark - Adding/Removing
- (void)addGuest:(THLGuestEntity *)guest {
	[self willChangeValueForKey:@"addedGuests"];
	[self.addedGuests addObject:guest];
	[self didChangeValueForKey:@"addedGuests"];
}

- (void)removeGuest:(THLGuestEntity *)guest {
	[self willChangeValueForKey:@"addedGuests"];
	[self.addedGuests removeObject:guest];
	[self didChangeValueForKey:@"addedGuests"];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	THLGuestEntity *guest = [_dataSource untransformedItemAtIndexPath:indexPath];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	if (![self.addedGuests containsObject:guest]) {
		[self.eventHandler view:self didAddGuest:guest];
		[self addGuest:guest];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[_contactPickerView addContact:guest withName:guest.fullName];
	} else {
		[self.eventHandler view:self didRemoveGuest:guest];
		[self removeGuest:guest];
		cell.accessoryType = UITableViewCellAccessoryNone;
		[_contactPickerView removeContact:guest];
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
	[self removeGuest:contact];
	[_tableView reloadData];
}

- (BOOL)contactPickerTextFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length > 0){

	}
	return YES;
}

@end
