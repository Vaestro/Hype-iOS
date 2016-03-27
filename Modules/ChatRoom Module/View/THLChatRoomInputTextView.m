//
//  THLChatRoomInputTextView.m
//  Hype
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatRoomInputTextView.h"
#import "THLAppearanceConstants.h"

#define kTHLInputFieldBackColor [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]
const CGFloat kTHLSendButtonWidth = 75;

@interface THLChatRoomInputTextView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * inputField;
@property (nonatomic, strong) UIButton * sendButton;

@end

@implementation THLChatRoomInputTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kTHLInputFieldBackColor;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width - 16, self.frame.size.height - 16)];
        containerView.backgroundColor = [UIColor whiteColor];
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(4, 4, containerView.frame.size.width - 75, containerView.frame.size.height - 8)];
        self.inputField.delegate = self;
        self.inputField.placeholder = @"write a reply...";
        containerView.layer.borderColor = kTHLInputFieldBackColor.CGColor;
        containerView.layer.borderWidth = 1;
        containerView.layer.cornerRadius = 3;
        [self addSubview:containerView];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.backgroundColor = kTHLNUIAccentColor;
        [self.sendButton setTitleColor:UIColor.darkGrayColor];
        [self.sendButton addTarget:self action:@selector(tapSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        self.sendButton.frame = CGRectMake(containerView.frame.size.width - 75, 0, 75, containerView.frame.size.height);
        [self.sendButton setTitle:@"send" forState:UIControlStateNormal];
        [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [containerView addSubview:self.sendButton];
        [containerView addSubview:self.inputField];
    }
    return self;
}

- (void)hideKeyboard {
    [self.inputField resignFirstResponder];
}

- (void)tapSendMessage:(UIButton *)sender {
    if (![self.inputField.text isEqualToString:@""]) {
        [self.delegate sendMessage:self.inputField.text];
        self.inputField.text = @"";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textColor = [UIColor darkGrayColor];
    textField.font = [UIFont systemFontOfSize:14];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
