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
@end

@implementation THLEventDetailsLocationInfoView
- (void)constructView {
	[super constructView];
	_textView = [self newTextView];
}

- (void)layoutView {
	[super layoutView];
	[self.contentView addSubviews:@[_textView]];

	[_textView makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(kTHLEdgeInsetsNone());
	}];
}

- (void)bindView {
	[super bindView];

	RAC(self.textView, text) = RACObserve(self, locationInfo);
}

#pragma mark - Constructors
- (UITextView *)newTextView {
	UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
	[textView setScrollEnabled:NO];
	return textView;
}
@end
