//
//  THLLoginView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLLoginView <NSObject>
//@property (nonatomic) THLActivityStatus activityIndicator;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, copy) NSString *loginText;
@end
