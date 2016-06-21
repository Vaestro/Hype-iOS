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

- (void)loadView
{
    UIWebView *webView = [UIWebView new];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}



@end
