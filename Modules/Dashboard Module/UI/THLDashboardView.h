//
//  THLDashboardView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLDashboardView <NSObject>
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, copy) NSString *promotionMessage;
@property (nonatomic, copy) NSURL *hostImageURL;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, strong) RACCommand *actionButtonCommand;
@property (nonatomic, strong) RACCommand *contactHostCommand;
@property (nonatomic) BOOL viewAppeared;
@end