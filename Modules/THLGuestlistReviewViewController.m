//
//  THLGuestlistReviewViewController.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewViewController.h"
#import "THLViewDataSource.h"
#import "THLGuestlistReviewCell.h"
#import "THLGuestlistReviewCellViewModel.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "THLAppearanceConstants.h"

static UIEdgeInsets const COLLECTION_VIEW_EDGEINSETS = {kTHLInset, kTHLInset, kTHLInset, kTHLInset};
static CGFloat const CELL_SPACING = kTHLInset;

@interface THLGuestlistReviewViewController()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation THLGuestlistReviewViewController
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;
@synthesize backButton = _backButton;
@synthesize backCommand = _backCommand;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutView];
    [self configureBindings];
    [_refreshCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (void)constructView {
    _collectionView = [self newCollectionView];
    _backButton = [self newBackBarButtonItem];
}

- (void)layoutView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _collectionView = [self newCollectionView];
    self.navigationItem.leftBarButtonItem = _backButton;
    self.navigationItem.title = @"YOUR PARTY";
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

- (void)configureBindings {
    WEAKSELF();
    STRONGSELF();
    [RACObserve(self, dataSource) subscribeNext:^(id x) {
        [self configureDataSource];
    }];
    
    [RACObserve(WSELF, showRefreshAnimation) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [SSELF.collectionView.pullToRefreshView startAnimating];
        } else {
            [SSELF.collectionView.pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(WSELF, refreshCommand) subscribeNext:^(RACCommand *command) {
        [SSELF.collectionView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
}

- (void)configureDataSource {
    _collectionView.dataSource = _dataSource;
    _dataSource.collectionView = _collectionView;
    
    [_collectionView registerClass:[THLGuestlistReviewCell class] forCellWithReuseIdentifier:[THLGuestlistReviewCell identifier]];
    
    _dataSource.cellCreationBlock = (^id(id object, UICollectionView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLGuestlistReviewCellViewModel class]]) {
            return [parentView dequeueReusableCellWithReuseIdentifier:[THLGuestlistReviewCell identifier] forIndexPath:indexPath];
        }
        return nil;
    });
    
    _dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLGuestlistReviewCellViewModel class]] && [cell conformsToProtocol:@protocol(THLGuestlistReviewCellView)]) {
            [(THLGuestlistReviewCellViewModel *)object configureView:(id<THLGuestlistReviewCellView>)cell];
        }
    });
    
}

#pragma mark - Constructors
- (UICollectionView *)newCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.nuiClass = kTHLNUIBackgroundView;
    collectionView.alwaysBounceVertical = YES;
    collectionView.delegate = self;
    return collectionView;
}

- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:NULL];
    //	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction:)];
    
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([self contentViewWithInsetsWidth] - CELL_SPACING)/2.0;
    return CGSizeMake1(width);}

- (CGFloat)contentViewWithInsetsWidth {
    return ScreenWidth - (COLLECTION_VIEW_EDGEINSETS.left + COLLECTION_VIEW_EDGEINSETS.right);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return COLLECTION_VIEW_EDGEINSETS;
}

//- (THLActionBarButton *)newHostAcceptButton {
//    THLActionBarButton *button = [THLActionBarButton new];
//    button.userInteractionEnabled = NO;
//    [button setTitle:@"ACCEPT" animateChanges:NO];
//    button.backgroundColor = [button tealColor];
//    [button addTarget:self action:@selector(handleHostAcceptAction) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//    
//}
//
//- (THLActionBarButton *)newHostRejectButton {
//    THLActionBarButton *button = [THLActionBarButton new];
//    button.userInteractionEnabled = NO;
//    [button setTitle:@"REJECT" animateChanges:NO];
//    button.backgroundColor = [button redColor];
//    [button addTarget:self action:@selector(handleHostRejectAction) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//
//- (UIView *)newHostActionGuardView {
//    UIView *view = [UIView new];
//    //	UITapGestureRecognizer *tapGR = [UITapGestureRecognizer bk_performBlock:^{
//    //		[KVNProgress showWithStatus:@"Please review the entire guestlist before deciding!"];
//    //	} afterDelay:0];
//    //	[view addGestureRecognizer:tapGR];
//    return view;
//}

//- (UIView *)newHostActionContainerView {
//    self.hostAcceptButton = [self newHostAcceptButton];
//    self.hostRejectButton = [self newHostRejectButton];
//    self.hostActionGuardView = [self newHostActionGuardView];
//    
//    UIView *view = [UIView new];
//    [view addSubviews:@[self.hostAcceptButton,
//                        self.hostRejectButton,
//                        self.hostActionGuardView]];
//    
//    [self.hostAcceptButton makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.insets(UIEdgeInsetsZero);
//        make.right.equalTo(self.hostRejectButton.mas_left);
//        make.width.equalTo(self.hostRejectButton);
//    }];
//    
//    [self.hostRejectButton makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.insets(UIEdgeInsetsZero);
//    }];
//    
//    [self.hostActionGuardView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsZero);
//    }];
//    
//    return view;
//}

@end
