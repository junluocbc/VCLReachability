//
//  VCLAppDelegate.h
//  VCLReachability
//
//  Created by Adrian Maurer on 5/15/14.
//  Copyright (c) 2014 com.verticodelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+VCLReachabilityObject.h"

@interface VCLAppDelegate : UIResponder <UIApplicationDelegate, VCLReachabilitySubscriber>

@property (strong, nonatomic) UIWindow *window;

@end
