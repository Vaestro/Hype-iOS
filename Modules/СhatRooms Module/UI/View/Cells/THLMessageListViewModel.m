//
//  THLMessageListViewModel.m
//  HypeUp
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListViewModel.h"
#import "THLMessageListCellView.h"
#import "THLMessageListCell.h"

@implementation THLMessageListViewModel

- (instancetype)initWithMessageList:(THLMessageListEntity *)messageListEntity {
    if (self = [super init]) {
        _messageListEntity = messageListEntity;
    }
    return self;
}

- (void)configureView:(id<THLMessageListCellView>)cellView {
    THLMessageListCell * cell = (THLMessageListCell *)cellView;
    [cell setup];
    [cellView setLastMessage:_messageListEntity.lastMessage];
    [cellView setLocationAddress:_messageListEntity.address];
    [cellView setLogoImageURL:[NSURL URLWithString:@"http://wefunction.com/wordpress/wp-content/uploads/2015/04/free-photos-sites-vol2-466x300.jpg"]];
//    [cellView setName:_perkStoreItemEntity.name];
//    [cellView setInfo:_perkStoreItemEntity.info];
//    [cellView setImage:_perkStoreItemEntity.image];
//    [cellView setCredits:_perkStoreItemEntity.credits];
}

@end
