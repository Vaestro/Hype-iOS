//
//  THLFQAViewController.m
//  HypeUp
//
//  Created by Nik Cane on 31/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLFAQViewController.h"
#import "THLAppearanceConstants.h"
#import "ORStackScrollView.h"
#import "THLFAQSectionView.h"

@interface THLFAQViewController()

@property (nonatomic, strong) ORStackScrollView *scrollView;

@end

@implementation THLFAQViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    
}

- (void) constructView {
     self.navigationItem.leftBarButtonItem = [self newBackBarButtonItem];
     _scrollView = [self newScrollView];
}

#pragma mark Configuration setup

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    [self.view addSubviews:@[_scrollView]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_scrollView.stackView addSubview:[self recommendedRatio]
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];

    [_scrollView.stackView addSubview:[self bottleService]
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];

    [_scrollView.stackView addSubview:[self barTab]
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:[self walkIns]
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
}

#pragma mark - Constructors

- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (UIBarButtonItem *)newBackBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelAction)];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (THLFAQSectionView *) recommendedRatio
{
    return [self createSectionViewWithTitle:@"Recommended Ratio"
                                      image:[UIImage imageNamed:@"digits-logo-name@3x"]
                                description:@"ratioratioratioratio ratioratio ratioratioratio ratioratio"
                             separatorStyle:SlimWhiteLine];
}

- (THLFAQSectionView *) bottleService
{
    return [self createSectionViewWithTitle:@"Bottle service"
                                      image:[UIImage imageNamed:@"digits-logo-icon@3x"]
                                description:@"bottle bollf serjdsfsdfns; sdl;jf ;lsdn f;lsn"
                             separatorStyle:SlimWhiteLine];
}

- (THLFAQSectionView *) barTab
{
    return [self createSectionViewWithTitle:@"Bar Tab"
                                      image:[UIImage imageNamed:@"stp_card_jcb@3x"]
                                description:@"bar tab sdfj sldjfg lsaj f;lsaj f"
                             separatorStyle:SlimWhiteLine];
}

- (THLFAQSectionView *) walkIns
{
    return [self createSectionViewWithTitle:@"Walk Ins"
                                      image:[UIImage imageNamed:@"stp_card_discover@3x"]
                                description:@"walk ins dlf lsakdjf asjdf; jasd"
                             separatorStyle:SlimWhiteLine];
}

- (THLFAQSectionView *) createSectionViewWithTitle:(NSString *) title
                                             image:(UIImage *) image
                                       description:(NSString *) description
                                    separatorStyle:(FAQSeparatorStyle) separatorStyle
{
    THLFAQSectionView *sectionView = [[THLFAQSectionView alloc] initWithTitle:title
                                                                  description:description
                                                                        image:image
                                                               separatorStyle:separatorStyle];
    return sectionView;
}



- (void)handleCancelAction {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
