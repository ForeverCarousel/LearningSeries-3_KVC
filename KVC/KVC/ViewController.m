//
//  ViewController.m
//  KVC
//
//  Created by Carouesl on 2016/10/12.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Adress.h"
#import <objc/runtime.h>
#import "NSArray+SortOperator.h"

@interface ViewController ()

@end

@implementation ViewController


/**
 
                                        KVC简介
        KVC（Key-value coding）键值编码，就是指iOS的开发中，可以允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值。而不需要调用明确的存取方法。这样就可以在运行时动态在访问和修改对象的属性。而不是在编译时确定，这也是iOS开发中的黑魔法之一。很多高级的iOS开发技巧都是基于KVC实现的。
        只要是基于NSObject的类都可以重写如下方法，因为NSKeyValueCoding是NSObject的一个类别 又称作非正式协议 其实就是一个category  另外在.m中实现的“@ interface”称之为扩展 又称之为匿名类别 与category的区别主要是 ：
        1、扩展中的方法和属性都属于私有 求作用域仅限类本身 其方法是在编译时就会被添加到类中的 所以如果只有方法声明而没有实现的话 编译器会发出警告
        2、category的方法是在运行时被添加到类中的  其子类也会继承category的方法  可以有选择性的去重写
 
 
                                NSKeyValueCoding非正式协议中的常用方法
        * 非正式协议是相对于正式协议的 可以理解为就是category  即非正式协议中的方法都是默认继承的但是子类是否需要去实现就不一定的 是灵活的 所以称之为非正式协议
 
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
     如果Person 类重载了
     -(void)setValue:(id)value forKey:(NSString *)key
   
     -(id)valueForKey:(NSString *)key
    这两个方法那么所有的set 和 get方法都不会再调用 会首先去调用这两个方法

     */
    
    
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
     
     如果不实现以上方法 则会导致崩溃 抛出异常如下
     [<Person 0x7c08db60> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key girlFriend.'

     */
    [person setValue:@"Lily" forKey:@"girlFriend"];
    NSString* undefineKey = [person valueForKey:@"girlFriend"];
    NSLog(@"person‘s girlFriend  is:%@",undefineKey);
    
    /**
     如果Person 类实现了+(BOOL)accessInstanceVariablesDirectly 并且返回NO 则以上的方法中实例变量会因为没有实现set方法 KVC无法找到时 并且本方法返回了NO 会直接调用setValueForUndefineKey抛出异常
     */
    
    
    
    
    
    
    
    [person setValue:@"BeijingHaidianStreet" forKeyPath:@"address.street"];
    [person setValue:@"BeijingHaidianStreet" forKeyPath:@"address.something"];//undefineKey
   
    /**
     不能对 非对象 类型的key设置空值 要重载方法防止crash
     
    我觉得这种情况可以用在服务器返回的数据生成model时 可以为model设置一个处理这种防空值的父类实现三个方法  为model赋值时用kvc有效的防止某些非对象类型的值为空时导致的崩溃问题  具体有待实际验证

     */
    [person setValue:nil forKey:@"age"];


    NSString* personAdress = [person valueForKeyPath:@"address.street"];
    NSLog(@"person‘s address street  is:%@",personAdress);
    

    
    
    
                            /**
                                            KVC 中的 Collection  Operators
                             
                             Collection Operators有3种，分别是：
                             1. Simple Collection Operators
                             2. Object Operators
                             3. Array and Set Operators。
                             操作对象均为数组或集合
                             
                             */
    
    
    /*  
     Simple Collection Operators
     @avg:求均值
     @count:求总数
     @max:求最大值
     @min:求最小值
     @sum:求和
     
     */
    
    Adress* ad1 = [[Adress alloc] init];
    ad1.streetNum = 100;
    
    Adress* ad2 = [[Adress alloc] init];
    ad2.streetNum = 110;
    
    Adress* ad3 = [[Adress alloc] init];
    ad3.streetNum = 120;

    NSArray* ads = @[ad1,ad2,ad3];
    
    NSNumber* avg = [ads valueForKeyPath:@"@avg.streetNum"];
    NSNumber* count = [ads valueForKeyPath:@"@count.streetNum"];
    NSNumber* max = [ads valueForKeyPath:@"@max.streetNum"];
    NSNumber* min = [ads valueForKeyPath:@"@min.streetNum"];
    NSNumber* sum = [ads valueForKeyPath:@"@sum.streetNum"];
    NSLog(@"ads's  avg:%@  count:%@  max:%@ min:%@ sum:%@",avg,count,max,min,sum);

    
    
    /**
     Object Operators
     @unionOfObjects:返回操作对象内部的所有对象，返回值为数组
     @distinctUnionOfObjects:返回操作对象内部的不同对象，返回值为数组
     
     */
    Adress* ad4 = [[Adress alloc] init];
    ad4.provience = @"beijing";
    
    Adress* ad5 = [[Adress alloc] init];
    ad5.provience = @"shanghai";
    
    Adress* ad6 = [[Adress alloc] init];
    ad6.provience = @"guangzhou";
    
    Adress* ad7 = [[Adress alloc] init];
    ad7.provience = @"guangzhou";
    
    NSArray* ads2 = @[ad4,ad5,ad6,ad7];
    
    NSArray* allProvs = [ads2 valueForKeyPath:@"@unionOfObjects.provience"];
    NSArray* diffProvs = [ads2 valueForKeyPath:@"@distinctUnionOfObjects.provience"];

    NSLog(@"all provs :%@  \n  diffProvs:%@",allProvs,diffProvs);
    
    
    
    
    /**
     Array and Set Operators
     @unionOfArrays:返回操作对象（且操作对象内的对象必须是数组/集合）中数组/集合的所有对象，返回值为数组
     @distinctUnionOfArrays:返回操作对象（且操作对象内对象必须是数组/集合）中数组/集合的不同对象，返回值为数组
     @distinctUnionOfSets:返回操作对象（且操作对象内对象必须是数组/集合）中数组/集合的所有对象，返回值为集合
     */
    //不写代码例子了  跟上面的类似 不过所操作的对象不再是简单对象 是以数组或者set为操作单体
    
    [self  justTryIt];
    
}


-(void)justTryIt
{
    
    Adress* ad1 = [[Adress alloc] init];
    ad1.provience = @"beijing";
    
    Adress* ad2 = [[Adress alloc] init];
    ad2.provience = @"shanghai";
    
    Adress* ad3 = [[Adress alloc] init];
    ad3.provience = @"guangzhou";
    
    Adress* ad4 = [[Adress alloc] init];
    ad4.provience = @"beijing";
    
    Adress* ad5 = [[Adress alloc] init];
    ad5.provience = @"guangzhou";
    
    Adress* ad6 = [[Adress alloc] init];
    ad6.provience = @"guangzhou";
  
    NSArray* ads = @[ad1,ad2,ad3,ad4,ad5,ad6];

    
    
    //尝试自己去实现自定义个collection operator PS：貌似Apple文档明确提示不支持自定义
    
    
    /**
     尝试实现一个对数据进行排序的operator 首先这里先看下系统是如何实现NSArray的其他operator的
     */
    NSUInteger count = 0;
    Method* methods =  class_copyMethodList([NSArray class], &count);
    for (int i = 0; i < count; ++i)
    {
        Method m = methods[i];
        SEL sel = method_getName(m);
//        NSLog(@"NSArray的方法：%@",NSStringFromSelector(sel));
        /**
         可以看到系统实现的方法名字如下 所以实现一个NSArray类别 要仿照系统方法的命名规则 方法以_开头具体见类别
         .
         .
         .
         2016-10-14 18:24:18.170 KVC[10721:890961] NSArray的方法：_sumForKeyPath:
         2016-10-14 18:24:18.170 KVC[10721:890961] NSArray的方法：_unionOfArraysForKeyPath:
         2016-10-14 18:24:18.170 KVC[10721:890961] NSArray的方法：_unionOfObjectsForKeyPath:
         2016-10-14 18:24:18.171 KVC[10721:890961] NSArray的方法：_avgForKeyPath:
         2016-10-14 18:24:18.171 KVC[10721:890961] NSArray的方法：_countForKeyPath:
         2016-10-14 18:24:18.172 KVC[10721:890961] NSArray的方法：_maxForKeyPath:
         2016-10-14 18:24:18.172 KVC[10721:890961] NSArray的方法：_minForKeyPath:
         .
         .
         .

         */
        if ([NSStringFromSelector(sel) hasPrefix:@"_avg"])
        {
            NSLog(@"@avg operator 实现的方法名字为 ：%@",NSStringFromSelector(sel));
            break;
            //2016-10-14 18:26:44.787 KVC[10760:893220] @avg operator 实现的方法名字为 ：_avgForKeyPath:
            
        }
        
    }
    
    //自定义实现 根据传入的数组中的对象的某个属性 返回所有的数组的中该属性的值 去重
   NSSet* set = [ads valueForKeyPath:@"@carouselObjects.provience"];
    
    
    NSLog(@"所有人的地址集合为：%@",set);
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
