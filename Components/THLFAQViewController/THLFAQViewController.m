//
//  THLFQAViewController.m
//  HypeUp
//
//  Created by Nik Cane on 31/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLFAQViewController.h"
#import "THLAppearanceConstants.h"

@implementation THLFAQViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    
}

- (void) constructView {
     self.navigationItem.leftBarButtonItem = [self newBackBarButtonItem];   
}

- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction)];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (void)handleCancelAction {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
