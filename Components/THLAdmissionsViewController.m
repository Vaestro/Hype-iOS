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
#import "THLCollectionReusableView.h"
#import "TTTAttributedLabel.h"
#import "THLTablePackageAdmissionCell.h"
#import "THLEvent.h"

@interface THLAdmissionsViewController()
<
TTTAttributedLabelDelegate
>
{
    NSArray *_sectionSortedKeys;
    NSMutableDictionary *_sections;
}
@property (nonatomic, strong) TTTAttributedLabel *contactConciergeLabel;

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
    [self.collectionView registerClass:[THLTablePackageAdmissionCell class] forCellWithReuseIdentifier:[THLTablePackageAdmissionCell identifier]];
    [self.collectionView registerClass:[THLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    WEAKSELF();
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(UIEdgeInsetsZero);
    }];
    
    UIView *buttonBackground = [UIView new];
    buttonBackground.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    [self.view addSubview:buttonBackground];
    
    [buttonBackground makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(WSELF.collectionView.mas_bottom);
        make.height.equalTo(80);
    }];
    
    [buttonBackground addSubview:self.contactConciergeLabel];
    [_contactConciergeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    UIView *separatorView = THLNUIView(kTHLNUIUndef);
    separatorView.backgroundColor = kTHLNUIGrayFontColor;
    [buttonBackground addSubview:separatorView];
    
    [separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(buttonBackground);
        make.height.equalTo(0.5);
        
    }];
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
    layout.itemSize = CGSizeMake(ViewWidth(self.collectionView) - 25, 55);
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
    [self emptyDataSetShouldDisplay:self.collectionView];

    
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
    
    if ([object[@"type"] integerValue] == 0) {
        
        THLAdmissionOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLAdmissionOptionCell identifier] forIndexPath:indexPath];
        cell.titleLabel.text = object[@"name"];
        
        if ([object[@"price"] floatValue] == 0) {
            cell.priceLabel.text = @"FREE";
        } else {
            cell.priceLabel.text = [NSString stringWithFormat:@"$ %.2f", [object[@"price"] floatValue]];
        }
        
        return cell;
    } else {
      
        THLTablePackageAdmissionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLTablePackageAdmissionCell identifier] forIndexPath:indexPath];
        cell.titleLabel.text = object[@"name"];
        cell.priceLabel.text = [NSString stringWithFormat:@"$%ld total", [object[@"price"] integerValue]];
        cell.partySizeLabel.text = [NSString stringWithFormat:@"%ld people", [object[@"partySize"] integerValue]];
        cell.perPersonLabel.text = [NSString stringWithFormat:@"$%.f/person", ceil([object[@"price"] floatValue]/[object[@"partySize"] floatValue])];
    
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *admissionOption = [self objectAtIndexPath:indexPath];

    if ([admissionOption[@"type"] integerValue] == 0 && [admissionOption[@"gender"] integerValue] != [THLUser currentUser].sex) {
        return [self displayWrongTicket];
    }
    
    [self.delegate didSelectAdmissionOption:admissionOption forEvent:_event];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        THLCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        NSNumber *response = _sectionSortedKeys[indexPath.section];
        if (response == [NSNumber numberWithInteger:0]) {
            THLEvent *event = (THLEvent *)_event;
            view.label.text = @"TICKETS";
            view.subtitleLabel.text = [NSString stringWithFormat:@"Earn $%d credits when your ticket gets scanned at the venue", event.creditsPayout];
        } else if (response == [NSNumber numberWithInteger:1]) {
            view.label.text = @"TABLE & BOTTLE SERVICE";
            view.subtitleLabel.text = nil;

        }
        return view;
    }
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([_sections count]) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 70.0f);
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

- (TTTAttributedLabel *)contactConciergeLabel
{
    if (!_contactConciergeLabel) {
        _contactConciergeLabel = [TTTAttributedLabel new];
        _contactConciergeLabel.textColor = [UIColor whiteColor];
        _contactConciergeLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:14];
        _contactConciergeLabel.numberOfLines = 0;
        _contactConciergeLabel.linkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                             NSUnderlineColorAttributeName: kTHLNUIAccentColor,
                                             NSUnderlineStyleAttributeName: @(NSUnderlineStyleThick)};
        _contactConciergeLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
        _contactConciergeLabel.textAlignment = NSTextAlignmentCenter;
        NSString *labelText = @"Have a question? Ask your concierge";
        _contactConciergeLabel.text = labelText;
        NSRange concierge = [labelText rangeOfString:@"concierge"];
        [_contactConciergeLabel addLinkToURL:[NSURL URLWithString:@"action://show-intercom"] withRange:concierge];
        _contactConciergeLabel.delegate = self;

        [_contactConciergeLabel sizeToFit];
    }
    
    return _contactConciergeLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-intercom"]) {
            [self messageButtonPressed];
        } else {
            /* deal with http links here */
        }
    }
}

#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
}


- (void)displayWrongTicket
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Please select the ticket that corresponds to your gender"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if ([self.objects count] == 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
