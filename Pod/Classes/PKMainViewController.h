//
//  PKMainViewController.h
//  Pods
//
//  Created by Seiya Shimokawa on 10/8/15.
//
//

#import <UIKit/UIKit.h>

@protocol PKMainViewControllerDelegate;
@class PKMarkableImageView;

@interface PKMainViewController : UIViewController
@property (nonatomic, weak) id<PKMainViewControllerDelegate> delegate;
@property (nonatomic) PKMarkableImageView *snapshotImageView;
@end

@protocol PKMainViewControllerDelegate <NSObject>
- (void)mainViewControllerDidTouchUpLeftButton;
- (void)mainViewControllerDidTouchUpRightButton;
@end