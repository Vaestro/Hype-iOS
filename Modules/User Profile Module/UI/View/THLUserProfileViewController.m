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
#import "THLWebViewController.h"
#import "THLResourceManager.h"
#import "THLUserProfileFooterView.h"
#import "THLUserProfileHeaderView.h"
#import "THLUserPhotoVerificationViewController.h"
#import "THLFAQViewController.h"
#import "THLUserManager.h"
#import "THLUser.h"

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
    HowItWorks = 0,
    PrivacyPolicy,
    TermsAndConditions,
    ContactUs,
    LogOut
};

static NSString *const kTHLUserProfileViewCellIdentifier = @"kTHLUserProfileViewCellIdentifier";

@interface THLUserProfileViewController() <THLUserPhotoVerificationInterfaceDidHideDelegate>

@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *tableCellNames;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, strong) THLInformationViewController *infoVC;
#warning need to examine if this controller shold exist like instanse variable
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) RACCommand *dismissVC;
@end

@implementation THLUserProfileViewController
@synthesize selectedIndexPathCommand;
@synthesize contactCommand;
@synthesize logoutCommand;
@synthesize userName;
@synthesize userImageURL;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    
    self.tableCellNames = @[@"How it works", @"Privacy Policy", @"Terms & Conditions", @"Contact Us", @"Logout"];
}

#pragma mark - View Setup
- (void)constructView {
    _tableView = [self newTableView];
    _infoVC = [self newInfoVC];
}

- (void)layoutView {
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;

    [self.view addSubviews:@[_tableView]];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.insets(UIEdgeInsetsZero);
    }];
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
        case HowItWorks:
            [self presentModalExplanationHowItWorks];
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

- (void) presentModalExplanationHowItWorks {
    THLFAQViewController *faqVC = [[THLFAQViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:faqVC];
    [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
}

- (void) presentModalInformationWithText:(NSString *) text andTitle:(NSString *) title{
    UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:_infoVC];
    _infoVC.displayText = text;
    _infoVC.title = title;
    [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
}
    
- (void) presentModalUserProfile {
    if ([THLUser currentUser]) {
    THLUserPhotoVerificationViewController *userPhotoVerificationView = [[THLUserPhotoVerificationViewController alloc] initForNavigationController];
    userPhotoVerificationView.renewImageDelegate = self;
    UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:userPhotoVerificationView];
    [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    cell.backgroundColor = kTHLNUISecondaryBackgroundColor  ;
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
    
    cell.textLabel.text = [self.tableCellNames objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == LogOut && ![THLUserManager userLoggedIn])
        return 0;
    else if(indexPath.row == HowItWorks)
//        TODO: Show HowItWorks Tab when the section is completed
        return 0;
    else
        return 60;
}

#pragma mark - Constructors
- (UITableView *)newTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    tableView.separatorColor = [UIColor clearColor];
//    tableView.bounces = YES;
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

#pragma mark Did Hide user photo varification interface

- (void) reloadUserImageWithURL:(NSURL *) imageURL{
    self.userImageURL = imageURL;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
