//
//  THLEventDetailsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PFObject.h>

@interface THLEventDetailsViewController : UIViewController <UIScrollViewDelegate>
- (id)initWithEvent:(PFObject *)event;
@end
