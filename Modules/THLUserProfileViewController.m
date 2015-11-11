//
//  THLUserProfileViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfileViewController.h"
#import "THLUserProfileView.h"
#import "THLUserProfileTableViewCell.h"
#import "THLAppearanceConstants.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionPersonal = 0,
    TableViewSectionHypelist,
    TableViewSection_Count
};

typedef NS_ENUM(NSInteger, PersonalSectionRow) {
    PersonalSectionRowRewards = 0,
    PersonalSectionRow_Count
};

typedef NS_ENUM(NSInteger, HypelistSectionRow) {
    HypelistSectionRowWriteAReview = 0,
    HypelistSectionRowFAQ,
    HypelistSectionRowTermsAndConditions,
    HypelistSectionRowPrivacyPolicy,
    HypelistSectionRow_Count
};

static NSString *const kTHLUserProfileViewCellIdentifier = @"kTHLUserProfileViewCellIdentifier";

@interface THLUserProfileViewController()

@end

@implementation THLUserProfileViewController
@synthesize selectedIndexPathCommand;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

#pragma mark - View Setup
- (void)constructView {
    _tableView = [self newTableView];
}

- (void)layoutView {
    [self.view addSubviews:@[_tableView]];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

- (void)bindView {
    [self configureDataSource];
}

- (void)configureDataSource {
    [self registerCellsForTableView:_tableView];
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerClass:[THLUserProfileTableViewCell class] forCellReuseIdentifier:[THLUserProfileTableViewCell identifier]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSection_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case TableViewSectionPersonal: {
            return PersonalSectionRow_Count;
            break;
        }
        case TableViewSectionHypelist: {
            return HypelistSectionRow_Count;
            break;
        }
        default: {
            break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THLUserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[THLUserProfileTableViewCell identifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[THLUserProfileTableViewCell alloc] init];
    }
    
    cell.textLabel.text = [self cellTextForIndexPath:indexPath];
    return cell;
}

- (NSString *)cellTextForIndexPath:(NSIndexPath *)indexPath {
    NSString *text;
    TableViewSection section = indexPath.section;
    switch (section) {
        case TableViewSectionPersonal: {
            PersonalSectionRow row = indexPath.row;
            switch (row) {
                case PersonalSectionRowRewards: {
                    text = @"Rewards";
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case TableViewSectionHypelist: {
            HypelistSectionRow row = indexPath.row;
            switch (row) {
                case HypelistSectionRowWriteAReview: {
                    text = @"Write a Review";
                    break;
                }
                case HypelistSectionRowFAQ: {
                    text = @"Frequently Asked Questions";
                    break;
                }
                case HypelistSectionRowTermsAndConditions: {
                    text = @"Terms & Conditions";
                    break;
                }
                case HypelistSectionRowPrivacyPolicy: {
                    text = @"Privacy Policy";
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        default: {
            break;
        }
    }
    return text;
}

#pragma mark - Constructors
- (UITableView *)newTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    tableView.separatorColor = [UIColor clearColor];
//    tableView.dataSource = self;
    tableView.delegate = self;
    return tableView;
}
@end
