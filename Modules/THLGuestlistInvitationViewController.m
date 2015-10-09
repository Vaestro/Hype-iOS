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

#define kContactPickerViewHeight 65

@interface THLGuestlistInvitationViewController()
@property (nonatomic, strong) NSDictionary *guestDictionary;
@end


@implementation THLGuestlistInvitationViewController
@synthesize addedGuests;
@synthesize allGuests;
@synthesize eventHandler;
@synthesize dataSource = _dataSource;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
	_tableView = [self newTableView];
	_contactPickerView = [self newContactPickerView];
}

- (void)layoutView {
	[self.view addSubviews:@[_tableView, _contactPickerView]];
	[_contactPickerView makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(kTHLEdgeInsetsNone());
		make.height.equalTo(kContactPickerViewHeight);
	}];
	[_tableView makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_contactPickerView.mas_bottom).insets(kTHLEdgeInsetsNone());
		make.bottom.left.right.insets(kTHLEdgeInsetsNone());
	}];

	self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
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

	_dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
		if ([object isKindOfClass:[THLGuestEntity class]] && [cell isKindOfClass:[THLContactTableViewCell class]]) {
			THLContactTableViewCell *tvCell = (THLContactTableViewCell *)cell;
			THLGuestEntity *guest = (THLGuestEntity *)object;

			tvCell.iconImageURL = guest.imageURL;
			tvCell.name = guest.fullName;
			tvCell.phoneNumber = guest.phoneNumber;

			if ([self.addedGuests containsObject:guest]) {
				tvCell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				tvCell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	});
}

- (void)bindView {
	[RACObserve(self, dataSource) subscribeNext:^(id x) {
		[self configureDataSource];
	}];
}


#pragma mark - Constructors
- (UITableView *)newTableView {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	tableView.delegate = self;
	return tableView;
}

- (THContactPickerView *)newContactPickerView {
	THContactPickerView *pickerView = [[THContactPickerView alloc] initWithFrame:CGRectZero];
	pickerView.delegate = self;
	return pickerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	THLGuestEntity *guest = [_dataSource untransformedItemAtIndexPath:indexPath];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	if (![self.addedGuests containsObject:guest]) {
		[self.eventHandler view:self didAddGuest:guest];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[_contactPickerView addContact:guest withName:guest.fullName];
	} else {
		[self.eventHandler view:self didRemoveGuest:guest];
		cell.accessoryType = UITableViewCellAccessoryNone;
		[_contactPickerView removeContact:guest];
	}

	[_tableView reloadData];

}

#pragma mark - THContactPickerDelegate
- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
	[self.dataSource setSearchText:textViewText];
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {

}

- (void)contactPickerDidRemoveContact:(id)contact {
	NSInteger index = [self.allGuests indexOfObject:contact];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
	cell.accessoryType = UITableViewCellAccessoryNone;
}

- (BOOL)contactPickerTextFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length > 0){

	}
	return YES;
}

@end
