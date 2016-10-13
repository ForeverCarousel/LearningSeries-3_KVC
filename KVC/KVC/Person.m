//
//  Person.m
//  KVC
//
//  Created by Carouesl on 2016/10/12.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import "Person.h"

@interface Person()
{
    NSString* secondName;
    NSString* _work;

}

@end


@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}




-(void)setWork:(NSString *)work
{
    if (_work != work)
    {
        _work = work;
    }
}

-(NSString *)work
{
    return _work;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"无法设值，不存在 %@",key);
}
-(id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"无法获取，不存在 %@",key);
    return @"程序猿怎么可能有女盆友";
}
+(BOOL)accessInstanceVariablesDirectly
{
//    return NO; 返回NO会终止去查询抛出异常 也就是该类禁用KVC 可能是在某些静态库暴露的类为了保证内部变量的安全性下需要这么做吧
    
    return YES;

}











@end
