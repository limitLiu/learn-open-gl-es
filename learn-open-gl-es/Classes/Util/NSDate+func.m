//
// Created by Limit Liu on 2018/10/19.
// Copyright (c) 2018 limit. All rights reserved.
//

#import "NSDate+func.h"


@implementation NSDate (func)

+ (NSInteger)seconds {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                           fromDate:[NSDate date]].second;
}
@end
