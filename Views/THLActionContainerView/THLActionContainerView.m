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
        [self reloadView];
    }
    return self;
}

- (void)reloadView {
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    if (_status == THLActionContainerViewStatusAcceptOrDecline) {
        _acceptButton = [self newAcceptButton];
        _declineButton = [self newRejectButton];
    } else if (_status == THLActionContainerViewStatusAccept) {
        _acceptButton = [self newAcceptButton];
    } else if (_status == THLActionContainerViewStatusDecline) {
        _declineButton = [self newRejectButton];
    }
}

- (void)layoutView {
    if (_status == THLActionContainerViewStatusAcceptOrDecline) {
        [self addSubviews:@[self.acceptButton,
                            self.declineButton]];
        
        WEAKSELF();
        [self.acceptButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.insets(kTHLEdgeInsetsHigh());
            make.right.equalTo([WSELF declineButton].mas_left).insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(WSELF.declineButton);
        }];
        
        [self.declineButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.insets(kTHLEdgeInsetsHigh());
            make.left.equalTo([WSELF acceptButton].mas_right).insets(kTHLEdgeInsetsHigh());
        }];
        
    } else if (_status == THLActionContainerViewStatusAccept){
        [self addSubview:self.acceptButton];
        [self.acceptButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.insets(kTHLEdgeInsetsHigh());
        }];
    }  else if (_status == THLActionContainerViewStatusDecline){
        [self addSubview:self.declineButton];
        [self.declineButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.insets(kTHLEdgeInsetsHigh());
        }];
    }
}

- (void)bindView {
//    [RACObserve(self, status) subscribeNext:^(id _) {
//        [self setNeedsDisplay];
//    }];
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
- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
