//
//  THLPopupNotificationViewModel.h
//  TheHypelist
//
//  Created by Edgar Li on 11/12/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLPopupNotificationViewModel <NSObject>
@property (nonatomic, strong) RACCommand *acceptCommand;
//@property (nonatomic) BOOL actionable;
@property (nonatomic, copy) NSString *notificationText;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@end