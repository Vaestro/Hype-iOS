//
//  THLMessageListCellView.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLMessageListCellView <NSObject>
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, copy) NSString *lastMessage;
@property (nonatomic, assign) NSInteger unreadMessageCount;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSURL *logoImageURL;
@end
