//
//  THLDiscoveryViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryCollectionViewController.h>

@protocol THLDiscoveryViewControllerDelegate <NSObject>
- (void)eventDiscoveryViewControllerWantsToPresentDetailsForEvent:(PFObject *)event;
@end

@interface THLDiscoveryViewController : PFQueryCollectionViewController
@property (nonatomic, weak) id<THLDiscoveryViewControllerDelegate> delegate;

@end
