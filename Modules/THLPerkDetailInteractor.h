//
//  THLPerkDetailInteractor.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPerkDetailInteractor;
@class THLUser;
@class THLPerkStoreItem;



@protocol THLPerkDetailInteractorDelegate <NSObject>

@end


@interface THLPerkDetailInteractor : NSObject
@property (nonatomic, weak) id<THLPerkDetailInteractorDelegate> delegate;

@end
