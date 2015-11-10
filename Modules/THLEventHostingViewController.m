//
//  THLEventHostingViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingViewController.h"
#import "THLViewDataSource.h"

//Views
#import "THLGuestlistInvitationView.h"
#import "THLEventHostingTableCell.h"
#import "THLEventHostingTableCellViewModel.h"

//Utilities
#import "THLAppearanceConstants.h"
#import "UIScrollView+SVPullToRefresh.h"

//Entities
#import "THLGuestEntity.h"
#import "THLGuestlistEntity.h"

@implementation THLEventHostingViewController
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    [_refreshCommand execute:nil];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - View Setup
- (void)constructView {
    _tableView = [self newTableView];
}

- (void)layoutView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

- (void)bindView {
    WEAKSELF();
    STRONGSELF();
    [RACObserve(WSELF, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [SSELF configureDataSource:dataSource];
    }];
    
    [RACObserve(WSELF, showRefreshAnimation) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [SSELF.tableView.pullToRefreshView startAnimating];
        } else {
            [SSELF.tableView.pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(WSELF, refreshCommand) subscribeNext:^(RACCommand *command) {
        [SSELF.tableView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
}

#pragma mark - Data Source
- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _tableView.dataSource = dataSource;
    _dataSource.tableView = _tableView;
    
    [_tableView registerClass:[THLEventHostingTableCell class] forCellReuseIdentifier:[THLEventHostingTableCell identifier]];
    
    _dataSource.cellCreationBlock = (^id(id object, UITableView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLEventHostingTableCellViewModel class]]) {
            return [parentView dequeueReusableCellWithIdentifier:[THLEventHostingTableCell identifier] forIndexPath:indexPath];
        }
        return nil;
    });
    
    _dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLEventHostingTableCellViewModel class]] && [cell conformsToProtocol:@protocol(THLEventHostingTableCellView)]) {
            [(THLEventHostingTableCellViewModel *)object configureView:(id<THLEventHostingTableCellView>)cell];
        }
    });
}

#pragma mark - Constructors
- (UITableView *)newTableView {
    UITableView *tableView = [[UITableView alloc] init];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}
@end
