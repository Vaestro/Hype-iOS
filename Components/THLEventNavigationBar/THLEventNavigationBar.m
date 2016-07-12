//
//  THLEventNavigationBar.m
//  Hypelist2point0
//
//  Created by Edgar Li on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//
#import "THLEventNavigationBar.h"
#import "BLKFlexibleHeightBarSubviewLayoutAttributes.h"
#import "THLEventHeaderStyleBehaviorDefiner.h"

#import <Parse/Parse.h>

#import "THLAppearanceConstants.h"

#import "DGActivityIndicatorView.h"
#import "THLEvent.h"
#import "THLLocation.h"

@interface THLEventNavigationBar()
<
SwipeViewDataSource,
SwipeViewDelegate
>

@property (nonatomic, strong) UIImageView *scrollUpIcon;
@property (nonatomic) int numberOfLayouts;
@property (nonatomic, strong) THLEvent *event;
@property (nonatomic, strong) THLLocation *venue;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *loadingView;

@end

@implementation THLEventNavigationBar

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
    NSLog(@"YA BOY %@ DEALLOCATED", [self class]);
}

- (instancetype)initWithFrame:(CGRect)frame event:(THLEvent *)event venue:(THLLocation *)venue {
    if (self = [super initWithFrame:frame]) {
        self.behaviorDefiner = [THLEventHeaderStyleBehaviorDefiner new];
        
        self.minimumBarHeight = 65.0;

        self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        self.userInteractionEnabled = YES;
        self.event = event;
        self.venue = venue;
        //configure swipeView
        
        _numberOfLayouts = 0;
        self.images = [NSMutableArray array];
        int imageTotal;
        if (self.event.promoImage != nil) {
            imageTotal = venue.imageCount + 1;
        } else {
            imageTotal = venue.imageCount;
        }
        
        for (int i = 0; i < imageTotal; i++) {
            [_images addObject:@(i)];
        }
        
        WEAKSELF();

        [self.swipeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(WSELF);
            make.bottom.equalTo([WSELF titleLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo([WSELF swipeView]);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF dateLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF scrollUpIcon].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.minimumTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30);
            make.centerX.equalTo(0);
            make.width.equalTo(SCREEN_WIDTH*0.66);
        }];
        
        [self.scrollUpIcon makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.centerX.equalTo(0);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];


}

#pragma mark - Accessors
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIBoldTitle);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 1;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_titleLabel addLayoutAttributes:initialLayoutAttributes forProgress:0.5];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_titleLabel addLayoutAttributes:finalLayoutAttributes forProgress:0.9];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UILabel *)minimumTitleLabel {
    if (!_minimumTitleLabel) {
        _minimumTitleLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _minimumTitleLabel.adjustsFontSizeToFitWidth = YES;
        _minimumTitleLabel.numberOfLines = 1;
        _minimumTitleLabel.minimumScaleFactor = 0.5;
        _minimumTitleLabel.textAlignment = NSTextAlignmentCenter;
        _minimumTitleLabel.alpha = 0.0;

        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 0.0;
        [_minimumTitleLabel addLayoutAttributes:initialLayoutAttributes forProgress:0.5];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 1.0;
        [_minimumTitleLabel addLayoutAttributes:finalLayoutAttributes forProgress:0.9];
        [self addSubview:_titleLabel];
        
        [self addSubview:_minimumTitleLabel];
    }
    return _minimumTitleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = kTHLNUIPrimaryFontColor;
        _dateLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];
        _dateLabel.adjustsFontSizeToFitWidth = YES;
        _dateLabel.numberOfLines = 1;
        _dateLabel.minimumScaleFactor = 0.5;
        _dateLabel.textAlignment = NSTextAlignmentCenter;

        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_dateLabel addLayoutAttributes:initialLayoutAttributes forProgress:0.5];

        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_dateLabel addLayoutAttributes:finalLayoutAttributes forProgress:0.9];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
        _pageControl.numberOfPages = _images.count;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = true;
        _pageControl.currentPageIndicatorTintColor = kTHLNUIAccentColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (SwipeView *)swipeView {
    if (!_swipeView) {
//        _swipeView = [SwipeView new];
        _swipeView = [[SwipeView alloc] initWithFrame:self.bounds];
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
        _swipeView.pagingEnabled = true;
    
        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_swipeView addLayoutAttributes:initialLayoutAttributes forProgress:0.1];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_swipeView addLayoutAttributes:finalLayoutAttributes forProgress:1.0];
        
        [self addSubview:_swipeView];
    }
    return _swipeView;
}

- (UIImageView *)scrollUpIcon {
    if (!_scrollUpIcon) {
        _scrollUpIcon = [UIImageView new];
        _scrollUpIcon.image = [UIImage imageNamed:@"scroll_up_icon"];
        _scrollUpIcon.contentMode = UIViewContentModeScaleAspectFit;
        _scrollUpIcon.clipsToBounds = YES;
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        initialLayoutAttributes.alpha = 1.0;
        [_scrollUpIcon addLayoutAttributes:initialLayoutAttributes forProgress:0.1];
        
        BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributes = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
        finalLayoutAttributes.alpha = 0.0;
        [_scrollUpIcon addLayoutAttributes:finalLayoutAttributes forProgress:0.90];
        [self addSubview:_scrollUpIcon];

    }
    return _scrollUpIcon;
}

- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        _loadingView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor whiteColor] size:40.0f];
        activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        activityIndicatorView.center = CGPointMake(_loadingView.bounds.size.width  / 2,
                                         _loadingView.bounds.size.height / 2);
        [_loadingView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
    return _loadingView;


}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_images count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil) {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.tag = 1;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;

        [view addSubview:imageView];
    }
    else {
        //get a reference to the imageView in the recycled view
        imageView = (UIImageView *)[view viewWithTag:1];
    }
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    [imageView addSubview:self.loadingView];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor clearColor].CGColor];
    gradient.locations = @[@0.0, @0.25, @0.25, @1.0];
    
    view.layer.mask = gradient;
    
    WEAKSELF();

    if (self.event.promoImage != nil && index == 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.event.promoImage.url]];
        [WSELF.loadingView removeFromSuperview];

    } else {
        NSNumber *currentImageRank;
        if (self.event.promoImage != nil) {
            currentImageRank = [NSNumber numberWithInteger:index-1];
        } else {
            currentImageRank = [NSNumber numberWithInteger:index];
        }
        [[self fetchURLForVenueImageWithRank:currentImageRank] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            if (!task.error) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:task.result]];
                [WSELF.loadingView removeFromSuperview];
            } else {
                
            }

            return nil;
        }];

    }
    
    return view;
}

- (BFTask *)fetchURLForVenueImageWithRank:(NSNumber *)rank {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    PFQuery *query = [PFQuery queryWithClassName:@"VenueImage"];
    [query whereKey:@"Venue" equalTo:_venue];
    [query whereKey:@"rank" equalTo:rank];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            [completionSource setError:error];
        } else {
            PFFile *image = (PFFile *)object[@"image"];
            [completionSource setResult:image.url];
        }
    }];
    return completionSource.task;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    [self.pageControl setCurrentPage:swipeView.currentItemIndex];

}



@end