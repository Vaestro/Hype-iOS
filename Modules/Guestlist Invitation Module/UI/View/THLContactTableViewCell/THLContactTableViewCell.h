//
//  THLContactTableViewCell.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface THLContactTableViewCell : UITableViewCell
//@property (nonatomic, copy) UIImage *thumbnail;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;

+ (NSString *)identifier;
@end
