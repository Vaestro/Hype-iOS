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
#import "THLDashboardNotificationSectionTitleCell.h"
#import "THLDashboardTicketCell.h"
#import "THLDashboardTicketCellViewModel.h"
#import "THLGuestlistInviteEntity.h"
#import "THLUser.h"

@interface THLDashboardViewController()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *acceptedSectionLabel;
@end

@implementation THLDashboardViewController

#pragma mark VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
//    [_refreshCommand execute:nil];
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
    _collectionView = [self newCollectionView];
    _scrollView = [self newScrollView];
    _acceptedSectionLabel = [self newAcceptedSectionLabel];
//    _eventTicketView = [self newEventTicketView];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.title = @"MY EVENTS";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubviews:@[_collectionView]];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    WEAKSELF();
    [RACObserve(self, dataSource) subscribeNext:^(THLViewDataSource *dataSource) {
        [WSELF configureDataSource:dataSource];
    }];
    
    [RACObserve(self, showRefreshAnimation) subscribeNext:^(NSNumber *val) {
        BOOL shouldAnimate = [val boolValue];
        if (shouldAnimate) {
            [WSELF.collectionView.pullToRefreshView startAnimating];
        } else {
            [WSELF.collectionView.pullToRefreshView stopAnimating];
        }
    }];
    
    [RACObserve(self, refreshCommand) subscribeNext:^(RACCommand *command) {
        [WSELF.collectionView addPullToRefreshWithActionHandler:^{
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
//    flowLayout.footerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 25);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = kTHLNUISecondaryBackgroundColor;
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPathCommand execute:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    THLGuestlistInviteEntity *guestlistInviteEntity = [[self dataSource] untransformedItemAtIndexPath:indexPath];
    if (guestlistInviteEntity.response == THLStatusPending) {
        return CGSizeMake(ViewWidth(collectionView) - 25, 125);
    } else {
        return CGSizeMake(ViewWidth(collectionView) - 25, 150);
    }
}

#pragma mark - EmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"You do not have any upcoming events";
    } else {
        text = @"You are not logged in";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"Please create a Guestlist for an Event or if you are invited to an Event, it will show up here";
    } else {
        text = @"Please log in to create a Guestlist or view your invites to Events";
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUISecondaryBackgroundColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                 };
    
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"Refresh";
    } else {
        text = @"Login";
    }
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
//    [_refreshCommand execute:nil];
    if ([THLUser currentUser]) {
        [_refreshCommand execute:nil];
    } else {
        [_loginCommand execute:nil];
    }
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}

@end

