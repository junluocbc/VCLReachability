//
//  NSObject+VLReachabilityObject.m
//  VLReachability
//
//  Note: Taking advantage of ARC to clean up any observers. 
//
//  Created by Adrian Maurer https://github.com/adrianmaurer on 5/9/14.
//


#import "NSObject+VCLReachabilityObject.h"

@implementation NSObject (VCLReachabilityObject)

#pragma mark - VLReachability Objects

static VCLReachability* _internetReachability;
static VCLReachability* _wifiReachability;

static NSMutableDictionary* _hostNames;

#pragma mark - Subscription Methods

/*
 Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
 */
+ (void)subscribeToReachabilityNotificationsWithDelegate:(id<VCLSubscribeToReachability>) delegate {
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}


/*
 Subscribe to changes in WiFI VLReachability
 */
+ (void)unsubscribeToReachabilityNotificationsWithDelegate:(id<VCLSubscribeToReachability>) delegate {
    /*
     Unobserve the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] removeObserver:delegate name:kReachabilityChangedNotification object:nil];
}

+ (void)subscribeToReachabilityForWifiWithDelegate:(id<VCLSubscribeToReachability>) delegate {
    
    // If an instance of _wifiReachability isn't created yet create one
    _wifiReachability = [NSObject creatOrReturnReachabilityWithReachability:_wifiReachability forReachabilityConnection:[VCLReachability reachabilityForLocalWiFi]];

    // Subscribe to change in network connectivity for wifi instance of reachability only
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(wifiReachabilityChanged:) name:kWifiReachabilityChangedNotification object:_wifiReachability];
    
    // send the first notification
    [NSObject postNotificationTo:kWifiReachabilityChangedNotification withReachability:_wifiReachability];
}

/*
 Unsubscribe to changes in WiFI VLReachability
 */
+ (void)unsubscribeToReachabilityForWifiWithDelegate:(id<VCLSubscribeToReachability>) delegate {
    [[NSNotificationCenter defaultCenter] removeObserver:delegate name:kWifiReachabilityChangedNotification object:_wifiReachability];
}

/*
 Subscribe to changes in Host Name VLReachability
 */
+ (void)subscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLSubscribeToReachability>) delegate {
    // If an instance of _hostNames isn't created yet create one
    if (!_hostNames) {
        _hostNames = [NSMutableDictionary new];
    }
    
    // If an instance of hostName reachability isn't created yet create one
    if(![_hostNames objectForKey:hostName]) {
        VCLReachability* newReachability;
        [_hostNames setObject:[NSObject creatOrReturnReachabilityWithReachability:newReachability forReachabilityConnection:[VCLReachability reachabilityWithHostName:hostName]] forKey:hostName];
    }
    
    // Subscribe to change in network connectivity for wifi instance of reachability only
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(hostNameReachabilityChanged:) name:kHostNameReachabilityChangedNotification object:[_hostNames objectForKey:hostName]];
    
    // send the first notification
    [NSObject postNotificationTo:kHostNameReachabilityChangedNotification withReachability:[_hostNames objectForKey:hostName]];
}

/*
 Unsubscribe to changes in Host Name VLReachability
 */
+ (void)unsubscribeToReachabilityForHostNameWithName:(NSString *)hostName delegate:(id<VCLSubscribeToReachability>) delegate {
    [[NSNotificationCenter defaultCenter] removeObserver:delegate name:kHostNameReachabilityChangedNotification object:[_hostNames objectForKey:hostName]];
}

/*
 Subscribe to changes in Internet VLReachability
 */
+ (void)subscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLSubscribeToReachability>) delegate {
    // If an instance of _internetReachability isn't created yet create one
    _internetReachability = [NSObject creatOrReturnReachabilityWithReachability:_internetReachability forReachabilityConnection:[VCLReachability reachabilityForInternetConnection]];
        
    // Subscribe to change in network connectivity for internet instance of reachability only
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(internetReachabilityChanged:) name:kInternetReachabilityChangedNotification object:_internetReachability];
    
    // send the first notification
    [NSObject postNotificationTo:kInternetReachabilityChangedNotification withReachability:_internetReachability];
}

/*
 Unsubscribe to changes in Internet VLReachability
 */
+ (void)unsubscribeToReachabilityForInternetConnectionWithDelegate:(id<VCLSubscribeToReachability>) delegate {
    [[NSNotificationCenter defaultCenter] removeObserver:delegate name:kInternetReachabilityChangedNotification object:_internetReachability];
}

#pragma mark - Publish Methods

+ (void)postNotificationTo:(NSString*)postNotificationName withReachability:(VCLReachability*)reachability {
    [[NSNotificationCenter defaultCenter] postNotificationName: postNotificationName object: reachability];
}

#pragma mark - VLReachability Change

/*!
 * Called by VLReachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note
{
	VCLReachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[VCLReachability class]]);
    
    // If this is a generic callback
//    if (curReach != _wifiReachability && curReach != _internetReachability && ![_hostNames objectExistsInKeys:[_hostNames allKeys] forObject:curReach]) {
        [(id<VCLSubscribeToReachability>)self updateWithReachability:curReach forType:nil];
//    }
}

/*!
 * Called by VLReachability whenever WiFi status changes.
 */
- (void)wifiReachabilityChanged:(NSNotification *)note
{
    VCLReachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[VCLReachability class]]);
    
    // If a wifi specific callback is available call it
    if ([self respondsToSelector:@selector(updateWifiWithReachability:)]) {
        [(id<VCLSubscribeToReachability>)self updateWifiWithReachability:curReach];
    } else {
        [(id<VCLSubscribeToReachability>)self updateWithReachability:curReach forType:TYPE_WIFI];
    }

}

/*!
 * Called by VLReachability whenever Internet status changes.
 */
- (void)internetReachabilityChanged:(NSNotification *)note
{
    VCLReachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[VCLReachability class]]);
    
    // If a internet specific callback is available call it
    if ([self respondsToSelector:@selector(updateInternetWithReachability:)]) {
        [(id<VCLSubscribeToReachability>)self updateInternetWithReachability:curReach];
    } else {
        [(id<VCLSubscribeToReachability>)self updateWithReachability:curReach forType:TYPE_INTERNET];
    }
}

/*!
 * Called by VLReachability whenever HostName status changes.
 */
- (void)hostNameReachabilityChanged:(NSNotification *)note
{
    VCLReachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[VCLReachability class]]);
    
    // If a host name specific callback is available call it
    if ([self respondsToSelector:@selector(updateHostNameWithReachability:)]) {
        [(id<VCLSubscribeToReachability>)self updateHostNameWithReachability:curReach];
    } else {
        [(id<VCLSubscribeToReachability>)self updateWithReachability:curReach forType:TYPE_HOSTNAME];
    }
}

#pragma mark - Getters

+ (VCLReachability*)internetReachability{
    return _internetReachability;
}
+ (VCLReachability*)wifiReachability{
    return _wifiReachability;
}
+ (NSMutableDictionary*)hostNames{
    return _hostNames;
}
+ (VCLReachability*)hostNameWithKey:(NSString*)hostName{
    return [_hostNames valueForKey:hostName];
}

+ (NetworkStatus)getCurrentReachabilityStatus {
    [NSObject creatOrReturnReachabilityWithReachability:_internetReachability forReachabilityConnection:[VCLReachability reachabilityForInternetConnection]];
    return [_internetReachability currentReachabilityStatus];
}

#pragma mark - Setters

+ (void)setHostNamesWithReachability:(VCLReachability*)reachability forHostName:(NSString*)hostName {
    [_hostNames setObject:reachability forKey:hostName];
}

+ (VCLReachability*)creatOrReturnReachabilityWithReachability:(VCLReachability*)reachability forReachabilityConnection:(VCLReachability*)reachabilityConnectionType {
    if (!reachability) {
        reachability = reachabilityConnectionType;
        [reachability startNotifier];
    }
    return reachability;
}

@end
