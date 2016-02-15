//
//  THLMessage.h
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLUser;

@interface THLMessage : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userImageURL;
@property (nonatomic, strong) NSString *userName;

- (instancetype)initWithResult:(NSDictionary *)data;
- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text andUser:(THLUser *)user;

- (NSDictionary *)toObject;

@end
