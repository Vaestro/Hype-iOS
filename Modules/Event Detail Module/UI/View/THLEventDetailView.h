//
//  THLEventDetailView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol THLEventDetailView <NSObject>
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSURL *locationImageURL;

@property (nonatomic, copy) NSURL *promoImageURL;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *promoInfo;
@property (nonatomic, copy) NSString *ratioInfo;
@property (nonatomic, copy) NSString *coverInfo;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *locationInfo;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, copy) NSString *locationAttireRequirement;
@property (nonatomic, copy) NSString *locationMusicTypes;
@property (nonatomic) BOOL exclusiveEvent;

@property (nonatomic) BOOL userHasAcceptedInvite;
@property (nonatomic, strong) CLPlacemark *locationPlacemark;
@property (nonatomic, strong) RACCommand *actionBarButtonCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic) BOOL viewAppeared;
@end
