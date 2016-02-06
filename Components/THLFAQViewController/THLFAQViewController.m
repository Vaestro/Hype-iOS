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
@property (nonatomic, strong) THLFAQSectionView *ratio;
@property (nonatomic, strong) THLFAQSectionView *bottleService;
@property (nonatomic, strong) THLFAQSectionView *barTab;
@property (nonatomic, strong) THLFAQSectionView *walkIns;

@end

@implementation THLFAQViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
}

- (void) constructView {
     self.navigationItem.leftBarButtonItem = [self newBackBarButtonItem];
     _scrollView = [self newScrollView];
    _ratio = [self recommendedRatio];
    _bottleService = [self bottleService];
    _barTab = [self barTab];
    _walkIns = [self walkIns];
}

#pragma mark Configuration setup

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    [self.view addSubviews:@[_scrollView]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_scrollView.stackView addSubview:_ratio
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];

    [_scrollView.stackView addSubview:_bottleService
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];

    [_scrollView.stackView addSubview:_barTab
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_walkIns
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];
    
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
                                      image:[UIImage imageNamed:@"Home Icon"]
                                description:@"ratioratioratioratio ratioratio ratioratioratio ratioratio"];
}

- (THLFAQSectionView *) bottleService
{
    return [self createSectionViewWithTitle:@"Bottle service"
                                      image:[UIImage imageNamed:@"Clear Check"]
                                description:@"bottle bollf serjdsfsdfns; sdl;jf ;lsdn f;lsn"];
}

- (THLFAQSectionView *) barTab
{
    return [self createSectionViewWithTitle:@"Bar Tab"
                                      image:[UIImage imageNamed:@"Calendar Icon"]
                                description:@"bar tab sdfj sldjfg lsaj f;lsaj f"];
}

- (THLFAQSectionView *) walkIns
{
    return [self createSectionViewWithTitle:@"Walk Ins"
                                      image:[UIImage imageNamed:@"Chat Icon"]
                                description:@"walk ins dlf lsakdjf asjdf; jasd"];
}

- (THLFAQSectionView *) createSectionViewWithTitle:(NSString *) title
                                             image:(UIImage *) image
                                       description:(NSString *) description
{
    THLFAQSectionView *sectionView = [THLFAQSectionView new];
    sectionView.titleString = title;
    sectionView.descriptionString = description;
    sectionView.image = image;
    return sectionView;
}



- (void)handleCancelAction {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
