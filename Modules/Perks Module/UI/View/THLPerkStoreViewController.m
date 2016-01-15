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
#import "THLActionBarButton.h"

@interface THLPerkStoreViewController ()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@property (nonatomic, strong) UILabel *userCreditsLabel;
@property (nonatomic, strong) NSString *userCredits;
@end

@implementation THLPerkStoreViewController
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

- (void)constructView {
    _labelOne = [self newLabelWithText:@"Your credits balance is" withConstant:kTHLNUIRegularTitle];
    _labelTwo = [self newLabelWithText:@"Earn credits every time you invite friends\nto attend an event. Then use those credits\nto purchase rewards here"
                          withConstant:kTHLNUIDetailTitle];
    _userCreditsLabel = [self newCreditsLabelWithText:NSStringWithFormat(@"$%@", _userCredits)];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationController.navigationBar.topItem.title = @"PERKS";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _collectionView = [self newCollectionView];
    [self.view addSubviews:@[_labelOne, _labelTwo, _userCreditsLabel, _collectionView]];
    
    WEAKSELF();
    [_labelOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_userCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.labelOne.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.right.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_labelTwo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.userCreditsLabel.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];

    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.labelTwo.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(kTHLEdgeInsetsNone());

    }];
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
            [SSELF.collectionView.pullToRefreshView startAnimating];
        } else {
            [SSELF.collectionView.pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(WSELF, currentUserCredit) subscribeNext:^(id x) {
        float credits = [x floatValue];
        SSELF.userCreditsLabel.text = [self formattedStringWithDecimal:[[NSNumber alloc]initWithFloat:credits]];
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


//- (THLActionBarButton *)newBarButton {
//    THLActionBarButton *barButton = [THLActionBarButton new];
//    barButton.backgroundColor = kTHLNUIAccentColor;
//    [barButton.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW MY REWARDS", nil)];
//    return barButton;
//}


- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel X Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
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
    return CGSizeMake((ViewWidth(collectionView)), ViewWidth(collectionView)/4);
}

@end
