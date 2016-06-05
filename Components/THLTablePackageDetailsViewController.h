//
//  THLTablePackageDetailsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 6/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseUI.h"
#import <Parse/PFObject.h>
#import "UIScrollView+EmptyDataSet.h"

@interface THLTablePackageDetailsViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic) PFObject *admissionOption;
@property (nonatomic) PFObject *event;
@end
