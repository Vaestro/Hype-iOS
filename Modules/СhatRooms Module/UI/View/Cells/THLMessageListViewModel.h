//
//  THLMessageListViewModel.h
//  HypeUp
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListCellView.h"
#import "THLMessageListEntity.h"

@protocol THLMessageListView;
@class THLMessageListEntity;

@interface THLMessageListViewModel : NSObject
@property (nonatomic, readonly) THLMessageListEntity *messageListEntity;

- (instancetype)initWithMessageList:(THLMessageListEntity *)messageListEntity;
- (void)configureView:(id<THLMessageListCellView>)view;

@end
