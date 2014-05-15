//
//  APLSubscribeToReachability.h
//  VLReachability protocol
//
//  Created by Adrian Maurer https://github.com/adrianmaurer on 5/2/14.
//

#import <Foundation/Foundation.h>
#import "VCLReachability.h"

@protocol VCLSubscribeToReachability

- (void)reachabilityChanged:(NSNotification *)note; // handler for change in reachability
- (void)wifiReachabilityChanged:(NSNotification *)note;
- (void)internetReachabilityChanged:(NSNotification *)note;
- (void)hostNameReachabilityChanged:(NSNotification *)note;

+ (NetworkStatus)getCurrentReachabilityStatus;

+ (VCLReachability*)creatOrReturnReachabilityWithReachability:(VCLReachability*)reachability forReachabilityConnection:(VCLReachability*)reachabilityConnectionType;

+ (void)postNotificationTo:(NSString*)postNotificationName withReachability:(VCLReachability*)reachability;

+ (void)subscribeToReachabilityNotificationsWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)subscribeToReachabilityForWifiWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)subscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)subscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLSubscribeToReachability>) delegate;

+ (void)unsubscribeToReachabilityNotificationsWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)unsubscribeToReachabilityForWifiWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)unsubscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)unsubscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLSubscribeToReachability>) delegate;

@optional
- (void)updateInternetWithReachability:(VCLReachability *)reachability;
- (void)updateHostNameWithReachability:(VCLReachability *)reachability;
- (void)updateWifiWithReachability:(VCLReachability *)reachability;
- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString*)type;

@end




