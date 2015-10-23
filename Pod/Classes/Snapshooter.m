//
//  Snapshooter.m
//  Pods
//
//  Created by Seiya Shimokawa on 10/8/15.
//
//

#import "Snapshooter.h"
#import "PKMainViewController.h"
#import "PKMarkableImageView.h"
#import <ImageIO/ImageIO.h>

@interface Snapshooter () <UIGestureRecognizerDelegate, UIActivityItemSource, PKMainViewControllerDelegate>
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic) UIWindow *pkWindow;
@property (nonatomic) NSDictionary *properties;
@property (nonatomic) UIStatusBarStyle storedStyle;
@end

@implementation Snapshooter

#pragma mark - public

+ (void)enableWithProperties:(NSDictionary *)properties {
    dispatch_async(dispatch_get_main_queue(), ^{
        [Snapshooter.sharedShotter setupWindow];
        Snapshooter.sharedShotter.properties = properties;
    });
}

+ (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (UIApplication.sharedApplication.keyWindow == Snapshooter.sharedShotter.pkWindow) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                return UIInterfaceOrientationMaskPortrait;
            case UIInterfaceOrientationPortraitUpsideDown:
                return UIInterfaceOrientationMaskPortraitUpsideDown;
            case UIInterfaceOrientationLandscapeLeft:
                return UIInterfaceOrientationMaskLandscapeLeft;
            case UIInterfaceOrientationLandscapeRight:
                return UIInterfaceOrientationMaskLandscapeRight;
            default:
                return UIInterfaceOrientationMaskPortrait;
        }
    }
    
    NSArray *supportedOrientations = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    NSUInteger orientationMask = 0;
    for (NSString *orientation in supportedOrientations) {
        if ([orientation isEqualToString:@"UIInterfaceOrientationPortrait"]) {
            orientationMask |= UIInterfaceOrientationMaskPortrait;
        }
        else if ([orientation isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"]) {
            orientationMask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        else if ([orientation isEqualToString:@"UIInterfaceOrientationLandscapeLeft"]) {
            orientationMask |= UIInterfaceOrientationMaskLandscapeLeft;
        }
        else if ([orientation isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) {
            orientationMask |= UIInterfaceOrientationMaskLandscapeRight;
        }
    }
    return orientationMask;
}

#pragma mark - private

+ (instancetype)sharedShotter {
    static Snapshooter *shooter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shooter = [[Snapshooter alloc] init];
    });
    return shooter;
}

- (instancetype)init {
    if (self = [super init]) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidBecomeVisibleNotification:) name:UIWindowDidBecomeVisibleNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
}

- (void)setupWindow {
    if (self.window) return;
    
    self.window = UIApplication.sharedApplication.keyWindow;
    if (!self.window) self.window = UIApplication.sharedApplication.windows.lastObject;
    if (!self.window) [[NSException exceptionWithName:NSGenericException reason:@"Snapshotter no windows" userInfo:nil] raise];
    if (!self.window.rootViewController) [[NSException exceptionWithName:NSGenericException reason:@"Snapshotter no rootViewController on the window" userInfo:nil] raise];
    
    [self addGestureToWindow:self.window];
}

- (void)addGestureToWindow:(UIWindow *)window {
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognized:)];
#if TARGET_IPHONE_SIMULATOR
    gestureRecognizer.numberOfTouchesRequired = 1;
#else
    gestureRecognizer.numberOfTouchesRequired = 2;
#endif
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    gestureRecognizer.delegate = self;
    [window addGestureRecognizer:gestureRecognizer];
}

#pragma mark - selector

- (void)windowDidBecomeVisibleNotification:(NSNotification *)notification {
    UIWindow *window = (UIWindow *)notification.object;
    if (!window || ![window isKindOfClass:UIWindow.class]) return;

    [self addGestureToWindow:window];
}

- (void)swipeGestureRecognized:(UISwipeGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.window.rootViewController.view];
    if (location.y < CGRectGetHeight(self.window.bounds) - 64) return;

    if (UIApplication.sharedApplication.keyWindow == self.pkWindow) return;
    
    CGSize halfSize = CGSizeMake(CGRectGetWidth(self.window.bounds)/2, CGRectGetHeight(self.window.bounds)/2);
    UIGraphicsBeginImageContextWithOptions(halfSize, NO, UIScreen.mainScreen.scale);
    
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        [window drawViewHierarchyInRect:CGRectMake(0, 0, halfSize.width, halfSize.height) afterScreenUpdates:NO];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.pkWindow = [[UIWindow alloc] initWithFrame:self.window.bounds];
    self.pkWindow.windowLevel = UIWindowLevelNormal;
    [self.pkWindow makeKeyAndVisible];
    
    PKMainViewController *mainViewController = [UIStoryboard storyboardWithName:@"Snapshooter" bundle:[NSBundle bundleForClass:[self class]]].instantiateInitialViewController;
    [mainViewController.snapshotImageView setImage:image];
    mainViewController.delegate = self;
    
    self.pkWindow.rootViewController = mainViewController;
    
    self.storedStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - PKMainViewControllerDelegate

- (void)mainViewControllerDidTouchUpLeftButton {
    PKMainViewController *mainViewController = (PKMainViewController *)self.pkWindow.rootViewController;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        mainViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.pkWindow = nil;
        [self.window makeKeyAndVisible];
    }];
}

- (void)mainViewControllerDidTouchUpRightButton {
    PKMainViewController *mainViewController = (PKMainViewController *)self.pkWindow.rootViewController;
    
    NSArray *activityItems = @[self];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [mainViewController presentViewController:activityViewController animated:YES completion:nil];
    activityViewController.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if (completed) {
            [self mainViewControllerDidTouchUpLeftButton];
            [[UIApplication sharedApplication] setStatusBarStyle:self.storedStyle animated:YES];
        }
    };
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [[UIImage alloc] init];
}

- (nullable id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    PKMainViewController *mainViewController = (PKMainViewController *)self.pkWindow.rootViewController;
    
    UIImageView *imageView = mainViewController.snapshotImageView;
    CGSize size = CGSizeMake(CGRectGetWidth(imageView.bounds)/2, CGRectGetHeight(imageView.bounds)/2);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
  
    [imageView drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height) afterScreenUpdates:NO];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([activityType isEqualToString:@"ep.com.goodpatch.goodhub2.shareExtension"]) {
        return @{@"image":image,
                 @"key":self.properties[SnapshotterKeyShareKey]};
    }
    return image;
}

@end
