//
//  THLMessageListPresenter.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListPresenter.h"
#import "THLMessageListModuleDelegate.h"
#import "THLMessageListInteractor.h"
#import "THLMessageListWireframe.h"

@interface THLMessageListPresenter ()<THLMessageListInteractorDelegate>

@property (nonatomic, weak) id<THLMessageListView> view;

@end

@implementation THLMessageListPresenter
@synthesize moduleDelegate;

- (instancetype)initWithInteractor:(THLMessageListInteractor *)interactor
                         wireframe:(THLMessageListWireframe *)wireframe {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
        
    }
    return self;
}

#pragma mark - Module Interface
- (void)presentEventDiscoveryInterfaceInNavigationController:(UINavigationController *)navigationController {
    [_wireframe presentInNavigationController:navigationController];
    //[_wireframe presentInNavigationController:navigationController];
}

- (void)interactor:(THLMessageListInteractor *)interactor didUpdateEvents:(NSError *)error {
    //
}

- (void)configureView:(id<THLMessageListView>)view {
//    _view = view;
//    
//    WEAKSELF();
//    STRONGSELF();
//    THLViewDataSource *dataSource = [_interactor generateDataSource];
//    dataSource.dataTransformBlock = ^id(id item) {
//        return [[THLEventDiscoveryCellViewModel alloc] initWithEvent:(THLEventEntity *)item];
//    };
//    
//    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [SSELF handleIndexPathSelection:(NSIndexPath *)input];
//        return [RACSignal empty];
//    }];
//    
//    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [SSELF handleRefreshAction];
//        return [RACSignal empty];
//    }];
//    
//    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
//        BOOL isRefreshing = [b boolValue];
//        [SSELF.view setShowRefreshAnimation:isRefreshing];
//    }];
//    
//    [_view setDataSource:dataSource];
//    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
//    [_view setRefreshCommand:refreshCommand];
    
}

@end
