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

@interface THLEventDiscoveryViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation THLEventDiscoveryViewController
@synthesize selectedIndexPathCommand = _selectedIndexPathCommand;
@synthesize dataSource = _dataSource;

#pragma mark - THLEventDiscoveryView
- (void)setDataSource:(THLViewDataSource *)dataSource {
	[self configureDataSource:dataSource];
	_dataSource = dataSource;
}

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
}

- (void)configureView {
	_collectionView = [self newCollectionView];
	[self.view addSubview:_collectionView];
	[_collectionView makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(UIEdgeInsetsZero);
	}];
}

#pragma mark - Constructors
- (UICollectionView *)newCollectionView {
	UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
	collectionView.alwaysBounceVertical = YES;
	collectionView.delegate = self;
	return collectionView;
}

- (void)configureDataSource:(THLViewDataSource *)dataSource {
	_collectionView.dataSource = dataSource;

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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[_selectedIndexPathCommand execute:indexPath];
}
@end
