//
//  THLDependencyManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLYapDatabaseManager.h"

@class THLMasterWireframe;
@class THLUserManager;
@class THLPerkStoreWireframe;
@class THLPerkDetailWireframe;
@class THLViewDataSourceFactory;
@class APAddressBook;
@class THLGuestlistService;
@class THLDataStore;
@class THLLoginService;
/**
 *  Manages all dependenies for the app.
 */
@interface THLDependencyManager : NSObject
@property (nonatomic, readonly, strong) THLMasterWireframe *masterWireframe;
- (THLUserManager *)userManager;
- (THLYapDatabaseManager *)databaseManager;
- (THLViewDataSourceFactory *)viewDataSourceFactory;
- (APAddressBook *)addressBook;
- (THLGuestlistService *)guestlistService;
- (THLDataStore *)contactsDataStore;
- (THLLoginService *)loginService;
@end
