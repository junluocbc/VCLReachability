//
//  VCLReachabilitySubscriber.h
//  VCLReachabilitySubscriber protocol
//
//  Created by Adrian Maurer https://github.com/adrianmaurer on 5/2/14.
//

#import <Foundation/Foundation.h>

@class VCLReachability;

@protocol VCLReachabilitySubscriber

/*
 * Recieve change it network events
 */
+ (void)reachabilityChanged:(NSNotification *)note;
+ (void)wifiReachabilityChanged:(NSNotification *)note;
+ (void)internetReachabilityChanged:(NSNotification *)note;
+ (void)hostNameReachabilityChanged:(NSNotification *)note;

@optional
/*
 * Resolve change it network events
 */
- (void)updateInternetWithReachability:(VCLReachability *)reachability;
- (void)updateHostNameWithReachability:(VCLReachability *)reachability;
- (void)updateWifiWithReachability:(VCLReachability *)reachability;
- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString*)type;

@end






