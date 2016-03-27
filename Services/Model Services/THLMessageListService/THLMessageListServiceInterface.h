//
//  THLMessageListServiceInterface.h
//  Hype
//
//  Created by Александр on 07.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@protocol THLMessageListServiceInterface <NSObject>
- (BFTask *)fetchAllMessageListItems;
- (BFTask *)fetchAllHistoryListItems;
- (BFTask *)fetchAllHistoryList;
- (BFTask *)fetchHistory;

@end
