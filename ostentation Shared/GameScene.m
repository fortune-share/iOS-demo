//
//  GameScene.m
//  ostentation Shared
//
//  Created by JiangCai on 2019/3/5.
//  Copyright © 2019 fortune. All rights reserved.
//

#import "GameScene.h"
#import "SecurityHelper.h"

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

+ (GameScene *)newGameScene {
    // Load 'GameScene.sks' as an SKScene.
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    if (!scene) {
        NSLog(@"Failed to load GameScene.sks");
        abort();
    }
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    return scene;
}

- (void)setUpScene {
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    // Create shape node to use during mouse interaction
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    
    _spinnyNode.lineWidth = 4.0;
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
        [SKAction waitForDuration:0.5],
        [SKAction fadeOutWithDuration:0.5],
        [SKAction removeFromParent],
    ]]];

#if TARGET_OS_WATCH
    // For watch we just periodically create one of these and let it spin
    // For other platforms we let user touch/mouse events create these
    _spinnyNode.position = CGPointMake(0.0, 0.0);
    _spinnyNode.strokeColor = [SKColor redColor];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[
        [SKAction waitForDuration:2.0],
        [SKAction runBlock:^{
            [self addChild:[_spinnyNode copy]];
        }]
    ]]]];
#endif
}

#if TARGET_OS_WATCH
- (void)sceneDidLoad {
    [self setUpScene];
}
#else
- (void)didMoveToView:(SKView *)view {
    [self setUpScene];
}
#endif

- (void)makeSpinnyAtPoint:(CGPoint)pos color:(SKColor *)color {
    SKShapeNode *spinny = [_spinnyNode copy];
    spinny.position = pos;
    spinny.strokeColor = color;
    [self addChild:spinny];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

- (void) makeOrder {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 创建订单，实际上这部分功能应该由商户服务端负责，此处只是为了demo的演示便利； 要索取其他服务端的加签验签算法可向商务索取。
        // cc721b17b6c0411ea2c0dd2a1862b031
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://server.im.fortune.mingshz.com/preparePayOrder"]];
        // 设置方法
        [request setHTTPMethod:@"POST"];
        // 设置头
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // 设置消息
        SecurityHelper* sh =[[SecurityHelper alloc] init];
        
        // 商户订单号
        NSString* pid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSDictionary* data = [sh signData:@{
                                            @"appId":@"cc721b17b6c0411ea2c0dd2a1862b031",
                                            @"amount":@100,
                                            @"body":@"充值炫富",
                                            @"id":pid,
                                            @"notify_url":@"https://www.google.com"// 通知地址。
                                            } withOutTime:NO];
        
        // {"amount":100,"appId":"cc721b17b6c0411ea2c0dd2a1862b031","body":"充值炫富","id":"869D9900-2E00-4642-A644-1EF5CF67B6B4","notify_url":"https://www.google.com","timestamp":1.551952652773745E12}
        
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:data options:0 error:nil]];
        
        NSURLSession* session = NSURLSession.sharedSession;
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
            
            // po [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"tooltip"]
            // po [NSString stringWithCString:(const char*)[data bytes] encoding:NSUTF8StringEncoding]
            if(error){
                NSLog(@"local error: %@",error);
            }else{
                NSHTTPURLResponse* r = (NSHTTPURLResponse*)response;
                if(r.statusCode==200){
                    NSDictionary* dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if([sh verifySign:dict]){
                        NSString* transactionId = dict[@"transactionId"];
                        // 调用SDK 发起支付。 SDK方法应该注意当前并不是在UI线程中！
                        NSLog(@"发起支付: %@", transactionId);
                    }else
                        NSLog(@"服务端不可信任");
                }else{
                    NSLog(@"text response content : %@",[NSString stringWithCString:(const char*)[data bytes] encoding:NSUTF8StringEncoding]);
                }
            }
        }];
        [task resume];
    });
}

#if TARGET_OS_IOS || TARGET_OS_TV
// Touch-based event handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor greenColor]];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor blueColor]];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor redColor]];
    }
    [self makeOrder];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor redColor]];
    }
}
#endif

#if TARGET_OS_OSX
// Mouse-based event handling

- (void)mouseDown:(NSEvent *)event {
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    [self makeSpinnyAtPoint:[event locationInNode:self] color:[SKColor greenColor]];
    [self makeOrder];
}

- (void)mouseDragged:(NSEvent *)event {
    [self makeSpinnyAtPoint:[event locationInNode:self] color:[SKColor blueColor]];
}

- (void)mouseUp:(NSEvent *)event {
    [self makeSpinnyAtPoint:[event locationInNode:self] color:[SKColor redColor]];
}

#endif

@end
