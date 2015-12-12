//
//  THLPerksViewController.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerksViewController.h"
#import "THLAppearanceConstants.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "THLViewDataSource.h"
#import "THLPerksCell.h"
#import "THLPerksCellViewModel.h"

@interface THLPerksViewController ()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
//@property (nonatomic, strong) THLPerkUserInfoView *userPerkInfoView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@property (nonatomic, strong) UILabel *userCreditsLabel;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@end

@implementation THLPerksViewController
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;
@synthesize dismissCommand = _dismissCommand;


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
}

- (void)constructView {
    _backButton = [self newBackBarButtonItem];
    _labelOne = [self newLabelWithText:@"Your credits balance is" withConstant:kTHLNUIRegularTitle];
    _labelTwo = [self newLabelWithText:@"Earn credits every time you invite friends to attend an event. Then use those credits to purchase rewards here" withConstant:kTHLNUIDetailTitle];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = _backButton;
    self.navigationItem.title = @"PERKS";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    _collectionView = [self newCollectionView];
    [self.view addSubviews:@[_labelOne, _labelTwo, _collectionView]];
    
//    [_userPerkInfoView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.bottom.insets(kTHLEdgeInsetsNone());
//    }];
    WEAKSELF();
    [_labelOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_labelTwo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.labelOne.mas_bottom);
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];

    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.labelTwo.mas_bottom);
        make.left.right.bottom.insets(kTHLEdgeInsetsHigh());
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
    
    RAC(self.backButton, rac_command) = RACObserve(self, dismissCommand);
    
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
    label.numberOfLines = 2;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;

}


- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel X Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [barButtonItem setTintColor:[UIColor whiteColor]];
    return barButtonItem;
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _collectionView.dataSource = dataSource;
    dataSource.collectionView = _collectionView;
    
    [self.collectionView registerClass:[THLPerksCell class] forCellWithReuseIdentifier:[THLPerksCell identifier]];
    
    dataSource.cellCreationBlock = (^id(id object, UICollectionView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLPerksCellViewModel class]]) {
            return [parentView dequeueReusableCellWithReuseIdentifier:[THLPerksCell identifier] forIndexPath:indexPath];
        }
        return nil;
    });
    
    dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLPerksCellViewModel class]] && [cell conformsToProtocol:@protocol(THLPerkCellView)]) {
            [(THLPerksCellViewModel *)object configureView:(id<THLPerkCellView>)cell];
        }
    });
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ViewWidth(collectionView)), ViewWidth(collectionView)/4);
}

@end
