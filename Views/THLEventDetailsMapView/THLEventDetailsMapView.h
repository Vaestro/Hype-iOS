//
//  THLEventDetailsMapView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"

@interface THLEventDetailsMapView : UIView
@property (nonatomic, strong) UILabel *venueNameLabel;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, copy) CLPlacemark *locationPlacemark;
@end
