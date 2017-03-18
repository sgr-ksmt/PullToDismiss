//
//  CustomShadowEffect.m
//  ObjcDemo
//
//  Created by Suguru Kishimoto on 3/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

#import "CustomShadowEffect.h"
@import PullToDismiss;

@implementation CustomShadowEffect

- (UIView * _Nonnull)makeBackgroundView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = self.color;
    view.alpha = self.alpha;
    return view;
}

- (void)applyEffectWithView:(UIView * _Nullable)view rate:(CGFloat)rate {
    view.alpha = self.alpha * rate;
}

@end
