//
//  THLMessageListModuleDelegate.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListModuleInterface.h"

@class THLMessageListEntity;
@protocol THLMessageListModuleInterface;

@protocol THLMessageListModuleDelegate <NSObject>
- (void)messageListModule:(id<THLMessageListModuleInterface>)module userDidSelectMessageListItemEntity:(THLMessageListEntity *)messageListEntity presentChatRoomInterfaceOnController:(UIViewController *)controller;

@end
