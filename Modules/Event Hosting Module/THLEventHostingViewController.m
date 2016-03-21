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
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_refreshCommand execute:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)showDetailsView:(UIView *)detailView {
    [self.parentViewController.view addSubview:detailView];
    [detailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:detailView];
}

- (void)hideDetailsView:(UIView *)detailView {
    [detailView removeFromSuperview];
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
    [RACObserve(self, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [SSELF configureDataSource:dataSource];
    }];
    
    [RACObserve(self, showRefreshAnimation) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [WSELF.tableView.pullToRefreshView startAnimating];
        } else {
            [WSELF.tableView.pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(self, refreshCommand) subscribeNext:^(RACCommand *command) {
        [WSELF.tableView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
}

#pragma mark - Data Source
- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _tableView.dataSource = dataSource;
    _dataSource.tableView = _tableView;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
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
    return 80;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}

#pragma mark - EmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no requests for your guestlist for this event";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"When a guest submits a guestlist for your event, it will show up here";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUIPrimaryBackgroundColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                 };
    
    NSString *text = @"Refresh";
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [_refreshCommand execute:nil];
}
@end
