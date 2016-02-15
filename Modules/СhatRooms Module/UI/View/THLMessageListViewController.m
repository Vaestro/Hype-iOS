//
//  THLChatRoomsViewController.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListViewController.h"
#import "THLMessageListCell.h"
#import "THLViewDataSource.h"
#import "THLMessageListViewModel.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface THLMessageListViewController ()
<
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THLMessageListViewController
@synthesize dataSource = _dataSource;
@synthesize viewAppeared;
@synthesize refreshCommand = _refreshCommand;
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize showRefreshAnimation = _showRefreshAnimation;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutView];
    [self configureBindings];
    [_refreshCommand execute:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
    self.viewAppeared = TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = FALSE;
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.title = @"CONVERSATIONS";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _tableView = [self newTableView];
    [self.view addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

#pragma mark - Constructors
- (UITableView *)newTableView {
//    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.minimumInteritemSpacing = 2.5;
//    flowLayout.minimumLineSpacing = 2.5;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableView.nuiClass = kTHLNUIBackgroundView;
    tableView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    //tableView.alwaysBounceVertical = YES;
    tableView.delegate = self;
    return tableView;
}

- (void)configureBindings {
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
//    
//    [RACObserve(WSELF, currentUserCredit) subscribeNext:^(id x) {
//        float credits = [x floatValue];
//        SSELF.userCreditsLabel.text = [self formattedStringWithDecimal:[[NSNumber alloc]initWithFloat:credits]];
//    }];
    
    [RACObserve(WSELF, refreshCommand) subscribeNext:^(RACCommand *command) {
        [SSELF.tableView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _tableView.dataSource = dataSource;
    dataSource.tableView = _tableView;
    
    [self.tableView registerClass:[THLMessageListCell class] forCellReuseIdentifier:@"MessageCell"];
    
    dataSource.cellCreationBlock = (^id(id object, UITableView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLMessageListViewModel class]]) {
            return [parentView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        }
        return nil;
    });

    dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLMessageListViewModel class]] && [cell conformsToProtocol:@protocol(THLMessageListCellView)]) {
            [(THLMessageListViewModel *)object configureView:(id<THLMessageListCellView>)cell];
        }
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
