//
//  THLActionContainerView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLActionContainerView.h"
#import "THLAppearanceConstants.h"

@interface THLActionContainerView()
@property (nonatomic, strong) UIView *view;
@end

@implementation THLActionContainerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _acceptButton = [self newAcceptButton];
    _declineButton = [self newRejectButton];
}

- (void)layoutView {
    [self addSubviews:@[self.acceptButton,
                        self.declineButton]];
    
    [self.acceptButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.insets(UIEdgeInsetsZero);
        make.right.equalTo(self.declineButton.mas_left);
        make.width.equalTo(self.declineButton);
    }];
    
    [self.declineButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.insets(UIEdgeInsetsZero);
    }];
}

- (void)bindView {
//    RAC(self.acceptButton, rac_command) = RACObserve(self, acceptCommand);
//    RAC(self.declineButton, rac_command) = RACObserve(self, declineCommand);
}

#pragma mark - Constructors
- (THLActionBarButton *)newAcceptButton {
    THLActionBarButton *button = [THLActionBarButton new];
    [button setTitle:@"ACCEPT" animateChanges:NO];
    button.backgroundColor = [button tealColor];
    return button;
}

- (THLActionBarButton *)newRejectButton {
    THLActionBarButton *button = [THLActionBarButton new];
    [button setTitle:@"REJECT" animateChanges:NO];
    button.backgroundColor = [button redColor];
    return button;
}
@end
