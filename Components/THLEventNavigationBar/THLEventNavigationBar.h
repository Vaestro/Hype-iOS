//
//  THLEventNavigationBar.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLEventNavigationBar : UINavigationBar
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *subtitleText;
@property (nonatomic, copy) NSString *dateText;
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, strong) RACCommand *dismissCommand;
@end