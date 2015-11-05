//
//  THLConfirmationPopupView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"

@interface THLConfirmationPopupView : UIView
@property (nonatomic, copy) NSString *confirmationText;
@property (nonatomic, strong) RACCommand *confirmCommand;
//@property (nonatomic, strong) RACCommand *cancelCommand;
@end