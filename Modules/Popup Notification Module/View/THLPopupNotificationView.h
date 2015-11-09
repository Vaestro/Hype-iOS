//
//  THLPopupNotificationView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"

@interface THLPopupNotificationView : UIView
@property (nonatomic, strong) RACCommand *acceptCommand;
@property (nonatomic, copy) NSString *notificationText;
@property (nonatomic, copy) NSURL *notificationImageURL;
@end

