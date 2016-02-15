//
//  THLMessageListItem.h
//  HypeUp
//
//  Created by Александр on 07.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLEntity.h"

@interface THLMessageListItem : THLEntity

@property (nonatomic, strong) NSString *lastMessage;

@end
