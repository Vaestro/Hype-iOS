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
- (void)setMessageLabelText:(nullable NSString *)text;
- (void)setButtonTitle:(nullable NSString *)title;
- (void)setButtonTarget:(nullable id)target action:(nonnull SEL)selector forControlEvents:(UIControlEvents)event;
- (void)setIconURL:(nullable NSURL *)url;
- (void)setImageViewWithURL:(nullable NSURL *)url;

@end

