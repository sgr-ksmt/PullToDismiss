//
//  CustomShadowEffect.h
//  ObjcDemo
//
//  Created by Suguru Kishimoto on 3/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PullToDismiss;

@interface CustomShadowEffect : NSObject <BackgroundEffect>
@property (nonatomic, strong) UIColor * _Nullable color;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, readonly) enum BackgroundTarget target;

@end
