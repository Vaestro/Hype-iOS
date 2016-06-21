//
//  THLUserProfileTableViewCell.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLUserProfileTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *title;

+ (NSString *)identifier;
@end