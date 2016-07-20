//
//  THLPerkDetailViewController.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface THLPerkDetailViewController : UIViewController

@property (nonatomic, copy) NSURL *perkStoreItemImage;
@property (nonatomic, copy) NSString *perkStoreItemName;
@property (nonatomic, copy) NSString *perkStoreItemDescription;
@property (nonatomic) int credits;
//@property (nonatomic, strong) RACCommand *dismissCommand;
//@property (nonatomic, strong) RACCommand *purchaseCommand;

- (id)initWithPerk:(PFObject *)perk;

-(void)showConfirmationView;

@end
