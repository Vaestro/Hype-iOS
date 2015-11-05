//
//  THLActionContainerView.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "THLActionBarButton.h"

typedef NS_OPTIONS(NSInteger, THLActionContainerViewStatus) {
    THLActionContainerViewStatusAcceptOrDecline = 0,
    THLActionContainerViewStatusAccept,
    THLActionContainerViewStatusDecline
};
@interface THLActionContainerView : UIView
@property (nonatomic, strong) THLActionBarButton *declineButton;
@property (nonatomic, strong) THLActionBarButton *acceptButton;
@property (nonatomic) THLActionContainerViewStatus status;
- (void)reloadView;
//@property (nonatomic, strong) RACCommand *acceptCommand;
//@property (nonatomic, strong) RACCommand *declineCommand;
@end
