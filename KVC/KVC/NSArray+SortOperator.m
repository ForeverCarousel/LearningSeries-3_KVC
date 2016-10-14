//
//  NSArray+SortOperator.m
//  KVC
//
//  Created by Carouesl on 2016/10/14.
//  Copyright © 2016年 Carouesl. All rights reserved.
//

#import "NSArray+SortOperator.h"

@implementation NSArray (SortOperator)




-(NSSet *)_carouselObjectsForKeyPath:(NSString *)keyPath
{
    
    NSMutableSet* result = [NSMutableSet set];
    for (int i = 0; i < self.count; ++i)
    {
        id var = [self[i] valueForKey:keyPath];
        [result addObject:var];
    }
    
    return result; 

}
@end
