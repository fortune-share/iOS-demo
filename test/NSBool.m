//
//  NSBool.m
//  ostentation
//
//  Created by JiangCai on 2019/3/8.
//  Copyright © 2019 fortune. All rights reserved.
//

#import "NSBool.h"

@implementation NSBool

+(NSBool*)boolWithValue:(BOOL)value{
    NSBool* b = [[self alloc] init];
    b.value = value;
    return b;
}

-(NSString*)description{
    if (self.value) {
        return @"true";
    }else
        return @"false";
}

@end
