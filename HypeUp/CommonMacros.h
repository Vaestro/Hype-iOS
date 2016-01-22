
//
//  CommonMacros.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#ifndef HypeUp_CommonMacros_h
#define HypeUp_CommonMacros_h
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define DiscoveryCellHeight(v)              v * 0.66
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
//#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];

#pragma mark - Personal
#define WSELF weakSelf
#define SSELF strongSelf
#define WEAKSELF() __weak __typeof(&*self)WSELF = self
#define STRONGSELF() __typeof(&*self)SSELF = WSELF

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#define DLOG_METHOD DLog(@"");

#define DELEGATE_CAPABLE(delegate, selector) [delegate respondsToSelector:selector]

#define NSStringFromInteger(i) [NSString stringWithFormat:@"%ld", (long)i]
#define NSStringFromUInteger(i) [NSString stringWithFormat:@"%ld", (long)i]
#define NSStringFromInt(i) [NSString stringWithFormat:@"%ld", (long)i]
#define NSStringFromCGFloat(i) [NSString stringWithFormat:@"%f", i]
#define NSStringFromBool(i) (i ? @"YES" : @"NO")


UIKIT_STATIC_INLINE UIEdgeInsets
UIEdgeInsetsMake1(CGFloat inset)
{
	UIEdgeInsets insets = {inset, inset, inset, inset};
	return insets;
}
UIKIT_STATIC_INLINE UIEdgeInsets
UIEdgeInsetsMake2(CGFloat insetY, CGFloat insetX)
{
	UIEdgeInsets insets = {insetY, insetX, insetY, insetX};
	return insets;
}
UIKIT_STATIC_INLINE UIEdgeInsets
UIEdgeInsetsMake3Y(CGFloat insetY, CGFloat left, CGFloat right)
{
	UIEdgeInsets insets = {insetY, left, insetY, right};
	return insets;
}
UIKIT_STATIC_INLINE UIEdgeInsets
UIEdgeInsetsMake3X(CGFloat top, CGFloat insetX, CGFloat bottom)
{
	UIEdgeInsets insets = {top, insetX, bottom, insetX};
	return insets;
}

UIKIT_STATIC_INLINE CGFloat
UIEdgeInsetsGetHorizontal(const UIEdgeInsets insets)
{
	return insets.left + insets.right;
}
UIKIT_STATIC_INLINE CGFloat
UIEdgeInsetsGetVertical(const UIEdgeInsets insets)
{
	return insets.top + insets.bottom;
}
UIKIT_STATIC_INLINE CGRect
UIEdgeInsetsGrowRect(CGRect rect, UIEdgeInsets insets)
{
	rect.origin.x    -= insets.left;
	rect.origin.y    -= insets.top;
	rect.size.width  += (insets.left + insets.right);
	rect.size.height += (insets.top  + insets.bottom);
	return rect;
}
UIKIT_STATIC_INLINE UIEdgeInsets
UIEdgeInsetsAdd(UIEdgeInsets insets1, UIEdgeInsets insets2)
{
	UIEdgeInsets insets = {insets1.top+insets2.top, insets1.left+insets2.left, insets1.bottom+insets2.bottom, insets1.right+insets2.right};
	return insets;
}

CG_INLINE CGSize
CGSizeDivisible(CGSize size, CGFloat divisor)
{
	size.width  = ceilf(size.width  / divisor) * divisor;
	size.height = ceilf(size.height / divisor) * divisor;
	return size;
}

CG_INLINE CGSize
CGSizeMake1(CGFloat side)
{
	CGSize size; size.width = side; size.height = side; return size;
}

CG_INLINE CGPoint
CGRectGetCenterPoint(CGRect rect) {
	CGPoint p = rect.origin;
	p.x += rect.size.width/2;
	p.y += rect.size.height/2;
	return p;
}
CG_INLINE CGPoint
CGRectGetTopLeftPoint(CGRect rect) {
	CGPoint p = rect.origin;
	return p;
}
CG_INLINE CGPoint
CGRectGetTopRightPoint(CGRect rect) {
	CGPoint p = rect.origin;
	p.x += rect.size.width;
	return p;
}
CG_INLINE CGPoint
CGRectGetBottomLeftPoint(CGRect rect) {
	CGPoint p = rect.origin;
	p.y += rect.size.height;
	return p;
}
CG_INLINE CGPoint
CGRectGetBottomRightPoint(CGRect rect) {
	CGPoint p = rect.origin;
	p.x += rect.size.width;
	p.y += rect.size.height;
	return p;
}
CG_INLINE CGPoint
CGRectGetRelativePoint(CGRect rect, CGPoint anchor) {
	CGPoint p = rect.origin;
	p.x += rect.size.width*anchor.x;
	p.y += rect.size.height*anchor.y;
	return p;
}
CG_INLINE CGRect
CGRectFromOriginAndSize(CGPoint origin, CGSize size) {
	CGRect r = (CGRect){origin,size};
	return r;
}
CG_INLINE CGRect
CGRectFromOriginAndSizeAnchored(CGPoint origin, CGSize size, CGPoint anchor) {
	CGRect r = (CGRect){origin,size};
	r.origin.x -= anchor.x * size.width;
	r.origin.y -= anchor.y * size.height;
	return r;
}
CG_INLINE CGRect
CGRectAlignToRect(CGRect rect, CGRect referenceRect, CGPoint alignment)
{
	rect.origin.x = referenceRect.origin.x + alignment.x * (rect.size.width  - referenceRect.size.width);
	rect.origin.y = referenceRect.origin.y + alignment.y * (rect.size.height - referenceRect.size.height);
	return rect;
}
CG_INLINE CGRect
CGRectCenterInRect(CGRect rect, CGRect referenceRect)
{
	rect.origin.x = referenceRect.origin.x + (referenceRect.size.width  - rect.size.width ) / 2;
	rect.origin.y = referenceRect.origin.y + (referenceRect.size.height - rect.size.height) / 2;
	return rect;
}

CG_INLINE CGRect
CGRectBounds(CGRect rect)
{
	rect.origin = CGPointZero;
	return rect;
}

