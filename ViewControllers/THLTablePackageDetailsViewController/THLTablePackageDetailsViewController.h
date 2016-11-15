//
//  THLTablePackageDetailsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 6/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import "UIScrollView+EmptyDataSet.h"


@protocol THLTablePackageControllerDelegate <NSObject>
- (void)packageControllerWantsToPresentCheckoutForEvent:(PFObject *)event andAdmissionOption:(PFObject *)admissionOption;
- (void)didLoadObjects;
@end

@interface THLTablePackageDetailsViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, weak) id<THLTablePackageControllerDelegate> delegate;

- (instancetype)initWithEvent:(PFObject *)event admissionOption:(PFObject *)admissionOption showActionButton:(BOOL)showActionButton;
@end
