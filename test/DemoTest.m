//
//  DemoTest.m
//  ostentation
//
//  Created by JiangCai on 2019/3/5.
//  Copyright © 2019 fortune. All rights reserved.
//

#import "DemoTest.h"
#import "SecurityHelper.h"
#import "NSBool.h"

@implementation DemoTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSecurity {
    
    NSDictionary* d1 = @{@"url":@"https://www.baidu.com"};
    
    NSData* d1d = [NSJSONSerialization dataWithJSONObject:d1 options:0 error:nil];
    XCTAssertEqualObjects([NSJSONSerialization JSONObjectWithData:d1d options:0
                                                            error:nil][@"url"],@"https://www.baidu.com");
    
    // 创建一个经典数据。
    NSDictionary* data = @{
                           @"name" : @"福特毛",
                           @"longNumber":@(1551953104900),
                           @"gender": [NSBool boolWithValue:true],
                           @"size": @(1)
    };
    
    SecurityHelper* helper = [[SecurityHelper alloc] init];
    
    XCTAssertEqualObjects([helper signData:data withOutTime:TRUE][@"signature"], @"En5DkWZhWCmsjGUlYnthH/JWwJmT1MZnnR+C6m76jj4ohS0SGIcC7PShC1ASOPf7ppxMO9lKUdn3dywYuhAkScQCgqn2SOc6aqkJerve62juwaKOAN2xvDT7oNgl09y7JW6KSl9ZN11ZYzDPpEpgOSE4qsd0qqNKH9MTJIJANQpnXfplM4q3S+sGM9D+cUXg0xrF/lx3VVLtpIfUTtamU8nw23XswluMIHHGG5Ub3g2OrvdlYvQBk37WMVnCQN7YzjGT1zUbsLEfg1zvjBuYZBMQqb6+XvtBFLk/qdzeIpbQiXGOrIN080cVOdqAcGj4V+Egzw/jdYwHZGanyP3Zpw==");
    
    NSDictionary* data2 = @{
                            @"amount" : @100,
                            @"appId" :@"cc721b17b6c0411ea2c0dd2a1862b031",
                            @"body" :@"充值炫富",
                            @"id" :@"FD50D86A-2D0D-4A18-BDC1-DB28B0052DFB",
                            @"notify_url" :@"https://www.google.com",
                            @"timestamp" :@1551953690030
                            };
    
    XCTAssertEqualObjects([helper signData:data2 withOutTime:TRUE][@"signature"], @"kjsa4xOgS+8e/3zihLAIz1ZMqX0sUVVbm3vEbunRJGSnso9C1O3y3mSJWunRRJ1LQa5+pLIezoAiXNRWDy+QPItXn2CI0q+TkyV81W9LmmCOhnxY6xApbgnQehLjUamBvZGV0NnmvJuB2+9lbs2n6HzCDc7oKWCu7cPEzX754hBIDNrlbRc7kw4GNaYqpYGWyT+biJSXL5UoYOcj6LrBfQe9X3BdrfoltiGhv6Sr27KrEogyQ9WuU1Gs91F+13LQ1mVg5ih75uqpD0Ug77tq2bt1xFd3d/vfWt3nuwkK08836WwnmADYFKResSYoi/qHvLvsgGwwZ837x3TrmagSxA==");
    
    // 换行测试
    NSDictionary* data3 = @{
                            @"amount" : @100,
                            @"appId" :@"cc721b17b6c0411ea2c0dd2a1862b031",
                            @"body" :@"充值炫富\n真的么？",
                            @"id" :@"FD50D86A-2D0D-4A18-BDC1-DB28B0052DFB",
                            @"notify_url" :@"https://www.google.com",
                            @"timestamp" :@1551953690030
                            };
    
    XCTAssertEqualObjects([helper signData:data3 withOutTime:TRUE][@"signature"], @"ZVXynx46Ylu0Ji3aQT/t+CkLk3+WystFeaE5s0W4LAc0dWEjpWcTDffzecp4bRb4EGWj+dm67ssuoe5dkHzGNawfReAHfXjuUW+d9fyVhOkoSiKWxGmQ2yVOiRE7yEz8apV6V+aK1nJPq0ZQLE5LCDNNHHTRAw5D38r9qDbpjaNzaYY8KF9sWjqF2dze6APOM6S9P508sFWB4Trgyxcss5MgFmSA2MYSqoKmUwX8r+VY9HjXoDBB/aE1ZLGCaWOkpyhGF6jBBElrHSxWx0nrhQs6Z41w4N9TS/XwYyZr8YlwVVtfz3cUcCuU+Z4zEksJ4WYdLCVp3R5myBfkGsipLw==");
    
    // 加入 null
    NSDictionary* data4 = @{
                            @"amount" : @100,
                            @"appId" :@"cc721b17b6c0411ea2c0dd2a1862b031",
                            @"able" : [NSNull null],
                            @"body" :@"充值炫富\n真的么？",
                            @"id" :@"FD50D86A-2D0D-4A18-BDC1-DB28B0052DFB",
                            @"notify_url" :@"https://www.google.com",
                            @"timestamp" :@1551953690030
                            };
    
    XCTAssertEqualObjects([helper signData:data4 withOutTime:TRUE][@"signature"], @"ZvcYkBbtt+4vOAh/Y+qf1w9rNelrW0fg0KjDZAEcVOniwbwgyyPdwsuV8dYWU37Itgxuq60/xGfWj0mbgCv3+/hV3VOGsAp19Va4YrAEPwgdF0GSCNJosp2Jvmpth2SoR7eUIk0UDrsOHkl1Ufyl3o1L9PgkvXyOBj2rxCmEh6dF3EpxNtrXPi0CL6uOC0w5IrpOfR/QjEvfLyTyujYnw7gwSD8OpASx83cJh9VNLE3S0raGQanUYQsHh6UERjXCGnFb392/LzWbQKdpsVpYGhTG7IfnhUhAzRJhSlc57w7ZkXa9QX1CBGpcHpRXjVrad/2jn+hYwlu2z9s7ZbZrPg==");
    

    // 这是来自服务端的经典数据
    NSDictionary* dataFromServer = @{
                                     @"name":@"福特毛",
                                     @"gender":[NSBool boolWithValue:true],
                                     @"size":@1,
                                     @"timestamp":@1551869196499,
                                     @"signature":@"D2n6quYrWQF3vMED/3ImG963P/JuyM6kA0hU7tTTWO0ImRmM6CwWNpmt9OeCdilsE7N0n0pneKeGxW7ZhEQqaOWpzJmnwJ5pX/VWq8NYhTivknPOCINGc07bFsE+pLGIsWWsaAh4+KhZOYnb2UX0Ejl0LK+HohfOA8y1Vb5GiCmLyrkcUaWlPgQbIdcvb/MIM3/ohlqchY3yzc6okuRchx4weoBmZf3E0mlbLac6f5WPncJfRY3gBcom7bIlMaFHEhYsosk8Z/WiqZ5/8yUKEM7WMSkUGzL3H7w8Do27bt8iCjOX7cq22f9iWptvaYyOPQAoZLxgBANvARA399gIHA=="};
    
    XCTAssertTrue([helper verifySign:dataFromServer]);
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
