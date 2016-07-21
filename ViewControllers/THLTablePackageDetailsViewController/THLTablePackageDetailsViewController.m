//
//  THLTablePackageDetailsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 6/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTablePackageDetailsViewController.h"
#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import "THLEventInviteCell.h"
#import "THLPersonIconView.h"
#import "THLAppearanceConstants.h"
#import "THLAttendingEventCell.h"
#import "SVProgressHUD.h"
#import "THLUser.h"
#import "Intercom/intercom.h"
#import "THLCollectionReusableView.h"
#import "THLTablePackageDetailCell.h"
#import "THLActionButton.h"
#import "Hype-Swift.h"


@interface THLTablePackageDetailsViewController()
@property(nonatomic, strong) THLActionButton *checkoutButton;
@property (nonatomic, strong) PFObject *admissionOption;
@property (nonatomic, strong) PFObject *event;
@property (nonatomic) BOOL showActionButton;

@end

@implementation THLTablePackageDetailsViewController


- (instancetype)initWithEvent:(PFObject *)event admissionOption:(PFObject *)admissionOption showActionButton:(BOOL)showActionButton {
    self = [super initWithClassName:@"Bottle"];
    if (!self) return nil;
    
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.admissionOption = admissionOption;
    self.event = event;
    
    self.showActionButton = showActionButton;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = [[THLEventNavBarTitleView alloc] initWithVenueName:_event[@"location"][@"name"] date:_event[@"date"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Help"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
    
    [self.collectionView registerClass:[THLTablePackageDetailCell class] forCellWithReuseIdentifier:[THLTablePackageDetailCell identifier]];
    [self.collectionView registerClass:[THLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    WEAKSELF();
    if (_showActionButton) {
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(UIEdgeInsetsZero);
        }];
        
        [self.checkoutButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.collectionView.mas_bottom);
            make.bottom.left.right.equalTo(WSELF.view).insets(kTHLEdgeInsetsHigh());
            make.height.equalTo(60);
        }];
    } else {
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
}

- (BFTask<NSArray<__kindof PFObject *> *> *)loadObjects {
    if ([THLUser currentUser]) {
        return [super loadObjects];
    } else {
        return nil;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 50, 125);
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
    [query whereKey:@"admissionOption" equalTo:_admissionOption];
    [query orderByAscending:@"amount"];
    return query;
}

#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object
{
    THLTablePackageDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLTablePackageDetailCell identifier] forIndexPath:indexPath];
    cell.amountLabel.text = [NSString stringWithFormat:@"x%d", [object[@"amount"] integerValue]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", object[@"name"]];
    cell.venueImageView.file = object[@"image"];
    [cell.venueImageView loadInBackground];
    
    return cell;
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        THLCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.label.text = @"TABLE PACKAGE INCLUDES:";
        return view;
    }
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([self.objects count]) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 60.0f);
    }
    return CGSizeZero;
}

- (UILabel *)navBarTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@ \n %@",_event[@"location"][@"name"], ((NSDate *)_event[@"date"]).thl_weekdayString];
    [label sizeToFit];
    return label;
}


- (THLActionButton *)checkoutButton
{
    if (!_checkoutButton) {
        _checkoutButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_checkoutButton setTitle:@"Continue"];
        [_checkoutButton addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_checkoutButton];
    }
    return _checkoutButton;
}



#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
}

- (void)checkout:(id)sender {
    [self.delegate packageControllerWantsToPresentCheckoutForEvent:_event andAdmissionOption:_admissionOption];
}


#pragma mark - EmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Bottles Available";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"The venue has not currently updated the bottles for the requested table package";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUIPrimaryBackgroundColor;
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
