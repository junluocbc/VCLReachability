//
//  VCLReachabilityTests.m
//  VCLReachabilityTests
//
//  Created by Adrian Maurer on 5/15/14.
//  Copyright (c) 2014 com.verticodelabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+VCLReachabilitySubscriber.h"

#define BASE_TIMEOUT 10000000 // 10000000 nanoseconds = 10 milliseconds
#define DEFAULT_TIMEOUT BASE_TIMEOUT // 10 milliseconds
#define HOSTNAME_TIMEOUT BASE_TIMEOUT*50 // give .5 second for the DNS to work things out
#define LONG_TIMEOUT BASE_TIMEOUT*200 // 2 seconds

#define PROPER_TEST_HOSTNAME @"google.com"
#define TEST_HOSTNAME PROPER_TEST_HOSTNAME

@interface TestSubscriber : NSObject <VCLReachabilitySubscriber> {
@public
    VCLReachability *reachability;
    NetworkStatus netStatus;
    dispatch_semaphore_t semaphore;
}
@end

@implementation TestSubscriber

- (id)init {
    self = [super init];
    if (self) {
        self->semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

#pragma mark - PROTOCOL

- (void)reachabilityChanged:(NSNotification *)note {
    [self handleChangeNotification:note];
}

- (void)wifiReachabilityChanged:(NSNotification *)note {
    [self handleChangeNotification:note];
}

- (void)internetReachabilityChanged:(NSNotification *)note {
    [self handleChangeNotification:note];
}

- (void)hostNameReachabilityChanged:(NSNotification *)note {
    [self handleChangeNotification:note];
}

#pragma mark - PRIVATE

- (void)handleChangeNotification:(NSNotification *)note {
    self->reachability = [note object];
    dispatch_semaphore_signal(self->semaphore);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface VCLReachabilityTests : XCTestCase

@end

@implementation VCLReachabilityTests

VCLReachability *reachability;
NetworkStatus netStatus;
dispatch_semaphore_t semaphoreSub;

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - TESTS

-(void)testReachabilityChanged {
    NetworkStatus netStatus = [VCLReachability currentReachabilityStatus];
    XCTAssert(netStatus != NotReachable, @"Should create instance of reachability and be connected to interet");
}

-(void)testSubscribeToReachabilityNotifications{
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate];
    XCTAssertTrue(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT)), @"timeout");
    XCTAssertTrue([delegate->reachability isKindOfClass:[VCLReachability class]]);
    XCTAssertTrue([delegate->reachability notificationType] == kReachabilityChangedNotification);
    XCTAssert(YES);
}

-(void)testSubscribeToReachabilityNotificationsForWifi{
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate];
    XCTAssertTrue(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT)), @"timeout");
    XCTAssertTrue([delegate->reachability isKindOfClass:[VCLReachability class]]);
    XCTAssertTrue([delegate->reachability notificationType] == kWifiReachabilityChangedNotification);
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:delegate];
    XCTAssert(YES);
}

-(void)testSubscribeToReachabilityNotificationsHostName{
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate];
    XCTAssertTrue(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT)), @"timeout");
    XCTAssertTrue([delegate->reachability isKindOfClass:[VCLReachability class]]);
    XCTAssertTrue([delegate->reachability notificationType] == kHostNameReachabilityChangedNotification);
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate];
    XCTAssert(YES);
}

-(void)testSubscribeToReachabilityNotificationsForInternet{
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate];
    XCTAssertTrue(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT)), @"timeout");
    XCTAssertTrue([delegate->reachability isKindOfClass:[VCLReachability class]]);
    XCTAssertTrue([delegate->reachability notificationType] == kInternetReachabilityChangedNotification);
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:delegate];
    XCTAssert(YES);
}

-(void)testUnsubsrcibeToReachability {
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate];
    dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT));
    [VCLReachability unsubscribeToReachabilityNotificationsWithDelegate:delegate];
    XCTAssertFalse(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, LONG_TIMEOUT)));
    [VCLReachability unsubscribeToReachabilityNotificationsWithDelegate:delegate];
    XCTAssert(YES);
}

-(void)testUnsubsrcibeToReachabilityForWifi {
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate];
    dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT));
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:delegate];
    XCTAssertFalse(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, LONG_TIMEOUT)));
    XCTAssert(YES);
}

-(void)testUnsubsrcibeToReachabilityForHostName {
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate];
    dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT));
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate];
    XCTAssertFalse(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, LONG_TIMEOUT)));
    XCTAssert(YES);
}

-(void)testUnsubsrcibeToReachabilityForInternet {
    TestSubscriber * delegate = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate];
    dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, DEFAULT_TIMEOUT));
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:delegate];
    XCTAssertFalse(0 == dispatch_semaphore_wait(delegate->semaphore, dispatch_time(DISPATCH_TIME_NOW, LONG_TIMEOUT)));
    XCTAssert(YES);
}

-(void)testMultipleSubscriptionToReachability{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate1];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate1];
    TestSubscriber * delegate2 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate2];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate2];

    [VCLReachability unsubscribeToReachabilityNotificationsWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityNotificationsWithDelegate:delegate2];

    XCTAssert(YES);
}

-(void)testMultipleSubscriptionToReachabilityForWifi{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate1];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate1];
    TestSubscriber * delegate2 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate2];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate2];
    
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:delegate2];
    XCTAssert(YES);
}

-(void)testMultipleSubscriptionToReachabilityForHostName{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate1];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate1];
    TestSubscriber * delegate2 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForHostNameWithName:@"apple.com" delegate:delegate2];
    [VCLReachability subscribeToReachabilityForHostNameWithName:@"cbc.ca" delegate:delegate2];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate2];
    TestSubscriber * delegate3 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate3];
    [VCLReachability subscribeToReachabilityForHostNameWithName:@"cbc.ca" delegate:delegate3];
    [VCLReachability subscribeToReachabilityForHostNameWithName:@"apple.com" delegate:delegate3];

    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate2];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate3];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:@"apple.com" delegate:delegate2];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:@"apple.com" delegate:delegate3];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:@"cbc.ca" delegate:delegate2];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:@"cbc.ca" delegate:delegate3];

    XCTAssert(YES);
}

-(void)testMultipleSubscriptionToReachabilityForInternet{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate1];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate1];
    TestSubscriber * delegate2 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate2];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate2];
    
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:delegate2];

    XCTAssert(YES);
}

-(void)testOverUnsubscriptionToReachability{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityNotificationsWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityNotificationsWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityNotificationsWithDelegate:delegate1];
    XCTAssert(YES);
}

-(void)testOverUnsubscriptionToReachabilityForWifi{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForWifiWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForWifiWithDelegate:delegate1];
    XCTAssert(YES);
}

-(void)testOverUnsubscriptionToReachabilityForInternet{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForInternetConnectionWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForInternetConnectionWithDelegate:delegate1];
    XCTAssert(YES);
}

-(void)testOverUnsubscriptionToReachabilityForHostname{
    TestSubscriber * delegate1 = [[TestSubscriber alloc] init];
    [VCLReachability subscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate1];
    [VCLReachability unsubscribeToReachabilityForHostNameWithName:TEST_HOSTNAME delegate:delegate1];
    XCTAssert(YES);
}


//- (void)updateWithReachability:(VCLReachability *)reachability forType:(NSString *)type
//{
//    XCTAssert(type != TYPE_WIFI && type != TYPE_HOSTNAME && type != TYPE_INTERNET , @"updateInternetWithReachability");
//}
//
//- (void)updateInternetWithReachability:(VCLReachability *)reachability {
//    XCTAssert(YES, @"updateInternetWithReachability");
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
//- (void)showNotUpdateWithReachability:(VCLReachability *)reachability forType:(NSString*)type {
//    XCTAssert(YES, @"updateWithReachability");
//}
//
//- (void)shouldNotReciveWifiNotification:(NSNotification *)note {
//    XCTAssert(NO, @"shouldNotReciveWifiNotification");
//}
//
//- (void)shouldNotReciveHostNameNotification:(NSNotification *)note {
//    XCTAssert(NO, @"shouldNotReciveHostNameNotification");
//}
//
//- (void)shouldNotReciveInternetNotification:(NSNotification *)note {
//    XCTAssert(NO, @"shouldNotReciveWifiNotification");
//}

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
