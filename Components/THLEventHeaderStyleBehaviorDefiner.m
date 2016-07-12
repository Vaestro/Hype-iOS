//
//  THLEventHeaderStyleBehaviorDefiner.m
//  Hype
//
//  Created by Edgar Li on 7/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventHeaderStyleBehaviorDefiner.h"
#import "BLKFlexibleHeightBar.h"

@implementation THLEventHeaderStyleBehaviorDefiner

# pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.isCurrentlySnapping)
    {
        CGFloat progress = (scrollView.contentOffset.y+scrollView.contentInset.top) / (self.flexibleHeightBar.maximumBarHeight-self.flexibleHeightBar.minimumBarHeight);
        if (progress >= 0.0 && progress <= 1.0) {
            self.flexibleHeightBar.progress = progress;
            [self.flexibleHeightBar setNeedsLayout];
        }
    }
}

@end