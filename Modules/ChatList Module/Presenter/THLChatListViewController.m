//
//  THLChatListViewController.m
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatListViewController.h"
#import "THLAppearanceConstants.h"
#import "THLChatListModel.h"
#import "THLChatListTableView.h"
#import "THLChatRoomViewController.h"
#import "THLParseQueryFactory.h"
#import "THLPubnubManager.h"
#import "THLChannel.h"

@interface THLChatListViewController ()<THLChatListTableViewDataSource, THLChatListTableViewDelegate, THLPubnubManagerDelegate>

@property (nonatomic, strong) THLChatListTableView *tableView;

@end

@implementation THLChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[THLPubnubManager sharedInstance] setDelegate:self];
    self.navigationItem.title = [@"Messages" uppercaseString];
    self.tableView = [[THLChatListTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageData:) name:@"kDataChatListSetupNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelsUpdated:) name:@"kDataChannelListSetupNotification" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[THLChatListModel sharedManager] requestGetChannels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfItemsInTableView:(THLChatListTableView *)tableView {
    return 1;
}

- (NSUInteger)numberOfSectionInTableView:(THLChatListTableView *)tableView {
    return [[THLChatListModel sharedManager] itemsCount];
}

- (THLChatListItem *)tableView:(THLChatListTableView *)tableView itemAtIndex:(NSUInteger)index {
    return [[THLChatListModel sharedManager] itemAtIndex:index];
}

- (void)tableView:(THLChatListTableView *)tableView didSelectItemAtIndex:(NSUInteger)index {
    THLChatListItem *chatItem = [[THLChatListModel sharedManager] itemAtIndex:index];
    THLChatRoomViewController * chrmvctrl = [[THLChatRoomViewController alloc] initWithChannel:chatItem];
    chrmvctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:chrmvctrl sender:nil];
}

#pragma mark - Observes

- (void)getMessageData:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)getChannelsUpdated:(NSNotification *)notification {
    [[THLChatListModel sharedManager] getChannelsList];
}

#pragma mark - pubnub delegate

- (void)didReceiveMessage:(THLPubnubManager *)manager withMessage:(PNMessageResult *)message {
    [[THLChatListModel sharedManager] requestGetChannels];
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
