//
//  THLStatusView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLStatusView.h"
#import "THLAppearanceConstants.h"

@interface THLStatusView ()
@property (nonatomic, strong) UIImageView *shapeView;
@end

@implementation THLStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self bindView];
    }
    return self;
}

- (void)bindView {
    WEAKSELF();
    [RACObserve(self, status) subscribeNext:^(NSNumber *status) {
        [WSELF drawingForStatus];
    }];
}

- (void)drawingForStatus {
    switch (_status) {
        case THLStatusPending: {
            self.image = [UIImage imageNamed:@"pending_icon"];
            break;
        }
        case THLStatusAccepted: {
            self.image = [UIImage imageNamed:@"accepted_icon"];

            break;
        }
        case THLStatusCheckedIn: {
            self.image = [UIImage imageNamed:@"checked_in_icon"];

            break;
        }
        case THLStatusDeclined: {
            self.image = [UIImage imageNamed:@"decline_icon"];
            
            break;
        }
        case THLStatusNone: {

            break;
        }
        default: {
            break;
        }
    }
}

@end
