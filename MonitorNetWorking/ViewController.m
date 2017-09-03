//
//  ViewController.m
//  MonitorNetWorking
//
//  Created by 天轩 on 2017/9/3.
//  Copyright © 2017年 天轩. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+EmptyDataSource.h"
@interface ViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSInteger num1;
    NSInteger num2;
    NSInteger num3;
}
@end

@implementation ViewController

-(void)butClick:(UIButton *)but
{
    if (but.selected==YES)
    {
        num1=10;
        num2=20;
        num3=30;
        
        but.selected=NO;
    }else
    {
        num1=0;
        num2=0;
        num3=0;
        but.selected=YES;
    }
    [table reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self ReachabilityNetWorking];
    num1=10;
    num2=20;
    num3 = 30;
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(0, 64, 280, 30);
    but.backgroundColor=[UIColor redColor];
    [but setTitle:@"刷新数据,数据为空" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    //
    [ViewController gb_MonitorViewForEmptyDataSource];
    
    [self gb_showEmptyView:^UIView *{
        //网络数据为空时加载的视图
        UIImageView *imageV=[[UIImageView alloc]init];
        imageV.image=[UIImage imageNamed:@"插销"];
        
        return imageV;
    } withGb_type:EmptyDataTypeCustomType];
    
    //监听网络
    [self gb_showNetWorking:^UIView *(NetWorkingStatus status) {
        
        if (status==NetWorkingStatusSuccess) {
            //重新请求 数据，或者加载想要加载的数据
            
            return nil;
        }else
        {
            //网络失败时加载的视图
            UIView *vv=[[UIView alloc]init];
            vv.backgroundColor=[UIColor redColor];
            return vv;
        }
    } ToDistinguishTheNetworkType:NO];
    
    [self creatTable];
}
-(void)creatTable
{
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, 375, 567) style:UITableViewStyleGrouped];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return num1;
    }else if (section==1)
    {
        return num2;
    }
    else if (section==2)
    {
        return num3;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"cdr";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"=== %ld",indexPath.row];
    return cell;
}
-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
