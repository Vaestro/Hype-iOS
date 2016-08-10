//
//  THLTablePackageDetailView.h
//  Hype
//
//  Created by Edgar Li on 7/29/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"
@class PFObject;

@interface THLTablePackageDetailView : THLTitledContentView

- (instancetype)initWithTablePackageItems:(NSMutableArray<PFObject *> *)items;

@end