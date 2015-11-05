//
//  UIView+AddSubviews.m
//  The HypeList App
//
//  Created by Phil Meyers IV on 6/29/15.
//  Copyright (c) 2015 The HypeList. All rights reserved.
//

#import "UIView+AddSubviews.h"

@implementation UIView (AddSubviews)
- (void)addSubviews:(NSArray *)array {
	for (UIView *view in array) {
		[self addSubview:view];
	}
}
@end
