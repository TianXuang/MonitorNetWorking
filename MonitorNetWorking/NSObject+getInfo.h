//
//  NSObject+getInfo.h
//  黑魔法
//
//  Created by 天轩 on 2017/8/30.
//  Copyright © 2017年 天轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (getInfo)
/* 获取对象的所有属性 */
+(NSArray *)getAllProperties;
/* 获取对象的所有方法 */
+(NSArray *)getAllMethods;
/* 获取对象的所有属性和属性内容 */
+ (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj;
@end
