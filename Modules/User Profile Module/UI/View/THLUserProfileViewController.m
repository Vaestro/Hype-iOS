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
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *tableCellNames;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, strong) THLInformationViewController *infoVC;
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
    
    self.urls = [[NSArray alloc]initWithObjects:@"https://hypelist.typeform.com/to/zGLp4N", @"https://hypelist.typeform.com/to/v01VE8", nil];
    self.tableCellNames = [[NSArray alloc]initWithObjects:@"Become a Host", @"Let Hypelist Plan Your Party", @"Privacy Policy", @"Terms & Conditions", nil];
}

#pragma mark - View Setup
- (void)constructView {
    _tableView = [self newTableView];
    _infoVC = [self newInfoVC];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;

    [self.view addSubviews:@[_tableView]];
    self.navigationItem.title = @"MY ACCOUNT";

    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.insets(kTHLEdgeInsetsNone());
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
        case 0: {
            self.siteUrl = [self.urls objectAtIndex:indexPath.row];
            [self alert:[self.urls objectAtIndex:indexPath.row]];
            break;
        }
        case 1: {
            self.siteUrl = [self.urls objectAtIndex:1];
            [self alert:[self.urls objectAtIndex:1]];
            break;
        }
        case 2: {
            UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:_infoVC];
            [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
            _infoVC.displayText = [THLResourceManager privacyPolicyText];
            _infoVC.title = @"Privacy Policy";
            break;
        }
        case 3: {
            UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:_infoVC];
            [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
            _infoVC.displayText = [THLResourceManager termsOfUseText];
            _infoVC.title = @"Terms Of Use";
            break;
        }
        default: {
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    CGRect frame = CGRectMake(0, 0, ScreenWidth, height);
    THLUserProfileHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[THLUserProfileHeaderView identifier]];
    headerView = [[THLUserProfileHeaderView alloc] initWithFrame:frame];
    RAC(headerView, userImageURL) = RACObserve(self, userImageURL);
    RAC(headerView, userName) = RACObserve(self, userName);

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
    CGFloat headerHeight = 0;
    THLUserProfileHeaderView *headerView = [THLUserProfileHeaderView new];
    headerHeight = [headerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //  TODO: Temporarily set header to nil due to issue with displaying user profile picture

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerHeight = 0;
    THLUserProfileFooterView *footerView = [THLUserProfileFooterView new];
    footerHeight = [footerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return footerHeight;
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
    cell.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TODO: Temporary hack to make sure table cells are shown on Iphone 5 
    return 60;
}

#pragma mark - Constructors
- (UITableView *)newTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    tableView.separatorColor = [UIColor clearColor];
//    tableView.scrollEnabled = NO;
    tableView.bounces = YES;
    tableView.alwaysBounceVertical = YES;
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


@end
