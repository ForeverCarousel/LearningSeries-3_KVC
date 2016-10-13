
//
//  Adress.m
//  KVC
//
//  Created by Carouesl on 2016/10/13.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import "Adress.h"

@interface Adress ()

@property (nonatomic, strong) NSString* street;
@property (nonatomic, strong) NSString* roomNum;

@end

@implementation Adress

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setStreet:(NSString *)street
{
    if (_street != street)
    {
        _street = street;
    }
}


-(void)setNilValueForKey:(NSString *)key
{
    NSLog(@"%@ 不能为%@设置空值",NSStringFromClass([self class]),key);
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@无法设值，不存在 %@",NSStringFromClass([self class]),key);
}
-(id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"%@无法获取，不存在 %@",NSStringFromClass([self class]),key);
    return @"没有该Key";
}


@end
