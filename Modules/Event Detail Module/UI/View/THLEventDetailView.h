//
//  THLEventDetailView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLEventDetailView <NSObject>
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, copy) NSURL *promoImageURL;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *promoInfo;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *locationInfo;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, copy) NSString *actionBarButtonStatus;
@property (nonatomic, strong) CLPlacemark *locationPlacemark;
@property (nonatomic, strong) RACCommand *actionBarButtonCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@end
