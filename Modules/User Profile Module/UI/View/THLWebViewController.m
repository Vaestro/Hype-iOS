//
//  THLWebViewController.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/14/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWebViewController.h"

@interface THLWebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation THLWebViewController


- (void) viewDidAppear:(BOOL)animated {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
}


@end
