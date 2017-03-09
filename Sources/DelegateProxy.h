//
//  DelegateProxy.h
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 3/7/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelegateProxy : NSObject
- (nonnull instancetype)initWithDelegates:(NSArray<id> * __nonnull)delegates NS_REFINED_FOR_SWIFT;
@end
