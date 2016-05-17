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
#import "MBProgressHUD.h"


@interface THLTicketScannerController () <PQScannerDelegate,UIAlertViewDelegate>
{
    @private PQScanner *_scanner;
}
@property (nonatomic, strong) MBProgressHUD *hud;
- (void)displayError:(NSError *)error;
- (void)displayTicketInfo:(NSDictionary *)ticketInfo;
@end

@implementation THLTicketScannerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scanner = [[PQScanner alloc]initWithTargetView:self.view withDelegate:self];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    [_scanner setupAVCapture];
    
    [_scanner startScan:^(NSString *encodeStr, NSString *codeType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.hud show:YES];
            
            NSArray *array = [encodeStr componentsSeparatedByString:@"_"];
            NSDictionary *scannerInfo = @{
                                          @"guestId": [array objectAtIndex:0],
                                          @"guestlistId": [array objectAtIndex:1]
                                          };
            
            [PFCloud callFunctionInBackground:@"validateTicket"
                               withParameters:scannerInfo
                                        block:^(NSDictionary *ticketInfo, NSError *error) {
                                            [self.hud hide:YES];
                                            if (error) {
                                                [self displayError:error];
                                            } else {
                                                [self displayTicketInfo:ticketInfo];
                                            }
                                        }];
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
    [_scanner setupAVCapture];
}

#pragma mark - UIAlerViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [_scanner continueScan];
    }
}


#pragma mark - helpers

- (void)displayError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)displayTicketInfo:(NSDictionary *)ticketInfo
{
    NSString *info = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", [ticketInfo valueForKey:@"name"],[ticketInfo valueForKey:@"sex"], [ticketInfo valueForKey:@"venue"], [ticketInfo valueForKey:@"date"]];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ticket", @"Ticket")
                                                      message:info
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}


@end
