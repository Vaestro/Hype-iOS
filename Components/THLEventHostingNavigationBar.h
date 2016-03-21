//
//  THLEventHostingNavigationBar.h
//  HypeUp
//
//  Created by Edgar Li on 2/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLEventHostingNavigationBar : UINavigationBar
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *detailDisclosureCommand;
@end