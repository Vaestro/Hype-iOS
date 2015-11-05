//
//  THLConstants.h
//  The HypeList
//
//  Created by Phil Meyers IV on 6/27/15.
//  Copyright (c) 2015 The HypeList. All rights reserved.
//


#ifndef The_HypeList_THLConstants_h
#define The_HypeList_THLConstants_h

typedef NS_ENUM(NSInteger, THLStatus) {
	THLStatusPending = 0,
	THLStatusAccepted,
	THLStatusDeclined,
    THLStatusNone
};

typedef NS_ENUM(NSInteger, THLSex) {
	THLSexUnreported = 0,
	THLSexMale,
	THLSexFemale,
	THLSex_Count
};

typedef NS_OPTIONS(NSInteger, THLActivityStatus) {
    THLActivityStatusNone = 0,
    THLActivityStatusInProgress,
    THLActivityStatusSuccess,
    THLActivityStatusError,
    THLActivityStatus_Count
};

#define SafeString(string) (string != nil) ? string : @""

#define make_CenterWithInsets(UIEdgeInsets)     make.left.top.greaterThanOrEqualTo(UIEdgeInsets).priorityHigh();   \
												make.right.bottom.lessThanOrEqualTo(UIEdgeInsets).priorityHigh();  \
												make.center.equalTo(0)

#define make_BoundInsideWithInsets(UIEdgeInsets)		make.left.top.greaterThanOrEqualTo(UIEdgeInsets).priorityHigh();   \
														make.right.bottom.lessThanOrEqualTo(UIEdgeInsets).priorityHigh();

//msv stands for "Masonry super view"
//mrv stands for "Masonry reference view"
//Inteded to be used when doing layout constraints with Masonry.
//Calling MASONRY_HELPER2(); will include both msv and mrv, or can
//just call MASONRY_HELPER(); to include msv
//#define MASONRY_HELPER(superview)		UIView *msv = superview; \
#define _MSV(superview)					msv = superview

#define NAVIGATION_CONTROLLER_WRAPPER(viewController) [[UINavigationController alloc] initWithRootViewController:viewController]

#define FACEBOOK_BLUE [UIColor colorWithRed:0.294 green:0.416 blue:0.71 alpha:1]
#endif
