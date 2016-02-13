//
//  THLAlertView.h
//  HypeUp
//
//  Created by Edgar Li on 2/12/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface THLAlertView : FXBlurView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) RACCommand *dismissCommand;

- (void)showWithTitle:(NSString *)title message:(NSString *)message;
- (void)dismiss;

@end
