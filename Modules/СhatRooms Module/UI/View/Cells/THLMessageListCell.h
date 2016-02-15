//
//  THLMessageListTableViewCell.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "THLMessageListCellView.h"

@interface THLMessageListCell : UITableViewCell<THLMessageListCellView>
+ (NSString *)identifier;
- (void)setup;
@end
