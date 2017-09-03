//
//  UIViewController+EmptyDataSource.m
//
//  Created by 天轩 on 2017/8/30.
//  Copyright © 2017年 天轩. All rights reserved.
//

#import "UIViewController+EmptyDataSource.h"
#import <objc/message.h>
@implementation UIViewController (EmptyDataSource)
+(void)gb_MonitorViewForEmptyDataSource
{
    Method m2 = class_getInstanceMethod([self class], @selector(EmptyTableView:numberOfRowsInSection:));
    Method m1=class_getInstanceMethod([self class], @selector(tableView:numberOfRowsInSection:));
    method_exchangeImplementations(m1, m2);
    
    Method m3 = class_getInstanceMethod([self class], @selector(numberOfSectionsInTableView:));
    Method m4 = class_getInstanceMethod([self class], @selector(numberOfSectionsIngb_EmptyTableView:));
    method_exchangeImplementations(m3, m4);
}
-(NSInteger)numberOfSectionsIngb_EmptyTableView:(UITableView *)gb_emptyTableView
{
    return [self numberOfSectionsIngb_EmptyTableView:gb_emptyTableView];
}
-(NSInteger)EmptyTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    NSInteger sec =[self numberOfSectionsIngb_EmptyTableView:tableView];
    NSMutableArray *NumberofRowArr=[NSMutableArray new];
    for (NSInteger i=0; i<sec; i++)
    {
        row = [self EmptyTableView:tableView numberOfRowsInSection:i];
        if (row==0)
        {
            [NumberofRowArr addObject:@"0"];
        }
        //当最后一次循环时，获取数组 判断是否只有有row不等于0 的情况
        if (i==sec-1)
        {
            if (sec==NumberofRowArr.count)
            {
                if (self.gb_getType==EmptyDataTypeCustomType)
                {
                    NSAssert(self.gb_customView, @"请传入自定义视图");
                    if (![tableView .subviews containsObject:self.gb_customView])
                    {
                        self.gb_customView.frame=CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height);
                        tableView.scrollEnabled=NO;
                        [tableView addSubview:self.gb_customView];
                    }
                }
            }else
            {
                //不管视图有没有添加 ，先移除
                if (self.gb_getType==EmptyDataTypeCustomType)
                {
                    tableView.scrollEnabled=YES;
                    [self.gb_customView removeFromSuperview];
                }
            }
        }
        if (section==i)
        {
            return row;
        }
    }
    return row;
}
//自定义视图block
-(void)gb_showEmptyView:(UIView *(^)())EmptyView withGb_type:(EmptyDataType)gb_Type
{
    [self setGb_customView:EmptyView()];
    [self setGb_getType:gb_Type];
}
#pragma mark-网络监听部分
//设置网络监听回调
-(void)gb_showNetWorking:(UIView *(^)(NetWorkingStatus))NetWorkingView ToDistinguishTheNetworkType:(BOOL)isDistinguish;
{
    self.isDistinguish=isDistinguish;
    self.CopyNetWorkingBlock=[NetWorkingView copy];
    __weak typeof(self)ws = self;
   self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        Reachability *notReach=note.object;
        NetworkStatus netStatus = [notReach currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:        {
                [ws AddCopyNetWorkingBlockView:ws.CopyNetWorkingBlock(NetWorkingStatusError)];
                break;
            }
            case ReachableViaWWAN:        {
                if (ws.isDistinguish==YES)
                {
                    ws.CopyNetWorkingBlock(NetWoringStatusSuccess_WWAN);
                }else
                {
                    ws.CopyNetWorkingBlock(NetWorkingStatusSuccess);
                }
                [ws removeCopyNetWorkinBlockView];
                break;
            }
            case ReachableViaWiFi:        {
                if (ws.isDistinguish==YES)
                {
                    ws.CopyNetWorkingBlock(NetWoringStatusSuccess_WiFi);
                }else
                {
                    ws.CopyNetWorkingBlock(NetWorkingStatusSuccess);
                }
                [ws removeCopyNetWorkinBlockView];
                break;
            }
        }
    }];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
}
//无网络时 添加需要添加的视图
-(void)AddCopyNetWorkingBlockView:(UIView *)cus_view
{
    self.gb_NetWoringView=cus_view;
    if (cus_view.frame.size.height==0)
    {
      self.gb_NetWoringView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    [self.view addSubview:self.gb_NetWoringView];
}
//有网络时移除视图
-(void)removeCopyNetWorkinBlockView
{
    if (self.gb_NetWoringView)
    {
        self.gb_NetWoringView.backgroundColor=[UIColor orangeColor];
        [self.gb_NetWoringView removeFromSuperview];
        self.gb_NetWoringView=nil;
    }
}
//设置关联对象
//设置获取观察者对象
-(void)setObserver:(id)observer
{
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)observer
{
    return objc_getAssociatedObject(self, @"observer");
}
//设置类型是否显示
-(void)setIsDistinguish:(BOOL)isDistinguish
{
    NSString *str;
    if (isDistinguish==YES)
    {
        str=@"1";
    }else
    {
        str=@"0";
    }
    objc_setAssociatedObject(self, @"isDistinguish",str,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isDistinguish
{
    if ([objc_getAssociatedObject(self, @"isDistinguish") isEqualToString:@"1"]) {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)setInternetReachability:(Reachability *)internetReachability
{
    objc_setAssociatedObject(self, @"internetReachability", internetReachability,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(Reachability *)internetReachability
{
    return objc_getAssociatedObject(self, @"internetReachability");
}
//设置无网络情况下的视图
-(void)setGb_NetWoringView:(UIView *)gb_NetWoringView
{
    objc_setAssociatedObject(self, @"gb_NetWoringView", gb_NetWoringView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)gb_NetWoringView
{
    return objc_getAssociatedObject(self, @"gb_NetWoringView");
}
-(void)setCopyNetWorkingBlock:(UIView *(^)(NetWorkingStatus))CopyNetWorkingBlock
{
    objc_setAssociatedObject(self, @"CopyNetWorkingBlock", CopyNetWorkingBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(UIView *(^)(NetWorkingStatus))CopyNetWorkingBlock
{
    return objc_getAssociatedObject(self, @"CopyNetWorkingBlock");
}
//设置自定义视图
-(void)setGb_customView:(UIView *)gb_customView
{
    objc_setAssociatedObject(self, @"gb_customView", gb_customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)gb_customView
{
    return objc_getAssociatedObject(self, @"gb_customView");
}
//设置类型
-(void)setGb_getType:(EmptyDataType)gb_getType
{
    NSString *type;
    switch (gb_getType) {
        case EmptyDataTypeDefaultType:
            type=@"0";
            break;
        case EmptyDataTypeCustomType:
            type=@"1";
            break;
        case EmptyDataTypeImageType:
            type=@"2";
            break;
        default:
            break;
    }
    objc_setAssociatedObject(self, @"gb_getType", type, OBJC_ASSOCIATION_ASSIGN);
}
-(EmptyDataType)gb_getType
{
    EmptyDataType gb_type;
    id gb_string=objc_getAssociatedObject(self, @"gb_getType");
    if ([gb_string isEqualToString:@"0"])
    {
        gb_type=EmptyDataTypeDefaultType;
    }else if([gb_string isEqualToString:@"1"])
    {
        gb_type=EmptyDataTypeCustomType;
    }else
    {
        gb_type=EmptyDataTypeImageType;
    }
    return gb_type;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}
@end
