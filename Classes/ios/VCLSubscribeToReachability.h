//
//  APLSubscribeToReachability.h
//  VLReachability protocol
//
//  Created by Adrian Maurer https://github.com/adrianmaurer on 5/2/14.
//

#import <Foundation/Foundation.h>
#import "VCLReachability.h"

@protocol VCLReachabilitySubscriber

- (void)reachabilityChanged:(NSNotification *)note; // handler for change in reachability
- (void)wifiReachabilityChanged:(NSNotification *)note;
- (void)internetReachabilityChanged:(NSNotification *)note;
- (void)hostNameReachabilityChanged:(NSNotification *)note;

+ (NetworkStatus)getCurrentReachabilityStatus;

+ (VCLReachability*)creatOrReturnReachabilityWithReachability:(VCLReachability*)reachability forReachabilityConnection:(VCLReachability*)reachabilityConnectionType;

+ (void)postNotificationTo:(NSString*)postNotificationName withReachability:(VCLReachability*)reachability;

+ (void)subscribeToReachabilityNotificationsWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)subscribeToReachabilityForWifiWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)subscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)subscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLReachabilitySubscriber>) delegate;

+ (void)unsubscribeToReachabilityNotificationsWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)unsubscribeToReachabilityForWifiWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)unsubscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)unsubscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLReachabilitySubscriber>) delegate;

@optional
- (void)updateInternetWithReachability:(VCLReachability *)reachability;
- (void)updateHostNameWithReachability:(VCLReachability *)reachability;
- (void)updateWifiWithReachability:(VCLReachability *)reachability;
- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString*)type;

@end




