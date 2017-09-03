//
//  UIViewController+EmptyDataSource.h
//
//  Created by 天轩 on 2017/8/30.
//  Copyright © 2017年 天轩. All rights reserved.
//
#import <UIKit/UIKit.h>
//引用该文件 导入 SystemConfiguration.framework库
#import "Reachability.h"
@class NSObject;
typedef enum : NSUInteger {
    EmptyDataTypeDefaultType,//默认类型
    EmptyDataTypeCustomType,//自定义视图类型
    EmptyDataTypeImageType,//图片类型
} EmptyDataType;
//网络状态
typedef enum : NSUInteger {
    NetWorkingStatusSuccess,//成功
    NetWoringStatusSuccess_WiFi,//wifi
    NetWoringStatusSuccess_WWAN,//3g/4g
    NetWorkingStatusError//网络不可用
} NetWorkingStatus;

@interface UIViewController (EmptyDataSource)
+(void)gb_MonitorViewForEmptyDataSource;
//设置自定义视图(非网络相关)
@property(nonatomic,strong,readonly)UIView *gb_customView;
//获取类型(非网络相关)
@property(nonatomic,assign,readonly)EmptyDataType gb_getType;
//设置无网络情况下自定义视图
@property(nonatomic,strong,readonly)UIView *gb_NetWoringView;
//无网络情况下Block
@property(nonatomic,copy,readonly)UIView *(^CopyNetWorkingBlock)(NetWorkingStatus);
//设置网络监听对象
@property(nonatomic,strong,readonly)Reachability *internetReachability;
//设置是否展示具体网络类型
@property(nonatomic,assign,readonly)BOOL isDistinguish;
//获取网络监听对象(用于释放通知)
@property(nonatomic,strong)id observer;
/**
 检测数据为空 展示页面
 设置自定义视图(非网络相关)
 @parm2 建议用自定义类型
 */
-(void)gb_showEmptyView:(UIView *(^)())EmptyView withGb_type:(EmptyDataType)gb_Type;
/**
 监听网络状态（直接调用此方法即可监听网络变化）
 @parm1 网络status下的视图
 @parm2 是否需要返回固定的网络类型
 */
-(void)gb_showNetWorking:(UIView *(^)(NetWorkingStatus))NetWorkingView ToDistinguishTheNetworkType:(BOOL)isDistinguish;
@end

