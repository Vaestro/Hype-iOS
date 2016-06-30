//
//  THLVenueDiscoveryViewController.m
//  Hype
//
//  Created by Edgar Li on 6/22/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLVenueDiscoveryViewController.h"

#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import <ParseUI/PFImageView.h>
#import "THLParseQueryFactory.h"

#import "Intercom/intercom.h"

#import "THLAppearanceConstants.h"
#import "TTTAttributedLabel.h"
#import "THLUser.h"

#import "THLDiscoveryCell.h"


@interface THLVenueDiscoveryViewController ()
@property (nonatomic, strong) TTTAttributedLabel *navBarTitleLabel;
@property (nonatomic, strong) THLParseQueryFactory *parseQueryFactory;

@end

@implementation THLVenueDiscoveryViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (!self) return nil;
    
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    
    return self;
}



#pragma mark -
#pragma mark UIViewController
- (void)loadView {
    [super loadView];
    
    [self.collectionView registerClass:[THLDiscoveryCell class]
            forCellWithReuseIdentifier:[THLDiscoveryCell identifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    const CGRect bounds = UIEdgeInsetsInsetRect(self.view.bounds, layout.sectionInset);
    CGFloat sideSize = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0f - layout.minimumInteritemSpacing;
    layout.itemSize = CGSizeMake(sideSize, sideSize * 1.20);
    
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.collectionView reloadData];
    [self emptyDataSetShouldDisplay:self.collectionView];
}



#pragma mark -
#pragma mark Data

- (PFQuery *)queryForCollection {
    PFQuery *query = [super queryForCollection];

    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery includeKey:@"location"];
    [eventQuery whereKeyExists:@"location"];

    DTTimePeriod *eventDisplayPeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeMonth amount:1 startingAt:[[NSDate date] dateByAddingTimeInterval:-60*300]];
    
    [eventQuery whereKey:@"date" lessThanOrEqualTo:eventDisplayPeriod.EndDate];
    [eventQuery whereKey:@"date" greaterThanOrEqualTo:eventDisplayPeriod.StartDate];
    
    [query whereKey:@"objectId" matchesKey:@"locationId" inQuery:eventQuery];
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    THLDiscoveryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLDiscoveryCell identifier]
                                                                       forIndexPath:indexPath];
    
    cell.titlesView.locationNameText = object[@"name"];
    cell.titlesView.locationNeighborhoodText = object[@"neighborhood"];
    cell.venueImageView.file = object[@"image"];
    [cell.venueImageView loadInBackground];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
    [self.delegate venueDiscoveryViewControllerWantsToPresentDetailsForVenue:object];
}

#pragma mark - EmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Oops there was an error fetching events";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUISecondaryBackgroundColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                 };
    
    NSString *text = @"Refresh";
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self loadObjects];
}


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if ([self.objects count] == 0) {
        return YES;
    } else {
        return NO;
    }
}


@end
