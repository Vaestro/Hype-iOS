//
//  THLFAQSectionView.h
//  HypeUp
//
//  Created by Nik Cane on 02/02/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLTitledContentView.h"

@interface THLFAQSectionView : THLTitledContentView

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) UIImage *image;

@end
