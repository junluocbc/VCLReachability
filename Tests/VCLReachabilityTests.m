//
//  VCLReachabilityTests.m
//  VCLReachabilityTests
//
//  Created by Adrian Maurer on 5/15/14.
//  Copyright (c) 2014 com.verticodelabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+VCLReachabilitySubscriber.h"

@interface VCLReachabilityTests : XCTestCase <VCLReachabilitySubscriber>

@end

@implementation VCLReachabilityTests

- (void)setUp
{
    [super setUp];
    [VCLReachability subscribeToReachabilityForHostNameWithName:@"google.com" delegate:self];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:self];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:self];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:self];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - TESTS

-(void)testReachabilityChanged {
    NetworkStatus netStatus = [VCLReachability currentReachabilityStatus];
    XCTAssert(netStatus != NotReachable, @"Should create instance of reachability and be connected to interet");
    
}

-(void)testSubscribeToReachabilityNotifications{
    XCTAssert(YES, @"testSubscribeToReachabilityNotifications");
}

-(void)testSubscribeToReachabilityNotificationsForWifi{
    XCTAssert(YES, @"testSubscribeToReachabilityNotificationsForWifi");
}

-(void)testSubscribeToReachabilityNotificationsHostName{
    XCTAssert(YES, @"testSubscribeToReachabilityNotificationsHostName");
}

-(void)testSubscribeToReachabilityNotificationsForInternet{
    XCTAssert(YES, @"testSubscribeToReachabilityNotificationsForInternet");
}

-(void)testUnsubsrcibeToReachability {
    XCTAssert(YES, @"testUnsubsrcibeToReachability");
}

-(void)testUnsubsrcibeToReachabilityForWifi {
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldNotReciveWifiNotification:) name:kWifiReachabilityChangedNotification object:[VCLReachability wifiReachability]];
    [VCLReachability postNotificationTo:kWifiReachabilityChangedNotification withReachability:[VCLReachability wifiReachability]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWifiReachabilityChangedNotification object:[VCLReachability wifiReachability]];
}

-(void)testUnsubsrcibeToReachabilityForHostName {
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:@"google.com" delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldNotReciveHostNameNotification:) name:kHostNameReachabilityChangedNotification object:[VCLReachability hostNameWithKey:@"google.com"]];
    [VCLReachability postNotificationTo:kHostNameReachabilityChangedNotification withReachability:[VCLReachability hostNameWithKey:@"google.com"]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHostNameReachabilityChangedNotification object:[VCLReachability hostNameWithKey:@"google.com"]];
}

-(void)testUnsubsrcibeToReachabilityForInternet {
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldNotReciveInternetNotification:) name:kInternetReachabilityChangedNotification object:nil];
    [VCLReachability postNotificationTo:kInternetReachabilityChangedNotification withReachability:[VCLReachability internetReachability]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInternetReachabilityChangedNotification object:[VCLReachability internetReachability]];
}


#pragma mark - PROTOCOL

//- (void)reachabilityChanged:(NSNotification *)note {
//    XCTAssert(YES, @"reachabilityChanged");
//    NSLog(@"reachabilityChanged");
//}
//
//- (void)wifiReachabilityChanged:(NSNotification *)note {
//    XCTAssert(YES, @"wifiReachabilityChanged");
//    NSLog(@"wifiReachabilityChanged");
//}
//
//- (void)internetReachabilityChanged:(NSNotification *)note {
//    XCTAssert(YES, @"internetReachabilityChanged");
//    NSLog(@"internetReachabilityChanged");
//}
//
//- (void)hostNameReachabilityChanged:(NSNotification *)note {
//    XCTAssert(YES, @"hostNameReachabilityChanged");
//    NSLog(@"hostNameReachabilityChanged");
//}

- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString *)type
{
    XCTAssert(type != TYPE_WIFI && type != TYPE_HOSTNAME && type != TYPE_INTERNET , @"updateInternetWithReachability");
    
}

- (void)updateInternetWithReachability:(VCLReachability *)reachability {
    XCTAssert(YES, @"updateInternetWithReachability");
}

- (void)updateHostNameWithReachability:(VCLReachability *)reachability {
    XCTAssert(YES, @"updateHostNameWithReachability");
}

- (void)updateWifiWithReachability:(VCLReachability *)reachability {
    XCTAssert(YES, @"updateWifiWithReachability");
}

- (void)showNotUpdateWithReachability:(VCLReachability *)reachability forType:(NSString*)type {
    XCTAssert(YES, @"updateWithReachability");
}

- (void)shouldNotReciveWifiNotification:(NSNotification *)note {
    XCTAssert(NO, @"shouldNotReciveWifiNotification");
}

- (void)shouldNotReciveHostNameNotification:(NSNotification *)note {
    XCTAssert(NO, @"shouldNotReciveHostNameNotification");
}

- (void)shouldNotReciveInternetNotification:(NSNotification *)note {
    XCTAssert(NO, @"shouldNotReciveWifiNotification");
}

//- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString*)type {
//    XCTAssert(YES, @"updateWithReachability");
//}
//
//- (void)updateHostNameWithReachability:(VCLReachability *)reachability {
//    XCTAssert(YES, @"updateHostNameWithReachability");
//}
//
//- (void)updateWifiWithReachability:(VCLReachability *)reachability {
//    XCTAssert(YES, @"updateWifiWithReachability");
//}
//
//- (void)updateInternetWithReachability:(VCLReachability *)reachability {
//    XCTAssert(YES, @"updateInternetWithReachability");
//}

@end
