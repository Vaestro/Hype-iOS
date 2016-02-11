//
//  THLUserDataWorker.h
//  HypeUp
//
//  Created by Nik Cane on 29/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLUser.h"
#import "THLLoginInteractor.h"

@interface THLUserDataWorker : NSObject

+ (void)addProfileImage:(UIImage *)profileImage
                forUser:(THLUser *) user
               delegate:(id<THLLoginInteractorDelegate>) delegate;

@end
