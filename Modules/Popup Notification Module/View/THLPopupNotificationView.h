//
//  THLPopupNotificationView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"
#import "THLPopupNotificationViewModel.h"

@protocol THLPopupNotificationViewModel;
@interface THLPopupNotificationView : UIView<THLPopupNotificationViewModel>

@end

