//
//  THLConfirmationPopupView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"
#import "THLActionBarButton.h"

@interface THLConfirmationPopupView : UIView
@property (nonatomic, copy) NSString *confirmationText;
@property (nonatomic, strong) RACCommand *acceptCommand;
@property (nonatomic, strong) RACCommand *declineCommand;
@property (nonatomic, strong) THLActionBarButton *acceptButton;
@property (nonatomic, strong) THLActionBarButton *declineButton;
@end