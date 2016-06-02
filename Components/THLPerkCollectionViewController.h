//
//  THLPerkCollectionViewController.h
//  Hype
//
//  Created by Edgar Li on 6/2/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "UIScrollView+EmptyDataSet.h"

@protocol THLPerkCollectionViewControllerDelegate <NSObject>
- (void)perkStoreViewControllerWantsToPresentDetailsFor:(PFObject *)perk;
@end

@interface THLPerkCollectionViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, weak) id<THLPerkCollectionViewControllerDelegate> delegate;

@end
