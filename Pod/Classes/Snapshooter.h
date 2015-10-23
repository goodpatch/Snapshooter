//
//  Snapshotter.h
//  Pods
//
//  Created by Seiya Shimokawa on 10/8/15.
//
//

#import <Foundation/Foundation.h>

@interface Snapshooter : NSObject

+ (void)enableWithProperties:(NSDictionary *)properties;
+ (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(UIWindow *)window;

@end

static NSString *const SnapshotterKeyShareKey = @"shareKey";