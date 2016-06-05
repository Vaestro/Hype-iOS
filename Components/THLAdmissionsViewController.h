//
//  THLAdmissionsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import <Parse/PFObject.h>
#import "UIScrollView+EmptyDataSet.h"


@protocol THLAdmissionsViewDelegate <NSObject>
- (void)usersWantsToLogin;
- (void)didSelectAdmissionOption:(PFObject *)admissionOption forEvent:(PFObject *)event;
@end


@interface THLAdmissionsViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, weak) id<THLAdmissionsViewDelegate> delegate;
@property (nonatomic) PFObject *event;
@end
