//
//  THLAdmissionsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLAdmissionsViewController.h"
#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import "THLDashboardNotificationCell.h"
#import "THLEventInviteCell.h"
#import "THLPersonIconView.h"
#import "THLAppearanceConstants.h"
#import "THLAttendingEventCell.h"
#import "SVProgressHUD.h"
#import "THLUser.h"
#import "Intercom/intercom.h"
#import "THLAdmissionOptionCell.h"


@interface SimpleDannyCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIView *separatorView;

@end

@implementation SimpleDannyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _label = THLNUILabel(kTHLNUISectionTitle);
    _label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_label];
    
    _separatorView = THLNUIView(kTHLNUIUndef);
    _separatorView.backgroundColor = kTHLNUIAccentColor;
    [self addSubview:_separatorView];
    
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WEAKSELF();
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF label].mas_baseline).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF label]);
        make.bottom.insets(kTHLEdgeInsetsHigh());
        
        make.size.equalTo(CGSizeMake(40, 2.5));
        
    }];
}

@end

@interface THLAdmissionsViewController()
{
    NSArray *_sectionSortedKeys;
    NSMutableDictionary *_sections;
}
@end

@implementation THLAdmissionsViewController
@synthesize event = _event;

#pragma mark -
#pragma mark Init

- (instancetype)initWithClassName:(NSString *)className {
    self = [super initWithClassName:className];
    if (!self) return nil;
    
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    _sections = [NSMutableDictionary dictionary];
    
    return self;
}

#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = [self navBarTitleLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Help"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
    
    [self.collectionView registerClass:[THLAdmissionOptionCell class] forCellWithReuseIdentifier:[THLAdmissionOptionCell identifier]];
    [self.collectionView registerClass:[SimpleDannyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
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
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 25, 125);
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    //    [SVProgressHUD dismiss];
    [super objectsDidLoad:error];
    
    [_sections removeAllObjects];
    for (PFObject *object in self.objects) {
        NSNumber *priority = object[@"type"];
        
        NSMutableArray *array = _sections[priority];
        if (array) {
            [array addObject:object];
        } else {
            _sections[priority] = [NSMutableArray arrayWithObject:object];
        }
    }
    
    _sectionSortedKeys = [[_sections allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.collectionView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionAray = _sections[_sectionSortedKeys[indexPath.section]];
    return sectionAray[indexPath.row];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_sections count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionAray = _sections[_sectionSortedKeys[section]];
    return [sectionAray count];
}

#pragma mark -
#pragma mark Data

- (PFQuery *)queryForCollection {
    PFQuery *query = [super queryForCollection];
    [query whereKey:@"location" equalTo:_event[@"location"]];
    [query orderByAscending:@"price"];
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object
{
        THLAdmissionOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLAdmissionOptionCell identifier] forIndexPath:indexPath];
        cell.title = object[@"name"];
        cell.price = [object[@"price"] floatValue];
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
//    [self.delegate didSelectViewEventTicket:object];
    if (!(BOOL)object[@"didOpen"]) {
        object[@"didOpen"] = @YES;
        [object saveInBackground];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SimpleDannyCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        NSNumber *response = _sectionSortedKeys[indexPath.section];
        if (response == [NSNumber numberWithInteger:0]) {
            view.label.text = @"TICKETS";
        } else if (response == [NSNumber numberWithInteger:1]) {
            view.label.text = @"TABLE & BOTTLE SERVICE";
        }
        return view;
    }
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([_sections count]) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 40.0f);
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
    label.text = [NSString stringWithFormat:@"%@ \n %@",_event[@"location"][@"name"], ((NSDate *)_event[@"date"]).thl_formattedDate];
    [label sizeToFit];
    return label;
}

#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
////    return return CGSizeMake(192.f, 192.f);
//}



#pragma mark - EmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"No Admission Options Available";
    } else {
        text = @"You are not logged in";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"When you purchase tickets or receive event invites from a friend, they'll show up here";
    } else {
        text = @"Please log in to attend an event or view your event invites";
    }
    
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
    
    NSString *text = @" ";
    if ([THLUser currentUser]) {
        text = @"Refresh";
    } else {
        text = @"Login";
    }
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    //    [_refreshCommand execute:nil];
    if ([THLUser currentUser]) {
        [self loadObjects];
    } else {
        [self.delegate usersWantsToLogin];
    }
}

@end
