//
//  Person.m
//  KVC
//
//  Created by Carouesl on 2016/10/12.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import "Person.h"
#import "Adress.h"

@interface Person()
{
    NSString* secondName;
    NSString* _work;

}
@property (nonatomic, strong) Adress* address;

@end


@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.address = [[Adress alloc] init];
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

//-(void)setValue:(id)value forKey:(NSString *)key
//{
//    [super setValue:value forUndefinedKey:key];
//}
//-(id)valueForKey:(NSString *)key
//{
//     return  [super valueForKey:key];
//}

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
    return @"程序猿怎么可能有女盆友";
}
+(BOOL)accessInstanceVariablesDirectly
{
//    return NO; 返回NO会终止去查询抛出异常 也就是该类禁用KVC 可能是在某些静态库暴露的类为了保证内部变量的安全性下需要这么做吧
    
    return YES;

}











@end
