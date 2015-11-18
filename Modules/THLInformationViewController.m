//
//  THLInformationViewController.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/14/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLInformationViewController.h"
#import "THLAppearanceConstants.h"
@interface THLInformationViewController()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation THLInformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [UITextView new];
        textView.editable = NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor whiteColor];
        textView.font = [UIFont systemFontOfSize:16];
        
        _textView = textView;
    }
    return _textView;
}

- (void)setDisplayText:(NSString *)displayText {
    _displayText = displayText;
    self.textView.text = displayText;
}
@end
