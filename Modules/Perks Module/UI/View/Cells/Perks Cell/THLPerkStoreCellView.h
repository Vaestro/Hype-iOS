//
//  THLPerkStoreCellView.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLPerkStoreCellView <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSURL *image;
@property (nonatomic) int credits;
@end