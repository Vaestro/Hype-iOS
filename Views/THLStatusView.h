//
//  THLStatusView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, THLStatusViewSize) {
    THLStatusViewSizeSmall = 0,
    THLStatusViewSizeMedium,
    THLStatusViewSizeLarge
};

@interface THLStatusView : UIImageView
@property (nonatomic) THLStatus status;
@property (nonatomic, assign) CGFloat scale;

- (instancetype)initWithStatus:(THLStatus)status;

@end
