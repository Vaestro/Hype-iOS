//
//  THLChatRoomInputTextView.h
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THLChatRoomInputTextViewDelegate <NSObject>

- (void)sendMessage:(NSString *)message;

@end

@interface THLChatRoomInputTextView : UIView

- (void)hideKeyboard;
@property (nonatomic, weak) id <THLChatRoomInputTextViewDelegate> delegate;

@end
