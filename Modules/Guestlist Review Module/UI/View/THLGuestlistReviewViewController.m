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
#import "THLActionContainerView.h"
#import "THLConfirmationPopupView.h"
#import "THLMenuView.h"

#import "THLAppearanceConstants.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "SVProgressHUD.h"
#import "KLCPopup.h"

static UIEdgeInsets const COLLECTION_VIEW_EDGEINSETS = {10, 10, 10, 10};
static CGFloat const CELL_SPACING = 10;

@interface THLGuestlistReviewViewController()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) THLActionContainerView *actionContainerView;
@property (nonatomic, strong) THLActionBarButton *actionBarButton;
@property (nonatomic, strong) THLConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (nonatomic, strong) THLMenuView *menuView;
@end

@implementation THLGuestlistReviewViewController
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;
@synthesize dismissCommand = _dismissCommand;
@synthesize acceptCommand = _acceptCommand;
@synthesize declineCommand = _declineCommand;
@synthesize decisionCommand = _decisionCommand;
@synthesize showMenuCommand = _showMenuCommand;
@synthesize menuAddCommand = _menuAddCommand;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize reviewerStatus = _reviewerStatus;
@synthesize popup = _popup;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
//    [_refreshCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_refreshCommand execute:nil];
}

- (void)constructView {
    _collectionView = [self newCollectionView];
    _dismissButton = [self newBackBarButtonItem];
    _menuButton = [self newMenuBarButtonItem];
//    _actionContainerView = [self newActionContainerView];
    _actionBarButton = [self newActionBarButton];
    _confirmationPopupView = [self newConfirmationPopupView];
}


- (void)showGuestlistMenuView:(UIView *)menuView {
    [self.parentViewController.view addSubview:menuView];
    [menuView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:menuView];
}

- (void)hideGuestlistMenuView:(UIView *)menuView {
    [menuView removeFromSuperview];
}


- (void)layoutView {
    [self.view addSubviews:@[_collectionView, _actionBarButton]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.rightBarButtonItem = _menuButton;
    self.navigationItem.title = @"YOUR PARTY";
    
    WEAKSELF();
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsNone());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_actionBarButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF collectionView].mas_bottom);
    }];
}

- (void)bindView {
    WEAKSELF();
    [RACObserve(self, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [WSELF configureDataSource:WSELF.dataSource];
    }];
    
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
    

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
    
//    RAC([self.actionContainerView acceptButton], rac_command) = RACObserve(self, acceptCommand);
//    RAC([self.actionContainerView declineButton], rac_command) = RACObserve(self, declineCommand);
    RAC(self.actionBarButton, rac_command) = RACObserve(self, decisionCommand);
    RAC(self.confirmationPopupView, acceptCommand) = RACObserve(self, acceptCommand);
    RAC(self.confirmationPopupView, declineCommand) = RACObserve(self, declineCommand);
    RAC(self.menuButton, rac_command) = RACObserve(self, showMenuCommand);

    [RACObserve(self, showActivityIndicator) subscribeNext:^(id _) {
        switch (WSELF.showActivityIndicator) {
            case THLActivityStatusNone:
                [SVProgressHUD dismiss];
                break;
            case THLActivityStatusInProgress:
                [SVProgressHUD show];
                break;
            case THLActivityStatusSuccess:
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
                break;
            case THLActivityStatusError:
                [SVProgressHUD showErrorWithStatus:@"Error!"];
                break;
            default:
                break;
        }
    }];
    
    [RACObserve(self, reviewerStatus) subscribeNext:^(NSNumber *status) {
        if (status == [NSNumber numberWithInteger:0]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Accept or Decline Invite", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
        }
        else if (status == [NSNumber numberWithInteger:1]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"LEAVE GUESTLIST", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIRedColor;
        }
        else if (status == [NSNumber numberWithInteger:2]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"ADD GUESTS", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
        }
        else if (status == [NSNumber numberWithInteger:3]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Accept or Decline Guestlist", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
        }
        else if (status == [NSNumber numberWithInteger:4]) {
            [[WSELF actionBarButton].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Party is Accepted!", nil)];
            [WSELF actionBarButton].backgroundColor = kTHLNUIAccentColor;
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
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (UIBarButtonItem *)newMenuBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;

}

//- (THLActionContainerView *)newActionContainerView {
//    THLActionContainerView *actionContainerView = [THLActionContainerView new];
//    actionContainerView.backgroundColor = kTHLNUISecondaryBackgroundColor;
//    return actionContainerView;
//}

- (THLActionBarButton *)newActionBarButton {
    THLActionBarButton *actionBarButton = [THLActionBarButton new];
    [actionBarButton.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Accept or Decline Invite", nil)];
    return actionBarButton;
}

- (THLConfirmationPopupView *)newConfirmationPopupView {
    THLConfirmationPopupView *confirmationPopupView = [THLConfirmationPopupView new];
    return confirmationPopupView;
}

#pragma mark - Action Guard
- (void)confirmActionWithMessage:(NSString *)text acceptTitle:(NSString *)acceptTitle declineTitle:(NSString *)declineTitle {
    _popup = [KLCPopup popupWithContentView:_confirmationPopupView
                                            showType:KLCPopupShowTypeBounceIn
                                         dismissType:KLCPopupDismissTypeBounceOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    _confirmationPopupView.confirmationText = text;
    [_confirmationPopupView.acceptButton setTitle:acceptTitle animateChanges:NO];
    [_confirmationPopupView.declineButton setTitle:declineTitle animateChanges:NO];
    _popup.dimmedMaskAlpha = 0.9;
    [_popup show];
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

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
