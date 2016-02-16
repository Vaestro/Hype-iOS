//
//  THLChatRoomViewController.m
//  HypeUp
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatRoomViewController.h"
#import "THLChatRoomModel.h"
#import "THLAppearanceConstants.h"
#import "THLPubnubManager.h"
#import "THLPubnubManagerDelegate.h"
#import "THLMessage.h"
#import "THLUser.h"

NSString *const kDataMessagesNotifications = @"kDataMessageNotification";

CGFloat const kInputFieldHeight = 50.0;
CGFloat const kBottomBarHeight = 64.0;


@interface THLChatRoomViewController ()<THLChatTableVeiwDataSource, THLChatTableVeiwDelegate, THLPubnubManagerDelegate, THLChatRoomInputTextViewDelegate>

@property (nonatomic, strong) THLChatRoomTableView *tableView;
@property (nonatomic, strong) THLChatRoomInputTextView *textField;
@property (nonatomic, strong) THLChatListItem *currentChatItem;

@end

@implementation THLChatRoomViewController

- (instancetype)initWithChannel:(THLChatListItem *)chatItem
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.currentChatItem = chatItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[THLPubnubManager sharedInstance] setDelegate:self];
    self.navigationItem.title = self.currentChatItem.title;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.tableView = [[THLChatRoomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kInputFieldHeight - kBottomBarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInTable:)];
    [self.tableView addGestureRecognizer:tapRecognizer];
    
    self.textField = [[THLChatRoomInputTextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kInputFieldHeight - kBottomBarHeight, self.view.frame.size.width, kInputFieldHeight)];
    self.textField.delegate = self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageData:) name:kDataMessagesNotifications object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"kDataUpdateMessageNotification" object:nil];
    [self registerForKeyboardNotifications];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[THLChatRoomModel sharedManager] requestDataWithChannel:self.currentChatItem.channel];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView reloadData];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //[self.view setNeedsLayout];
    
    // Get keyboard size.
    
    NSValue *endFrameValue = info[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.view convertRect:endFrameValue.CGRectValue fromView:nil];
    
    NSNumber *durationValue = info[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         CGRect tableViewFrame = self.tableView.frame;
                         CGRect inputViewFrame = self.textField.frame;
                         
                         //tableViewFrame.size.height = (keyboardEndFrame.origin.y - tableViewFrame.origin.y - kInputFieldHeight);
                         tableViewFrame.size.height = self.view.frame.size.height - kInputFieldHeight - keyboardEndFrame.size.height;
                         inputViewFrame.origin.y = self.view.frame.size.height - kInputFieldHeight - keyboardEndFrame.size.height;
                         self.tableView.frame = tableViewFrame;
                         self.textField.frame = inputViewFrame;
                     } completion:^(BOOL finished) {
                         [self.tableView scrollToBottomWithAnimated:NO];
                     }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.textField.frame = CGRectMake(0, self.view.frame.size.height - kInputFieldHeight, self.textField.frame.size.width, self.view.frame.size.height - kInputFieldHeight - kBottomBarHeight);
    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.view.frame.size.height - kInputFieldHeight);
}

- (void)tapInTable:(UITapGestureRecognizer *)recognizer {
    [self.textField hideKeyboard];
}

#pragma mark - Observes

- (void)getMessageData:(NSNotification *)notification {
    [self.tableView reloadData];
    [self.tableView scrollToBottomWithAnimated:NO];
}

- (void)dataUpdated:(NSNotification *)notification {
     [self.tableView reloadData];
     [self.tableView scrollToBottomWithAnimated:YES];
}

- (NSUInteger)numberOfItemsInTableView:(THLChatRoomTableView *)tableView {
    return 1;
}

- (NSUInteger)numberOfSectionInTableView:(THLChatRoomTableView *)tableView {
    return [[THLChatRoomModel sharedManager] itemsCount];
}

- (THLMessage *)tableView:(THLChatRoomTableView *)tableView messageAtIndex:(NSUInteger)index {
    return [[THLChatRoomModel sharedManager] itemAtIndex:index];
}

#pragma mark - Pubnub Delegate

- (void)didReceiveMessage:(THLPubnubManager *)manager withMessage:(PNMessageResult *)message {
    [[THLChatRoomModel sharedManager] updateDataWithResult:message];
}

#pragma mark - TextInput Delegate

- (void)sendMessage:(NSString *)message {
    THLMessage * msg = [[THLMessage alloc] initWithText:message andUser:[THLUser currentUser]];
    [[THLPubnubManager sharedInstance] publishMessage:msg withChannel:self.currentChatItem.channel withCompletion:^(NSString *status) {
        if ([status isEqualToString:@"ok"]) {
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
            // Send push notification to query
            [PFPush sendPushMessageToQueryInBackground:pushQuery
                                           withMessage:@"New message"];
        }
    }];
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
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
