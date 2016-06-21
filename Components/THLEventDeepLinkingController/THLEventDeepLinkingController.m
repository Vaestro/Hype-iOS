//
//  THLEventDeepLinkingController.m
//  Hype
//
//  Created by Daniel Aksenov on 6/20/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventDeepLinkingController.h"
#import "Branch.h"

@interface THLEventDeepLinkingController ()
<BranchDeepLinkingController>

@end

@implementation THLEventDeepLinkingController
@synthesize deepLinkingCompletionDelegate;

- (void)configureControlWithData:(NSDictionary *)data {
    NSString *pictureUrl = data[@"eventUrl"];
    
    // show the picture
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.productImageView.image = image;
        });
    });
}

@end
