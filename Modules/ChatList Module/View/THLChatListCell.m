//
//  THLChatListCell.m
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatListCell.h"
#import <DateTools/DateTools.h>
#import <UIImageView+WebCache.h>

@interface THLChatListCell ()

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *unReadMessageCountLabel;

@end

@implementation THLChatListCell

- (void)awakeFromNib {
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2;
    self.unReadMessageCountLabel.layer.cornerRadius = self.unReadMessageCountLabel.frame.size.width / 2;
    self.photoImageView.clipsToBounds = YES;
    self.unReadMessageCountLabel.clipsToBounds = YES;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
}

- (void)configureCell:(THLChatListItem *)item {
    [self.lastMessageLabel setText:item.lastMessage];
    [self.titleLabel setText:item.title];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.timeLabel setText:[self configureDate:item.time]];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:item.imageURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSString *)configureDate:(NSString *)date {
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:date.integerValue];
    return [currentDate timeAgoSinceNow];
}

@end
