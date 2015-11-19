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
@property (nonatomic, strong) THLUserProfileInfoView *profileInfoView;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *tableCellNames;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, strong) THLInformationViewController *infoVC;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) RACCommand *dismissVC;
@end

@implementation THLUserProfileViewController
@synthesize selectedIndexPathCommand;
@synthesize userName;
@synthesize userImageURL;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    
    self.urls = [[NSArray alloc]initWithObjects:@"https://hypelist.typeform.com/to/zGLp4N", @"https://hypelist.typeform.com/to/v01VE8", nil];
    self.tableCellNames = [[NSArray alloc]initWithObjects:@"Become a Host",@"Let Hypelist Plan Your Party", @"Privacy Policy",@"Terms & Conditions",@"Logout", nil];
}

#pragma mark - View Setup
- (void)constructView {
    _tableView = [self newTableView];
    _profileInfoView = [self newProfileInfoView];
    _infoVC = [self newInfoVC];
}

- (void)layoutView {
    [self.view addSubviews:@[_tableView,
                             _profileInfoView]];
    
    WEAKSELF();
    [_profileInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF tableView].mas_top).insets(kTHLEdgeInsetsNone());
        make.height.equalTo(200);
    }];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    [self configureDataSource];
    RAC(self.profileInfoView, userImageURL) = RACObserve(self, userImageURL);
    RAC(self.profileInfoView, userName) = RACObserve(self, userName);
}

- (void)configureDataSource {
    [self registerCellsForTableView:_tableView];
}

- (void)registerCellsForTableView:(UITableView *)tableView {
    [tableView registerClass:[THLUserProfileTableViewCell class] forCellReuseIdentifier:[THLUserProfileTableViewCell identifier]];
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
            self.siteUrl = [self.urls objectAtIndex:indexPath.row];
            [self alert:[self.urls objectAtIndex:indexPath.row]];
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
        case 4: {
            [selectedIndexPathCommand execute:indexPath];
        }
        default: {
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark UIAlertView
-(void)alert:(NSString *)webSite{
    
    UIAlertView *aView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to visit: %@", webSite] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [aView show];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        //Ok button was selected
        
//        THLWebViewController *webView = [THLWebViewController new];
//        webView.url = [NSURL URLWithString:self.siteUrl];
//        [self presentViewController:webView animated:YES completion:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.siteUrl]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THLUserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[THLUserProfileTableViewCell identifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[THLUserProfileTableViewCell alloc] init];
    }
    
    cell.textLabel.text = [self.tableCellNames objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TODO: Temporary hack to make sure table cells are shown on Iphone 5 
    return SCREEN_HEIGHT * 0.067;
}

#pragma mark - Constructors
- (UITableView *)newTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    tableView.separatorColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
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
