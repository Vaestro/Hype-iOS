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
#import "THLActionBarButton.h"
#import "THLGuestlistReviewHeaderView.h"
#import "THLMenuView.h"

#import "THLAppearanceConstants.h"
#import "UIScrollView+SVPullToRefresh.h"

#import "UIView+DimView.h"
#import <KVNProgress/KVNProgress.h>
#import "THLGuestlistTicketView.h"


#define kGKHeaderHeight 150
#define headerViewHeightCondensed = 20

static UIEdgeInsets const COLLECTION_VIEW_EDGEINSETS = {10, 10, 10, 10};
static CGFloat const CELL_SPACING = 10;

@interface THLGuestlistReviewViewController()

@property (nonatomic, strong) THLGuestlistReviewHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIBarButtonItem *menuButton;

@property (nonatomic, strong) THLActionBarButton *actionBarButton;
@property (nonatomic, strong) UIButton *dismissButton;
@end

@implementation THLGuestlistReviewViewController
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;
@synthesize acceptCommand = _acceptCommand;
@synthesize declineCommand = _declineCommand;
@synthesize responseCommand = _responseCommand;
@synthesize menuAddCommand = _menuAddCommand;
@synthesize reviewerStatus = _reviewerStatus;
@synthesize viewAppeared;

@synthesize title = _title;
@synthesize formattedDate = _formattedDate;
@synthesize headerViewImage = _headerViewImage;
@synthesize dismissCommand = _dismissCommand;
@synthesize showMenuCommand = _showMenuCommand;
@synthesize guestlistReviewStatus = _guestlistReviewStatus;
@synthesize guestlistReviewStatusTitle = _guestlistReviewStatusTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewAppeared = TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = FALSE;
}

- (void)constructView {
    _headerView = [self newHeaderView];
    _collectionView = [self newCollectionView];
    _actionBarButton = [self newActionBarButton];
    _menuButton = [self newMenuButton];
}

//--------------------------------------------------
# pragma mark - show/hide guestlist menu
- (void)showGuestlistMenuView:(UIView *)menuView {
    [self.navigationController.view addSubview:menuView];
    [menuView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:menuView];
}

- (void)hideGuestlistMenuView:(UIView *)menuView {
    [menuView removeFromSuperview];
}

- (void)showResponseView:(UIView *)responseView {
    [self.view addSubview:responseView];
    [responseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:responseView];
}

- (void)hideActionBar {
    
    [[self actionBarButton] setHidden:TRUE];
    [self remakeConstraints];
}
//---------------------------------------------------

- (void)layoutView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.rightBarButtonItem = _menuButton;

    [self.view addSubviews:@[_collectionView, _actionBarButton]];

    WEAKSELF();

    if (self.navigationController) {
        [_collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.insets(kTHLEdgeInsetsNone());
        }];
    } else {
        [self.view addSubview:_headerView];
        [_headerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(kTHLEdgeInsetsNone());
        }];
        
        [_collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF headerView].mas_bottom);
            make.left.right.insets(kTHLEdgeInsetsNone());
        }];
    }

    

    
    [_actionBarButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF collectionView].mas_bottom);
    }];
}

- (void)remakeConstraints {
    WEAKSELF();
    [_collectionView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.headerView.mas_bottom);
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.headerView, title) = RACObserve(self, title);
//    RAC(self.headerView, formattedDate) = RACObserve(self, formattedDate);
    RAC(self.headerView, headerViewImage) = RACObserve(self, headerViewImage);
    RAC(self.headerView, dismissCommand) = RACObserve(self, dismissCommand);
    RAC(self.headerView, showMenuCommand) = RACObserve(self, showMenuCommand);
    RAC(self.headerView, formattedDate) = RACObserve(self, formattedDate);
    RAC(self.headerView, guestlistReviewStatusTitle) = RACObserve(self, guestlistReviewStatusTitle);
    RAC(self.headerView, guestlistReviewStatus) = RACObserve(self, guestlistReviewStatus);

    [RACObserve(self, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [WSELF configureDataSource:WSELF.dataSource];
    }];

    [RACObserve(self, showRefreshAnimation) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [[WSELF collectionView].pullToRefreshView startAnimating];
        } else {
            [[WSELF collectionView].pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(self, refreshCommand) subscribeNext:^(RACCommand *command) {
        [WSELF.collectionView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
    
    RAC(self.actionBarButton, rac_command) = RACObserve(self, responseCommand);
    RAC(self.menuButton, rac_command) = RACObserve(self, showMenuCommand);

    [RACObserve(self, reviewerStatus) subscribeNext:^(NSNumber *status) {
        if (status == [NSNumber numberWithInteger:0]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Accept or Decline Invite", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
            [[WSELF.headerView menuButton] setHidden:TRUE];
        }
        else if (status == [NSNumber numberWithInteger:1]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Check In", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIActionColor;
            [[WSELF.headerView menuButton] setHidden:FALSE];

        }
        else if (status == [NSNumber numberWithInteger:2]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Check In", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIActionColor;
            [[WSELF.headerView menuButton] setHidden:FALSE];
        }
        else if (status == [NSNumber numberWithInteger:3]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Accept or Decline Guestlist", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
            [[WSELF.headerView menuButton] setHidden:TRUE];
        }
        else if (status == [NSNumber numberWithInteger:4]) {
            [[WSELF actionBarButton] setHidden:TRUE];
            [[WSELF.headerView menuButton] setHidden:TRUE];
            [self remakeConstraints];
        }
        else if (status == [NSNumber numberWithInteger:5]) {
            [[WSELF actionBarButton] setHidden:TRUE];
            [[WSELF.headerView menuButton] setHidden:TRUE];
            [self remakeConstraints];
        }
        else if (status == [NSNumber numberWithInteger:6]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Checked In", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
            [[WSELF.headerView menuButton] setHidden:FALSE];
        }
        else if (status == [NSNumber numberWithInteger:7]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Checked In", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
            [[WSELF.headerView menuButton] setHidden:FALSE];
        }
        else if (status == [NSNumber numberWithInteger:8]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Pending Host Approval", nil)];
            [[WSELF.headerView menuButton] setHidden:FALSE];
        }
        else if (status == [NSNumber numberWithInteger:9]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Pending Host Approval", nil)];
            [[WSELF.headerView menuButton] setHidden:FALSE];
        }
        [WSELF.view setNeedsDisplay];
    }];
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _collectionView.dataSource = dataSource;
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
- (THLGuestlistReviewHeaderView *)newHeaderView {
    THLGuestlistReviewHeaderView *headerView = [THLGuestlistReviewHeaderView new];
    return headerView;
}

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

- (THLActionBarButton *)newActionBarButton {
    THLActionBarButton *actionBarButton = [THLActionBarButton new];
    return actionBarButton;
}

- (UIBarButtonItem *)newMenuButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([self contentViewWithInsetsWidth] - CELL_SPACING)/2.0;
    return CGSizeMake(width, width + 10);}

- (CGFloat)contentViewWithInsetsWidth {
    return ScreenWidth - (COLLECTION_VIEW_EDGEINSETS.left + COLLECTION_VIEW_EDGEINSETS.right);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return COLLECTION_VIEW_EDGEINSETS;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
