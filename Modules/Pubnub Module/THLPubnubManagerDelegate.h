//
//  THLPubnubManagerDelegate.h
//  HypeUp
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPubnubManager.h"
#import <Pubnub.h>

@class THLPubnubManager;

@protocol THLPubnubManagerDelegate <NSObject>

- (void)didReceiveMessage:(THLPubnubManager *)manager withMessage:(PNMessageResult *)message;

@end
