//
//  THLWaitlistModel.h
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLWaitlistModel;
@class THLWaitlistEntry;

@protocol THLWaitlistModelDelegate <NSObject>
- (void)modelDidCreateEntry:(THLWaitlistModel *)model error:(NSError *)error;
- (void)model:(THLWaitlistModel *)model didCheckForExistingEntry:(THLWaitlistEntry *)waitlistEntry error:(NSError *)error;
- (void)model:(THLWaitlistModel *)model didGetWaitlistPosition:(NSInteger)position error:(NSError *)error;
@end

@interface THLWaitlistModel : NSObject
@property (nonatomic, weak) id<THLWaitlistModelDelegate> delegate;

#pragma mark - Dependencies
- (instancetype)init;

- (void)checkForExisitngLocalWaitlistEntry;
- (void)checkForApprovedWaitlistEntry;
- (void)createWaitlistEntryForEmail:(NSString *)email;
- (void)getWaitlistPosition;
@end
