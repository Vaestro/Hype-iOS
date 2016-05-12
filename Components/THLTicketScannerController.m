//
//  THLTicketScannerController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTicketScannerController.h"
#import "PQScanner.h"
#import "Parse.h"


@interface THLTicketScannerController () <PQScannerDelegate,UIAlertViewDelegate>
{
    @private PQScanner *_scanner;
}
@end

@implementation THLTicketScannerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scanner = [[PQScanner alloc]initWithTargetView:self.view withDelegate:self];
    
    [_scanner setupAVCapture];
    
    [_scanner startScan:^(NSString *encodeStr, NSString *codeType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = [NSString stringWithFormat:@"encodedString: %@ \n codeType: %@",encodeStr,codeType];
            UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"PQScanner"
                                                              message:msg
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
            
            [alerView show];
        });
    }];
    
}

#pragma mark - PQScannerDelegate

-(void)scanner:(PQScanner *)scanner
didEncodeQRCode:(NSString *)encodeStr
      codeType:(NSString *)codeType
{
    
}


-(void)scanner:(PQScanner *)scanner
didOpenCaptureFaild:(NSError *)error
{
    NSLog(@"capture open failed!");
}

#pragma mark - UIAlerViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [_scanner continueScan];
    }
}
@end
