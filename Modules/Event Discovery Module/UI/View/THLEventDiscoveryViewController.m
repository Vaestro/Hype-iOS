//
//  THLEventDiscoveryViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryViewController.h"
#import "THLViewDataSource.h"
#import "THLEventDiscoveryCell.h"
#import "THLEventDiscoveryCellViewModel.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "THLAppearanceConstants.h"
#import "Intercom/intercom.h"

@interface THLEventDiscoveryViewController ()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation THLEventDiscoveryViewController
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize dataSource = _dataSource;
@synthesize showRefreshAnimation = _showRefreshAnimation;
@synthesize refreshCommand = _refreshCommand;

#pragma mark - VC Lifecycle
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

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.title = @"NEW YORK";
    self.navigationItem.leftBarButtonItem = [self newBarButtonItem];

	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.automaticallyAdjustsScrollViewInsets = YES;

	_collectionView = [self newCollectionView];
	[self.view addSubview:_collectionView];
    
	[_collectionView makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.bottom.insets(kTHLEdgeInsetsNone());
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
    flowLayout.minimumInteritemSpacing = 2.5;
    flowLayout.minimumLineSpacing = 2.5;
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
	collectionView.nuiClass = kTHLNUIBackgroundView;
    collectionView.backgroundColor = kTHLNUISecondaryBackgroundColor;
	collectionView.alwaysBounceVertical = YES;
	collectionView.delegate = self;
	return collectionView;
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
	_collectionView.dataSource = dataSource;
	dataSource.collectionView = _collectionView;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;

	[self.collectionView registerClass:[THLEventDiscoveryCell class] forCellWithReuseIdentifier:[THLEventDiscoveryCell identifier]];

	dataSource.cellCreationBlock = (^id(id object, UICollectionView* parentView, NSIndexPath *indexPath) {
		if ([object isKindOfClass:[THLEventDiscoveryCellViewModel class]]) {
			return [parentView dequeueReusableCellWithReuseIdentifier:[THLEventDiscoveryCell identifier] forIndexPath:indexPath];
		}
		return nil;
	});

	dataSource.cellConfigureBlock = (^(id cell, id object, id parentView, NSIndexPath *indexPath){
		if ([object isKindOfClass:[THLEventDiscoveryCellViewModel class]] && [cell conformsToProtocol:@protocol(THLEventDiscoveryCellView)]) {
			[(THLEventDiscoveryCellViewModel *)object configureView:(id<THLEventDiscoveryCellView>)cell];
		}
	});

}

- (UIBarButtonItem *)newBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Inbox Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
}

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[_selectedIndexPathCommand execute:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(ViewWidth(collectionView), DiscoveryCellHeight(ViewWidth(collectionView)));
}

#pragma mark - EmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Oops there was an error fetching events";

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
    
    NSString *text = @"Refresh";

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [_refreshCommand execute:nil];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return NO;
}
@end
