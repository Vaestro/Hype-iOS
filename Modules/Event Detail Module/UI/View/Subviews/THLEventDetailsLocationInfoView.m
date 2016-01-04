//
//  THLEventDetailsLocationInfoView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailsLocationInfoView.h"
#import "THLAppearanceConstants.h"

@interface THLEventDetailsLocationInfoView()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *readMoreTextButton;
@end

@implementation THLEventDetailsLocationInfoView
- (void)constructView {
    [super constructView];
    _textView = [self newTextView];
    _readMoreTextButton = [self newReadMoreTextButton];
}

- (void)layoutView {
    [super layoutView];
    [self.contentView addSubviews:@[_textView, _readMoreTextButton]];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsNone());
        make.left.right.equalTo(kTHLEdgeInsetsLow());
//        make.bottom.equalTo(kTHLEdgeInsetsHigh());
    }];
    
    [_readMoreTextButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom);
        make.left.right.equalTo(kTHLEdgeInsetsLow());
        make.bottom.insets(kTHLEdgeInsetsLow());
    }];
}

- (void)bindView {
    [super bindView];
    RAC(self.textView, text) = RACObserve(self, locationInfo);
}

- (void)expandText {
    _textView.textContainer.maximumNumberOfLines = 0;
    [self setNeedsLayout];
}

#pragma mark - Constructors
- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    [textView setSelectable:NO];
    textView.textContainer.maximumNumberOfLines = 0;
    return textView;
}

- (UIButton *)newReadMoreTextButton {
    UIButton *button = [UIButton new];
    [button addTarget:self action:@selector(expandText) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];

    [button setTitleColor:[UIColor whiteColor]];
    [button.titleLabel setText:@"Read More"];
    
    return button;
}


//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end