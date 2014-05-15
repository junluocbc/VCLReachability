//
//  NSObject+VLReachabilityObject.h
//  VLReachability
//
//  Created by Adrian Maurer https://github.com/adrianmaurer on 5/9/14.
//

#import <Foundation/Foundation.h>
#import "VCLReachability.h"
#import "VCLSubscribeToReachability.h"

@interface NSObject (VCLReachabilityObject)

- (void)reachabilityChanged:(NSNotification *)note;
- (void)wifiReachabilityChanged:(NSNotification *)note;
- (void)internetReachabilityChanged:(NSNotification *)note;
- (void)hostNameReachabilityChanged:(NSNotification *)note;

+ (void)subscribeToReachabilityNotificationsWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)subscribeToReachabilityForWifiWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)subscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)subscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLSubscribeToReachability>) delegate;

+ (void)unsubscribeToReachabilityNotificationsWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)unsubscribeToReachabilityForWifiWithDelegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)unsubscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLSubscribeToReachability>) delegate;
+ (void)unsubscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLSubscribeToReachability>) delegate;

+ (NSDictionary*)hostNames;
+ (VCLReachability*)internetReachability;
+ (VCLReachability*)wifiReachability;
+ (VCLReachability*)hostNameWithKey:(NSString*)hostName;

+ (NetworkStatus)getCurrentReachabilityStatus;

+ (VCLReachability*)creatOrReturnReachabilityWithReachability:(VCLReachability*)reachability forReachabilityConnection:(VCLReachability*)reachabilityConnectionType;

+ (void)postNotificationTo:(NSString*)postNotificationName withReachability:(VCLReachability*)reachability;

+ (void)setHostNamesWithReachability:(VCLReachability*)reachability forHostName:(NSString*)hostName;

@end
