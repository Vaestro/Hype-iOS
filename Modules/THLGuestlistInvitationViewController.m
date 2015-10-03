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

#define kContactPickerViewHeight 65
@implementation THLGuestlistInvitationViewController
@synthesize addedGuests;
@synthesize allGuests;
@synthesize eventHandler;

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
}

- (void)bindView {

}

#pragma mark - Constructors
- (UITableView *)newTableView {
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	tableView.allowsMultipleSelection = YES;
	tableView.delegate = self;
	tableView.dataSource = self;
	return tableView;
}

- (THContactPickerView *)newContactPickerView {
	THContactPickerView *pickerView = [[THContactPickerView alloc] initWithFrame:CGRectZero];
	pickerView.delegate = self;
	return pickerView;
}

#pragma mark - UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.allGuests.count;
}


#pragma mark - THContactPickerDelegate

@end
