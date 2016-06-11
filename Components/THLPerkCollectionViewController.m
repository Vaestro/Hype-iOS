//
//  THLPerkCollectionViewController.m
//  Hype
//
//  Created by Edgar Li on 6/2/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPerkCollectionViewController.h"
#import "Parse.h"
#import <ParseUI/PFCollectionViewCell.h>
#import "THLAppearanceConstants.h"
#import "THLUserManager.h"
#import "THLParseQueryFactory.h"
#import "Intercom/intercom.h"
#import "THLPerkStoreCell.h"
#import "THLUser.h"
#import "TTTAttributedLabel.h"

@interface THLPerkCollectionViewController()
@property (nonatomic, strong) UIBarButtonItem *intercomBarButton;

@property (nonatomic, strong) UILabel *creditsTitleLabel;
@property (nonatomic, strong) UILabel *userCreditsLabel;
@property (nonatomic, strong) UILabel *creditBalanceLabel;
@property (nonatomic, strong) TTTAttributedLabel *navBarTitleLabel;

@end

@implementation THLPerkCollectionViewController
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshCreditsForUser];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.collectionView.backgroundColor = kTHLNUIPrimaryBackgroundColor;

    self.navigationItem.titleView = self.navBarTitleLabel;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    if ([THLUserManager userLoggedIn])
    {
        self.navigationItem.leftBarButtonItem = [self intercomBarButton];
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
    
    [self.collectionView registerClass:[THLPerkStoreCell class] forCellWithReuseIdentifier:[THLPerkStoreCell identifier]];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    const CGRect bounds = UIEdgeInsetsInsetRect(self.view.bounds, layout.sectionInset);
    CGFloat sideSize = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0f - layout.minimumInteritemSpacing;
    layout.itemSize = CGSizeMake(sideSize, sideSize * 1.20);
    
    WEAKSELF();

    [self.creditsTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    
    [self.creditBalanceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.creditsTitleLabel.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.right.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.creditBalanceLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.bottom.right.equalTo(kTHLEdgeInsetsNone());
    }];
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
   [query orderByAscending:@"credits"];
    return query;
}


#pragma mark -
#pragma mark CollectionView

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    THLPerkStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[THLPerkStoreCell identifier] forIndexPath:indexPath];
    cell.perkTitleLabel.text = (NSString *)object[@"name"];
    
    cell.perkCreditsLabel.text = [NSString stringWithFormat:@"%@.00", object[@"credits"]];

    PFFile *imageFile = object[@"image"];
    NSURL *url = [NSURL URLWithString:imageFile.url];
    [cell.perkImageView sd_setImageWithURL:url];

    return cell;
}

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
    
}

- (BFTask *)refreshCreditsForUser {
    THLUser *currentUser = [THLUser currentUser];
    return [[currentUser fetchInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id _Nullable(BFTask<__kindof PFObject *> * _Nonnull task) {
        [self.creditBalanceLabel setText:NSStringWithFormat(@"$%.2f", currentUser.credits)];
        return [BFTask taskWithResult:nil];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self objectAtIndexPath:indexPath];
    [self.delegate perkStoreViewControllerWantsToPresentDetailsFor:object];
}


#pragma mark - Accessors
- (TTTAttributedLabel *)navBarTitleLabel
{
    if (!_navBarTitleLabel) {
        _navBarTitleLabel = [TTTAttributedLabel new];
        _navBarTitleLabel.numberOfLines = 1;
        _navBarTitleLabel.textAlignment = NSTextAlignmentCenter;
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"PERKS"
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor whiteColor].CGColor,
                                                                                     NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                                     NSKernAttributeName : @4.5f
                                                                                     }];
        _navBarTitleLabel.text = attString;
        [_navBarTitleLabel sizeToFit];
    }
    
    return _navBarTitleLabel;
}

- (UILabel *)creditsTitleLabel {
    if (!_creditsTitleLabel) {

        _creditsTitleLabel = THLNUILabel(kTHLNUIDetailTitle);
        _creditsTitleLabel.text = @"Your credit balance is:";
        _creditsTitleLabel.adjustsFontSizeToFitWidth = YES;
        _creditsTitleLabel.numberOfLines = 4;
        _creditsTitleLabel.minimumScaleFactor = 1;
        _creditsTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_creditsTitleLabel];
    }
    return _creditsTitleLabel;
}

- (UILabel *)creditBalanceLabel {
    if (!_creditBalanceLabel) {
        _creditBalanceLabel = [UILabel new];
        [_creditBalanceLabel setFont:[UIFont systemFontOfSize:30 weight:0.5]];
        _creditBalanceLabel.textColor = kTHLNUIAccentColor;
        _creditBalanceLabel.adjustsFontSizeToFitWidth = YES;
        _creditBalanceLabel.numberOfLines = 2;
        _creditBalanceLabel.minimumScaleFactor = 0.5;
        _creditBalanceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_creditBalanceLabel];
    }

    return _creditBalanceLabel;
}

- (UIBarButtonItem *)intercomBarButton {
    if (!_intercomBarButton) {
        _intercomBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Help"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    }
    return _intercomBarButton;
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
