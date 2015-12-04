//
//  THLDashboardViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardViewController.h"
#import "THLDashboardNotificationCell.h"
#import "THLDashboardNotificationCellViewModel.h"
#import "THLViewDataSource.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "ORStackScrollView.h"

#import "THLAppearanceConstants.h"
#import "UIScrollView+EmptyDataSet.h"
#import "THLDashboardNotificationSectionTitleCell.h"
#import "THLDashboardTicketCell.h"
#import "THLDashboardTicketCellViewModel.h"
#import "THLGuestlistInviteEntity.h"

@interface THLDashboardViewController()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *acceptedSectionLabel;
@end

@implementation THLDashboardViewController
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize dataSource = _dataSource;
@synthesize refreshCommand = _refreshCommand;
@synthesize showRefreshAnimation = _showRefreshAnimation;

#pragma mark VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    [_refreshCommand execute:nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (void)constructView {
    _collectionView = [self newCollectionView];
    _scrollView = [self newScrollView];
    _acceptedSectionLabel = [self newAcceptedSectionLabel];
//    _eventTicketView = [self newEventTicketView];
}

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    WEAKSELF();
    [self.view addSubviews:@[_collectionView]];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.insets(kTHLEdgeInsetsNone());
        //      Temporary Fix to account for SLPagingViewController Height that is greater than Bounds Height
        make.bottom.equalTo(SV(WSELF.collectionView)).mas_offset(UIEdgeInsetsMake(0, 0, DiscoveryCellHeight(ViewWidth(WSELF.collectionView))/3.67, 0));
    }];
}

- (void)bindView {
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
    
    [RACObserve(WSELF, refreshCommand) subscribeNext:^(RACCommand *command) {
        [SSELF.collectionView addPullToRefreshWithActionHandler:^{
            [command execute:nil];
        }];
    }];
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (UILabel *)newAcceptedSectionLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.text = @"YOUR NEXT EVENT";
    label.alpha = 0.7;
    return label;
}

- (UICollectionView *)newCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 25);
    flowLayout.footerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 25);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    collectionView.nuiClass = kTHLNUIBackgroundView;
    collectionView.alwaysBounceVertical = YES;
    collectionView.delegate = self;
    return collectionView;
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
    _collectionView.dataSource = dataSource;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    dataSource.collectionView = _collectionView;
    
    [self.collectionView registerClass:[THLDashboardNotificationCell class] forCellWithReuseIdentifier:[THLDashboardNotificationCell identifier]];
    [self.collectionView registerClass:[THLDashboardTicketCell class] forCellWithReuseIdentifier:[THLDashboardTicketCell identifier]];
    [self.collectionView registerClass:[THLDashboardNotificationSectionTitleCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[THLDashboardNotificationSectionTitleCell identifier]];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"invisibleCell"];


    dataSource.cellCreationBlock = (^id(id object, UICollectionView* parentView, NSIndexPath *indexPath) {
        if ([object isKindOfClass:[THLDashboardNotificationCellViewModel class]]) {
            return [parentView dequeueReusableCellWithReuseIdentifier:[THLDashboardNotificationCell identifier] forIndexPath:indexPath];
        }
        else if ([object isKindOfClass:[THLDashboardTicketCellViewModel class]]) {
            return [parentView dequeueReusableCellWithReuseIdentifier:[THLDashboardTicketCell identifier] forIndexPath:indexPath];
        }
        return nil;
    });
    
    dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
        if ([object isKindOfClass:[THLDashboardNotificationCellViewModel class]] && [cell conformsToProtocol:@protocol(THLDashboardNotificationCellView)]) {
            [(THLDashboardNotificationCellViewModel *)object configureView:(id<THLDashboardNotificationCellView>)cell];
        }
        else if ([object isKindOfClass:[THLDashboardTicketCellViewModel class]] && [cell conformsToProtocol:@protocol(THLDashboardTicketCellView)]) {
            [(THLDashboardTicketCellViewModel *)object configureView:(id<THLDashboardTicketCellView>)cell];
        }
    });
}




#pragma mark - UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        THLDashboardNotificationSectionTitleCell *titleHeaderCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:[THLDashboardNotificationSectionTitleCell identifier]
                                                                                                              forIndexPath:indexPath];
        NSString *title = @"Pending Guestlist Invites";
        titleHeaderCell.titleText = title;
        titleHeaderCell.backgroundColor = kTHLNUIRedColor;
        reusableview = titleHeaderCell;
    } else if (kind == UICollectionElementKindSectionFooter) {
        THLDashboardNotificationSectionTitleCell *titleHeaderCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:[THLDashboardNotificationSectionTitleCell identifier]
                                                                                                              forIndexPath:indexPath];
        NSString *title = @"Pending Guestlist Invites";
        titleHeaderCell.titleText = title;
        titleHeaderCell.backgroundColor = kTHLNUIRedColor;
        reusableview = titleHeaderCell;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    THLGuestlistInviteEntity *guestlistInviteEntity = [[self dataSource] untransformedItemAtIndexPath:indexPath];
    if (guestlistInviteEntity.response == THLStatusPending) {
        return CGSizeMake(ViewWidth(collectionView) - 25, 125);
    } else {
        return CGSizeMake(ViewWidth(collectionView) - 25, 250);
    }
}

#pragma mark - EmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"You do not have any upcoming events";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Please create a Guestlist for an Event or if you are invited to an Event, it will show up here";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUIPrimaryBackgroundColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: kTHLNUIActionColor,
                                 };
    
    return [[NSAttributedString alloc] initWithString:@"Refresh" attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
//    [_refreshCommand execute:nil];
    [_collectionView reloadData];
}

//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
//{
//    return YES;
//}
@end

