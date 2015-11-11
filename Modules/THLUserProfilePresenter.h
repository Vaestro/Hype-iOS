//
//  THLUserProfilePresenter.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLUserProfileModuleInterface.h"

@protocol THLUserProfileView;
@class THLUserProfileWireframe;
@interface THLUserProfilePresenter : NSObject<THLUserProfileModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLUserProfileWireframe *wireframe;

- (instancetype)initWithWireframe:(THLUserProfileWireframe *)wireframe;
- (void)configureView:(id<THLUserProfileView>)view;
@end
