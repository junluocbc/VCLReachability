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

+ (void)subscribeToReachabilityNotificationsWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)subscribeToReachabilityForWifiWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)subscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)subscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLReachabilitySubscriber>) delegate;

+ (void)unsubscribeToReachabilityNotificationsWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)unsubscribeToReachabilityForWifiWithDelegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)unsubscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLReachabilitySubscriber>) delegate;
+ (void)unsubscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLReachabilitySubscriber>) delegate;

+ (NSDictionary*)hostNames;
+ (VCLReachability*)internetReachability;
+ (VCLReachability*)wifiReachability;
+ (VCLReachability*)hostNameWithKey:(NSString*)hostName;

+ (NetworkStatus)getCurrentReachabilityStatus;

+ (VCLReachability*)creatOrReturnReachabilityWithReachability:(VCLReachability*)reachability forReachabilityConnection:(VCLReachability*)reachabilityConnectionType;

+ (void)postNotificationTo:(NSString*)postNotificationName withReachability:(VCLReachability*)reachability;

+ (void)setHostNamesWithReachability:(VCLReachability*)reachability forHostName:(NSString*)hostName;

@end
