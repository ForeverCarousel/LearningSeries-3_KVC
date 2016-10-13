//
//  Person.h
//  KVC
//
//  Created by Carouesl on 2016/10/12.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSString* name;

    
}
@property (nonatomic, strong) NSString* sex;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, strong) NSArray* childrens;
@end
