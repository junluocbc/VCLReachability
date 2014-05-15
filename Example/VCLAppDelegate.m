//
//  VCLAppDelegate.m
//  VCLReachability
//
//  Created by Adrian Maurer on 5/15/14.
//  Copyright (c) 2014 com.verticodelabs. All rights reserved.
//

#import "VCLAppDelegate.h"
#import "CRToast.h"

@implementation VCLAppDelegate
BOOL isToasting = NO;

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [NSObject subscribeToReachabilityNotificationsWithDelegate:self];
}

/*
 Broadcast based on reachability object to update UI
 */
- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString*)type
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    if (type == NULL && netStatus == NotReachable) {
        if(isToasting) return;
        NSDictionary *options = @{
                                  kCRToastTextKey : @"Connection Not Available",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor orangeColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastInteractionRespondersKey : @[[CRToastInteractionResponder interactionResponderWithInteractionType:
                                                                        CRToastInteractionTypeTap
                                                                                                                       automaticallyDismiss:YES
                                                                                                                                      block:^(CRToastInteractionType interactionType){
                                                                                                                                          NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                                                                                      }]]
                                  };
        isToasting = YES;
        [CRToastManager showNotificationWithOptions:options completionBlock:^{
            NSLog(@"Completed");
            isToasting = NO;
        }];
        
    }
    
}


@end
