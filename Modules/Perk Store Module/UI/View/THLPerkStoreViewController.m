//
//  THLPerkStoreViewController.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreViewController.h"
#import "THLAppearanceConstants.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "THLViewDataSource.h"
#import "THLPerkStoreCell.h"
#import "THLPerkStoreCellViewModel.h"
#import "THLUser.h"
#import "THLActionButton.h"
#import "THLCreditsExplanationView.h"

@interface THLPerkStoreViewController ()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) THLCreditsExplanationView *creditsExplanationView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) THLActionButton *earnMoreCreditsButton;
@property (nonatomic, strong) UILabel *userCreditsLabel;
@property (nonatomic, strong) NSString *userCredits;
@end

@implementation THLPerkStoreViewController
@synthesize showCreditsExplanationView = _showCreditsExplanationView;
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;
@synthesize currentUserCredit = _currentUserCredit;
@synthesize viewAppeared;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self configureBindings];
    [_refreshCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
    self.viewAppeared = TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = FALSE;
}

- (void)presentCreditsExplanationView {
    _creditsExplanationView = [THLCreditsExplanationView new];
    [self.tabBarController.view addSubview:_creditsExplanationView];
    [_creditsExplanationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    [self.tabBarController.view bringSubviewToFront:_creditsExplanationView];
}

- (void)constructView {
    _labelOne = [self newLabelWithText:@"Your credits balance is" withConstant:kTHLNUIRegularTitle];
    _earnMoreCreditsButton = [self newEarnMoreCreditsButton];
    _userCreditsLabel = [self newCreditsLabelWithText:NSStringWithFormat(@"$%@", _userCredits)];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationController.navigationBar.topItem.title = @"PERKS";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _collectionView = [self newCollectionView];
    [self.view addSubviews:@[_labelOne, _userCreditsLabel, _collectionView]];
    
    WEAKSELF();
    [_labelOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_userCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.labelOne.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.right.left.insets(kTHLEdgeInsetsNone());
    }];
    
//    [_earnMoreCreditsButton makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(WSELF.userCreditsLabel.mas_bottom).insets(kTHLEdgeInsetsHigh());
//        make.size.equalTo(CGSizeMake(SCREEN_WIDTH*0.80, 50));
//        make.centerX.equalTo(0);
//    }];

    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.userCreditsLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(kTHLEdgeInsetsNone());
    }];
}


- (void)configureBindings {
    WEAKSELF();
    STRONGSELF();
//    RAC(self.earnMoreCreditsButton, rac_command) = RACObserve(self, showCreditsExplanationView);
    _earnMoreCreditsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self presentCreditsExplanationView];
        return [RACSignal empty];
    }];
    
    [RACObserve(WSELF, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [SSELF configureDataSource:dataSource];
    }];
    
    [RACObserve(WSELF, showRefreshAnimation) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [SSELF.collectionView.pullToRefreshView startAnimating];
        } else {
            [SSELF.collectionView.pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(WSELF, currentUserCredit) subscribeNext:^(id x) {
        float credits = [x floatValue];
        SSELF.userCreditsLabel.text = [SSELF formattedStringWithDecimal:[[NSNumber alloc]initWithFloat:credits]];
    }];
    
    [RACObserve(WSELF, refreshCommand) subscribeNext:^(RACCommand *command) {
        [SSELF.collectionView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
}

#pragma mark - Constructors
- (UICollectionView *)newCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.nuiClass = kTHLNUIBackgroundView;
    collectionView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    collectionView.alwaysBounceVertical = YES;
    collectionView.delegate = self;
    return collectionView;
}

- (UILabel *)newLabelWithText:(NSString *)text withConstant:(NSString *)constant  {
    UILabel *label = THLNUILabel(constant);
    label.text = text;
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 4;
    label.minimumScaleFactor = 1;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newCreditsLabelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    [label setFont:[UIFont systemFontOfSize:30 weight:0.5]];
    label.textColor = kTHLNUIAccentColor;
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 2;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (THLActionButton *)newEarnMoreCreditsButton {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"Earn more credits"];
    return button;
}


- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [barButtonItem setTintColor:[UIColor whiteColor]];
    return barButtonItem;
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _collectionView.dataSource = dataSource;
    dataSource.collectionView = _collectionView;
    
    [self.collectionView registerClass:[THLPerkStoreCell class] forCellWithReuseIdentifier:[THLPerkStoreCell identifier]];
    
    dataSource.cellCreationBlock = (^id(id object, UICollectionView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLPerkStoreCellViewModel class]]) {
            return [parentView dequeueReusableCellWithReuseIdentifier:[THLPerkStoreCell identifier] forIndexPath:indexPath];
        }
        return nil;
    });
    
    dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLPerkStoreCellViewModel class]] && [cell conformsToProtocol:@protocol(THLPerkStoreCellView)]) {
            [(THLPerkStoreCellViewModel *)object configureView:(id<THLPerkStoreCellView>)cell];
        }
    });
}

- (NSString *)formattedStringWithDecimal:(NSNumber *)decimalNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2]; //two deimal spaces
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp]; //round up
    
    
    NSString *result =[NSString stringWithString:[formatter stringFromNumber:decimalNumber]];
    return result;
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ViewWidth(collectionView)), ViewWidth(collectionView)*0.33);
}

@end
