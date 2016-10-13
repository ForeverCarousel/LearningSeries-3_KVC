//
//  ViewController.m
//  KVC
//
//  Created by Carouesl on 2016/10/12.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController


/**
 
                                        KVC简介
        KVC（Key-value coding）键值编码，就是指iOS的开发中，可以允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值。而不需要调用明确的存取方法。这样就可以在运行时动态在访问和修改对象的属性。而不是在编译时确定，这也是iOS开发中的黑魔法之一。很多高级的iOS开发技巧都是基于KVC实现的。
        只要是基于NSObject的类都可以重写如下方法，因为NSKeyValueCoding是NSObject的一个类别
 
 
                                NSKeyValueCoding类别中的常用方法
 
         + (BOOL)accessInstanceVariablesDirectly;
         默认返回YES，表示如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员，设置成NO就不这样搜索
 
         - (BOOL)validateValue:(inout id __nullable * __nonnull)ioValue forKey:(NSString *)inKey error:(out NSError **)outError;
         KVC提供属性值确认的API，它可以用来检查set的值是否正确、为不正确的值做一个替换值或者拒绝设置新值并返回错误原因。
         
         - (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;
         这是集合操作的API，里面还有一系列这样的API，如果属性是一个NSMutableArray，那么可以用这个方法来返回
         
         - (nullable id)valueForUndefinedKey:(NSString *)key;
         如果Key不存在，且没有KVC无法搜索到任何和Key有关的字段或者属性，则会调用这个方法，默认是抛出异常
         
         - (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
         和上一个方法一样，只不过是设值。
 
         - (void)setNilValueForKey:(NSString *)key;
         如果你在SetValue方法时面给Value传nil，则会调用这个方法
         
         - (NSDictionary<NSString *, id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys;
         输入一组key,返回该组key对应的Value，再转成字典返回，用于将Model转到字典。
         
 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    Person* person = [[Person alloc] init];
    /**
     person的name实例变量没有实现set和get方法 但是依然可以通过基类实现的KVC进行赋值
     */
    [person setValue:@"Carousel" forKey:@"name"];
    NSString* name = [person valueForKey:@"name"];
    NSLog(@"person‘s name is:%@",name);
    
    
    /**
     person的secondeName实例变量属于私有属性同样没有实现set和get方法 但是依然可以通过基类实现的KVC进行赋值
     */
    [person setValue:@"Forever" forKey:@"secondName"];
    NSString* secondName = [person valueForKey:@"secondName"];
    NSLog(@"person‘s second name is:%@",secondName);
    
    
    /**
     person的实例变量名字为 _work KVC 会先去首先查找work 没有找到回去找_work 可以去该类打断点 一下方法会首先去调用重写的set方法和get方法
     */
    [person setValue:@"Developer" forKey:@"work"];
    NSString* work = [person valueForKey:@"work"];
    NSLog(@"person‘s work  is:%@",work);

    
    /**
     person的不存在名字为undefineKey的变量 所以会直接去调用person类重载的以下方法
     -(void)setValue:(id)value forUndefinedKey:(NSString *)key
     {
        NSLog(@"无法设值，不存在 %@",key);
     }
     -(id)valueForUndefinedKey:(NSString *)key
     {
        NSLog(@"无法获取，不存在 %@",key);
        return @"不存在 返回默认值";
     }
     */
    [person setValue:@"Lily" forKey:@"girlFriend"];
    NSString* undefineKey = [person valueForKey:@"girlFriend"];
    NSLog(@"person‘s girlFriend  is:%@",undefineKey);
    
    
    /**
     如果Person 类实现了+(BOOL)accessInstanceVariablesDirectly 并且返回NO 则以上的方法都会因为没有实现set方法 KVC无法找到时 并且本方法返回了NO 会直接调用setValueForUndefineKey抛出异常
     */
    
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
