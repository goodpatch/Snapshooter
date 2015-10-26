//
//  PKMarkableImageView.m
//  Pods
//
//  Created by Seiya Shimokawa on 10/22/15.
//
//

#import "PKMarkableImageView.h"

@interface PKMarkableImageView ()
@property (nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic) NSMutableArray<UIImageView *> *markViews;
@end

@implementation PKMarkableImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.markViews = [[NSMutableArray alloc] init];
    
    self.userInteractionEnabled = YES;
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self addGestureRecognizer:self.gestureRecognizer];
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    for (UIImageView *view in self.markViews.copy) {
        if (CGRectContainsPoint(view.frame, [recognizer locationInView:self])) {
            [self animateMarkHide:view completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.markViews removeObject:view];
            }];
            return;
        }
    }
    
    if (self.markViews.count > 0) {
        for (UIImageView *view in self.markViews.copy) {
            [self animateMarkHide:view completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.markViews removeObject:view];
            }];
        }
    }
    
    UIImageView *mark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pk_point" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]];
    [self addSubview:mark];
    mark.center = [recognizer locationInView:self];
    [self.markViews addObject:mark];
    [self animateMarkShow:mark completion:nil];
}

- (void)animateMarkShow:(UIView *)mark completion:(void (^ __nullable)(BOOL finished))completion {
    mark.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        mark.transform = CGAffineTransformIdentity;
    } completion:completion];
}

- (void)animateMarkHide:(UIView *)mark completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        mark.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
        mark.alpha = 0;
    } completion:completion];
}

@end
