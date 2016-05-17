//
//  THLCheckoutViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/15/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THLEventEntity;

@interface THLCheckoutViewController : UIViewController
- (id)initWithEvent:(THLEventEntity *)event andCompletionAction:(RACCommand *)completionAction;
@end
