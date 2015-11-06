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
#import "THLActionContainerView.h"
#import "SVProgressHUD.h"
#import "THLConfirmationPopupView.h"
#import "KLCPopup.h"

static UIEdgeInsets const COLLECTION_VIEW_EDGEINSETS = {kTHLInset, kTHLInset, kTHLInset, kTHLInset};
static CGFloat const CELL_SPACING = kTHLInset;

@interface THLGuestlistReviewViewController()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) THLActionContainerView *actionContainerView;
@property (nonatomic, strong) THLConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@end

@implementation THLGuestlistReviewViewController
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;
@synthesize dismissCommand = _dismissCommand;
@synthesize acceptCommand = _acceptCommand;
@synthesize declineCommand = _declineCommand;
@synthesize confirmCommand = _confirmCommand;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize reviewerStatus = _reviewerStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    [_refreshCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (void)constructView {
    _collectionView = [self newCollectionView];
    _dismissButton = [self newBackBarButtonItem];
    _actionContainerView = [self newActionContainerView];
    _confirmationPopupView = [self newConfirmationPopupView];
}

- (void)layoutView {
    [self.view addSubviews:@[_collectionView, _actionContainerView]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = @"YOUR PARTY";
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsNone());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_actionContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(_collectionView.mas_bottom);
    }];
}

- (void)bindView {
    WEAKSELF();
    STRONGSELF();
    [RACObserve(WSELF, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [SSELF configureDataSource:dataSource];
    }];
    
    RAC(WSELF.dismissButton, rac_command) = RACObserve(WSELF, dismissCommand);

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
    
    RAC(WSELF.actionContainerView.acceptButton, rac_command) = RACObserve(WSELF, acceptCommand);
    RAC(WSELF.actionContainerView.declineButton, rac_command) = RACObserve(WSELF, confirmCommand);
    RAC(WSELF.confirmationPopupView, confirmCommand) = RACObserve(WSELF, declineCommand);

    [RACObserve(WSELF, showActivityIndicator) subscribeNext:^(id _) {
        switch (_showActivityIndicator) {
            case 0:
                [SVProgressHUD dismiss];
                break;
            case 1:
                [SVProgressHUD show];
                break;
            case 2:
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
                break;
            case 3:
                [SVProgressHUD showErrorWithStatus:@"Error!"];
                break;
            default:
                break;
        }
    }];
    
    [RACObserve(self, reviewerStatus) subscribeNext:^(id _) {
        if (_reviewerStatus == THLGuestlistReviewerStatusAttendingGuest) {
            _actionContainerView.status = THLActionContainerViewStatusDecline;
            [_actionContainerView reloadView];
            [_actionContainerView.declineButton.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"LEAVE GUESTLIST", nil)];
            RAC(_actionContainerView.declineButton, rac_command) = RACObserve(WSELF, confirmCommand);
        }
        [WSELF.view setNeedsDisplay];
    }];
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
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
    collectionView.backgroundColor = kTHLNUISecondaryBackgroundColor;
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

- (THLActionContainerView *)newActionContainerView {
    THLActionContainerView *actionContainerView = [THLActionContainerView new];
    actionContainerView.backgroundColor = kTHLNUISecondaryBackgroundColor;
    return actionContainerView;
}

- (THLConfirmationPopupView *)newConfirmationPopupView {
    THLConfirmationPopupView *confirmationPopupView = [THLConfirmationPopupView new];
    return confirmationPopupView;
}

#pragma mark - Action Guard
- (void)confirmActionWithMessage:(NSString *)text {
    KLCPopup *popup = [KLCPopup popupWithContentView:_confirmationPopupView
                                            showType:KLCPopupShowTypeBounceIn
                                         dismissType:KLCPopupDismissTypeBounceOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    _confirmationPopupView.confirmationText = text;
    [popup show];
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

@end
