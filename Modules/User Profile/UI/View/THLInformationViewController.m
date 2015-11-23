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
@property (nonatomic, strong) UIBarButtonItem *backButton;
@end

@implementation THLInformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
}

- (void)constructView {
    _backButton = [self newBackBarButtonItem];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = _backButton;

    [self.view addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(kTHLEdgeInsetsHigh());
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

- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction)];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (void)handleCancelAction {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}
@end
