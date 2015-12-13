//
//  THLPerkStoreItem.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface THLPerkStoreItem : PFObject<PFSubclassing>
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *itemDescription;
@property (nonatomic, retain) PFFile *image;
@property (nonatomic) int credits;
@end
