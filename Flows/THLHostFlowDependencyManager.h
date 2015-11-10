//
//  THLHostFlowDependencyManager.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventHostingWireframe;
@class THLEventDiscoveryWireframe;
@class THLGuestlistReviewWireframe;

@protocol THLHostFlowDependencyManager <NSObject>
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLEventHostingWireframe *)newEventHostingWireframe;
- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe;
@end
