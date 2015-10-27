//
//  PKMainViewController.m
//  Pods
//
//  Created by Seiya Shimokawa on 10/8/15.
//
//

#import "PKMainViewController.h"
#import "PKMarkableImageView.h"

@interface PKMainViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PKMainViewController

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.snapshotImageView = [[PKMarkableImageView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    self.snapshotImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.snapshotImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.snapshotImageView];
    [self.scrollView addConstraints:@[
                                      [NSLayoutConstraint constraintWithItem:self.snapshotImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                      [NSLayoutConstraint constraintWithItem:self.snapshotImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                      [NSLayoutConstraint constraintWithItem:self.snapshotImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                                      ]];
    
    CGSize size = self.scrollView.bounds.size;
    CGSize imageSize = self.snapshotImageView.image.size;
    CGSize contentSize = CGSizeMake(size.width, size.width/imageSize.width * imageSize.height);
    [self.snapshotImageView addConstraints:@[
                                             [NSLayoutConstraint constraintWithItem:self.snapshotImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:contentSize.height]
                                             ]];
    self.scrollView.contentSize = contentSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 1;
    } completion:nil];
}

- (IBAction)touchUpInsideLeftButton:(UIButton *)sender {
    [self.delegate mainViewControllerDidTouchUpLeftButton];
}

- (IBAction)touchUpInsideRightButton:(UIButton *)sender {
    [self.delegate mainViewControllerDidTouchUpRightButton];
}

@end
