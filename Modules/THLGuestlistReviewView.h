//
//  THLGuestlistReviewView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;

@protocol THLGuestlistReviewView <NSObject>
@property (nonatomic, strong) THLViewDataSource *dataSource;
@property (nonatomic) BOOL showRefreshAnimation;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) RACCommand *backCommand;

@end
