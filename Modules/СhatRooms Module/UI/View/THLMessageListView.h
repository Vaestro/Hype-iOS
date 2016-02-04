//
//  THLMessageListView.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;

@protocol THLMessageListView <NSObject>
//@property (nonatomic, strong) THLViewDataSource *dataSource;
//@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
//@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic) BOOL showRefreshAnimation;
@end
