//
//  THLUserProfileViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLUserProfileViewController.h"
#import "THLUserProfileView.h"
#import "THLUserProfileInfoView.h"
#import "THLUserProfileTableViewCell.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"
#import "THLInformationViewController.h"
#import "THLResourceManager.h"
#import "THLUserProfileFooterView.h"
#import "THLUserProfileHeaderView.h"
#import "THLUserPhotoVerificationViewController.h"
#import "THLTextEntryViewController.h"
#import "THLFAQViewController.h"
#import "THLUserManager.h"
#import "Intercom/intercom.h"
#import "THLUser.h"
#import "Parse.h"
#import "Stripe.h"
#import "THLPaymentViewController.h"
#import "THLWebViewController.h"
#import "MBProgressHUD.h"

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
    HypelistSectionRowContactUs,
    HypelistSectionRowLogout,
    HypelistSectionRow_Count
};

typedef NS_ENUM(NSUInteger, ApplicationInfoCase){
    InviteFriends = 0,
    RedeemCode,
    PaymentMethod,
    PrivacyPolicy,
    TermsAndConditions,
    ContactUs,
    LogOut
};

static NSString *const kTHLUserProfileViewCellIdentifier = @"kTHLUserProfileViewCellIdentifier";
static NSString *branchMarketingLink = @"https://bnc.lt/m/aTR7pkSq0q";

@interface THLUserProfileViewController()
<
THLUserPhotoVerificationInterfaceDidHideDelegate,
THLTextEntryViewDelegate,
STPPaymentCardTextFieldDelegate
>

@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *tableCellNames;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, strong) THLInformationViewController *infoVC;
@property (nonatomic, strong) RACCommand *dismissVC;
@property (nonatomic) THLWebViewController *webViewController;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation THLUserProfileViewController
@synthesize selectedIndexPathCommand;
@synthesize contactCommand;
@synthesize logoutCommand;
@synthesize userName;
@synthesize userImageURL;

#pragma mark - VC Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    
    self.tableCellNames = @[@"Invite Friends",@"Redeem Code", @"Payment Method", @"Privacy Policy", @"Terms & Conditions", @"Contact Us", @"Logout"];
    self.navigationItem.title = @"MY PROFILE";
    
    if ([THLUser currentUser])
    {
        self.navigationItem.leftBarButtonItem = [self newBarButtonItem];
    }
}

#pragma mark - View Setup
- (void)constructView {
    _tableView = [self newTableView];
    _infoVC = [self newInfoVC];
}

- (void)layoutView {
    
    self.view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];

    [self.view addSubviews:@[_tableView, _hud]];
    
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    
}

-(void)viewDidLayoutSubviews {
    self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height - 1);

}
- (void)bindView {
    [self configureDataSource];
}

- (void)configureDataSource {
    [self registerCellsForTableView:_tableView];
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerClass:[THLUserProfileHeaderView class] forHeaderFooterViewReuseIdentifier:[THLUserProfileHeaderView identifier]];
    [tableView registerClass:[THLUserProfileTableViewCell class] forCellReuseIdentifier:[THLUserProfileTableViewCell identifier]];
    [tableView registerClass:[THLUserProfileFooterView class] forHeaderFooterViewReuseIdentifier:[THLUserProfileFooterView identifier]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableCellNames count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case InviteFriends:
            [self handleInviteFriendsAction];
            break;
        case RedeemCode:
            [self presentCodeEntryView];
            break;
        case PaymentMethod:
            [self presentPaymentView];
            break;
        case PrivacyPolicy:
            [self presentModalInformationWithText:[THLResourceManager privacyPolicyText]
                                         andTitle:@"Privacy Policy"];
            break;
        case TermsAndConditions:
            [self presentModalInformationWithText:[THLResourceManager termsOfUseText]
                                         andTitle:@"Terms Of Use"];
            break;
        case ContactUs:
            [contactCommand execute:nil];
            break;
        case LogOut:
            [logoutCommand execute:nil];
            break;
        default: {
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)handleInviteFriendsAction {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    NSString *message = @"Check out this app that gets you into the hottest parties in NYC! Use invitation code 109109 to get started";
    NSString *shareBody = branchMarketingLink;
    
    NSArray *postItems = @[message, shareBody];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    [topController presentViewController:activityVC animated:YES completion:nil];
}

- (void)presentCodeEntryView {
    THLTextEntryViewController *invitationCodeEntryView = [self configureTextEntryView];
    [invitationCodeEntryView.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                             forBarMetrics:UIBarMetricsDefault];
    invitationCodeEntryView.navigationController.navigationBar.shadowImage = [UIImage new];
    invitationCodeEntryView.navigationController.navigationBar.translucent = YES;
    invitationCodeEntryView.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController pushViewController:invitationCodeEntryView animated:YES];
}


- (void)presentPaymentView
{
    [self.hud show:YES];
    [PFCloud callFunctionInBackground:@"retrievePaymentInfo"
                       withParameters:nil
                                block:^(NSArray<NSDictionary *> *cardInfo, NSError *cloudError) {
                                    [self.hud hide:YES];
                                    if (cloudError) {
        
                                    } else {
                                        THLPaymentViewController *paymentView = [[THLPaymentViewController alloc]initWithPaymentInfo:cardInfo];
                                        [self.navigationController pushViewController:paymentView animated:NO];
                                    }
                                }];

    
}


- (void)presentModalExplanationHowItWorks
{
    THLFAQViewController *faqVC = [[THLFAQViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:faqVC];
    [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
}

- (void) presentModalInformationWithText:(NSString *) text andTitle:(NSString *) title
{
    UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:_infoVC];
    _infoVC.displayText = text;
    _infoVC.title = title;
    [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
}
    
- (void) presentModalUserProfile
{
    if ([THLUser currentUser]) {
    THLUserPhotoVerificationViewController *userPhotoVerificationView = [[THLUserPhotoVerificationViewController alloc] initForNavigationController];
    userPhotoVerificationView.renewImageDelegate = self;
    UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:userPhotoVerificationView];
    [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = nil;
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    CGRect frame = CGRectMake(0, 0, ScreenWidth, height);
    THLUserProfileHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[THLUserProfileHeaderView identifier]];
    headerView = [[THLUserProfileHeaderView alloc] initWithFrame:frame];
    RAC(headerView, userImageURL) = RACObserve(self, userImageURL);
    RAC(headerView, userName) = RACObserve(self, userName);
    [[headerView.photoTapRecognizer rac_gestureSignal]
        subscribeNext:^(id x) {
           [self presentModalUserProfile];
    }];
     
    header = headerView;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    CGFloat height = [self tableView:tableView heightForFooterInSection:section];
    CGRect frame = CGRectMake(0, 0, ScreenWidth, height);
    THLUserProfileFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[THLUserProfileFooterView identifier]];
    footerView = [[THLUserProfileFooterView alloc] initWithFrame:frame];
    footerView.logoutCommand = self.logoutCommand;
    footerView.emailCommand = self.contactCommand;
    
    footer = footerView;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    THLUserProfileHeaderView *headerView = [THLUserProfileHeaderView new];
    return [headerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    THLUserProfileFooterView *footerView = [THLUserProfileFooterView new];
    return [footerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = kTHLNUIPrimaryBackgroundColor  ;
}

#pragma mark MSMailMessage
-(void)showMailView {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Contact Us"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@"hypeteam@thehypelist.co"]];
        mail.navigationBar.barStyle = UIBarButtonItemStylePlain;

        [[mail navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName :kTHLNUIPrimaryFontColor}];
        [[mail navigationBar] setTintColor:kTHLNUIPrimaryFontColor];
        [self.view.window.rootViewController presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

#pragma mark UIAlertView
-(void)alert:(NSString *)webSite{
    UIAlertView *aView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to visit: %@", webSite] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [aView show];
}

#pragma mark UIAlertViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THLUserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[THLUserProfileTableViewCell identifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[THLUserProfileTableViewCell alloc] init];
    }
    
//    cell.textLabel.text = [self.tableCellNames objectAtIndex:indexPath.row];
//    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
//    cell.backgroundColor = kTHLNUISecondaryBackgroundColor;
    cell.title = [self.tableCellNames objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == LogOut && ![THLUserManager userLoggedIn])
        return 0;
    else
        return 55;
}

#pragma mark - Constructors

- (UIBarButtonItem *)newBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Inbox Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
}

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
}


- (UITableView *)newTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    tableView.separatorColor = [UIColor clearColor];
    
//    tableView.bounces = NO;
//    tableView.alwaysBounceVertical = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    return tableView;
}

- (THLUserProfileInfoView *)newProfileInfoView {
    THLUserProfileInfoView *profileInfoView = [THLUserProfileInfoView new];
    return profileInfoView;
}

- (THLInformationViewController *)newInfoVC {
    THLInformationViewController *infoVC = [THLInformationViewController new];
    return infoVC;
}

- (THLTextEntryViewController *)configureTextEntryView
{
    THLTextEntryViewController *invitationCodeEntryView = [[THLTextEntryViewController alloc] initWithNibName:nil bundle:nil];
    invitationCodeEntryView.delegate = self;
    invitationCodeEntryView.titleText = @"Redeem Code";
    invitationCodeEntryView.descriptionText = @"Enter your code to redeem credits";
    invitationCodeEntryView.buttonText = @"Submit Code";
    invitationCodeEntryView.textLength = 6;
    invitationCodeEntryView.type = THLTextEntryTypeRedeemCode;
    return invitationCodeEntryView;
}


#pragma mark - THLTextViewEntryDelegate

- (void)codeEntryView:(THLTextEntryViewController *)view userDidSubmitRedemptionCode:(NSString *)code {
    [PFCloud callFunctionInBackground:@"redeemReferralCode"
                       withParameters:@{@"referralCode": code}
                                block:^(id approvedCode, NSError *cloudError) {
                                    NSString *title;
                                    NSString *message;
                                    
                                    if ([approvedCode  isEqual:@1]) {
                                        title = @"Success";
                                        message = @"You have successfully redeemed your code!";
                                    } else {
                                        title = @"Unsuccessful";
                                        message = @"This code is not valid";
                                    }
                                    
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                                    message:message
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                }];
}



#pragma mark Did Hide user photo varification interface

- (void) reloadUserImageWithURL:(NSURL *) imageURL{
    self.userImageURL = imageURL;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
