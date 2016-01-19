//
//  THLLoginView.h
//  TheHypelist
//
//  Created by Edgar Li on 12/7/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLLoginViewInterface <NSObject>

@property (nonatomic) NSNumber *showActivityIndicator;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, copy) NSString *loginText;
@end
