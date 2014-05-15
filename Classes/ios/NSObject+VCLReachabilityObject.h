//
//  NSObject+VLReachabilityObject.h
//  VLReachability
//
//  Created by Adrian Maurer https://github.com/adrianmaurer on 5/9/14.
//

#import <Foundation/Foundation.h>
#import "VCLReachabilitySubscriber.h"
#import "VCLReachability.h"

@interface NSObject (VCLReachabilityObject)

- (void)reachabilityChanged:(NSNotification *)note;
- (void)wifiReachabilityChanged:(NSNotification *)note;
- (void)internetReachabilityChanged:(NSNotification *)note;
- (void)hostNameReachabilityChanged:(NSNotification *)note;


@end
