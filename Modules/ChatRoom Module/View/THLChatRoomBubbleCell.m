//
//  THLChatRoomBubbleCell.m
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatRoomBubbleCell.h"
#import "THLParseQueryFactory.h"
#import <UIImageView+WebCache.h>
#import <Parse/Parse.h>
#import "THLUser.h"

#define kTHLNUIContainerLightBackground [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1]
//#define kTHLNUIContainerDarkBackground [UIColor colorWithRed:0.773 green:0.702 blue:0.345 alpha:1]

@interface THLChatRoomBubbleCell ()

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *textMessageLabel;
@property (nonatomic, strong) THLParseQueryFactory *queryFactory;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation THLChatRoomBubbleCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.queryFactory = [[THLParseQueryFactory alloc] init];
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2;
    self.photoImageView.clipsToBounds = true;
    self.containerView.layer.cornerRadius = 2;
    self.contentView.backgroundColor = [UIColor clearColor];
    // Initialization code
}

- (void)setMessage:(THLMessage *)message {
    self.textMessageLabel.text = message.text;
    if ([[THLUser currentUser].objectId isEqualToString:message.userID]) {
        [self.photoImageView sd_setImageWithURL:nil];
        [self.containerView setBackgroundColor:UIColor.blackColor];
        [self.textMessageLabel setTextColor:UIColor.whiteColor];
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.timeLabel setText:[NSString stringWithFormat:@"You, %@", [self timeString:message.time]]];
    } else {
        [self.containerView setBackgroundColor:kTHLNUIContainerLightBackground];
        self.textMessageLabel.textAlignment = NSTextAlignmentLeft;
        [self.textMessageLabel setTextColor:UIColor.darkGrayColor];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:message.userImageURL]];
        [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.timeLabel setText:[NSString stringWithFormat:@"%@, %@", message.userName, [self timeString:message.time]]];
    }

}

- (NSString *)timeString:(NSString *)time {
    NSTimeInterval timeInterval = time.integerValue;
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    return [formatter stringFromDate:currentTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
