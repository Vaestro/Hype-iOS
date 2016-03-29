//
//  THLMessageListService.m
//  Hype
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListService.h"
#import "THLPubnubManager.h"

@implementation THLMessageListService

- (instancetype)initWithQueryFactory:(THLPubnubQueryFactory *)queryFactory {
    if (self = [super init]) {
        _queryFactory = queryFactory;
    }
    return self;
}

- (BFTask *)fetchAllMessageListItems {
    return [BFTask taskWithResult:[[THLPubnubManager sharedInstance] fetchAllChannels]];
}

- (BFTask *)fetchAllHistoryListItems {
    return [BFTask taskWithResult:[[THLPubnubManager sharedInstance] fetchHistory]];
}

- (BFTask *)fetchHistory {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    [[THLPubnubManager sharedInstance] fetchHistoryWithCompletion:^(NSArray *result) {
        [task setResult:result];
    }];
    return task.task;
}
@end
