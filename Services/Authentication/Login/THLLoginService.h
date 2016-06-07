//
//  THLLoginService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginServiceInterface.h"
@protocol THLLoginServiceDelegate <NSObject>

-(void)loginServiceDidSaveUserFacebookInformation;

@end

@interface THLLoginService : NSObject<THLLoginServiceInterface>
@property (nonatomic, weak) id<THLLoginServiceDelegate> delegate;

@end
