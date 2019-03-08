//
//  NSBool.h
//  ostentation
//
//  Created by JiangCai on 2019/3/8.
//  Copyright © 2019 fortune. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBool : NSObject

+(NSBool*)boolWithValue:(BOOL)value;

@property (assign) BOOL value;

-(NSString*)description;

@end

NS_ASSUME_NONNULL_END
