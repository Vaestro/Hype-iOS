//
//  THLVenueDetailsView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/12/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXBlurView.h"

@protocol THLVenueDetailsViewModel;
@interface THLVenueDetailsView : FXBlurView
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, copy) NSURL *promoImageURL;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *promoInfo;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *locationInfo;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, strong) CLPlacemark *locationPlacemark;

@property (nonatomic, strong) RACCommand *dismissCommand;

@end