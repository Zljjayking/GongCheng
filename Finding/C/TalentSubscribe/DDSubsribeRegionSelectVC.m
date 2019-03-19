//
//  DDSubsribeRegionSelectVC.m
//  GongChengDD
//
//  Created by xzx on 2018/11/26.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import "DDSubsribeRegionSelectVC.h"
#import "MyTableViewCell.h"//cell

@interface DDSubsribeRegionSelectVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_ProvinceTableView;//省
    UITableView *_CityTableView;//市
    
    NSString *_recordProvince;//记录一下直辖县级是哪一个省份
}
@property (nonatomic, strong) UIButton *backView;//底层蒙版
@property (nonatomic, strong) NSDictionary *pickerDic;//接收总的Json数据源


@property (nonatomic, strong) NSMutableArray *provinceList;//省的数组
@property (strong,nonatomic) NSMutableArray *cityList;//市的数组


@property (assign, nonatomic)NSInteger selectOneRow;//记录第一级选中的下标
@property (assign, nonatomic)NSInteger selectTwoRow;//记录第二级选中的下标

@end

@implementation DDSubsribeRegionSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"选择区域";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    [self createTableView];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建tableView
-(void)createTableView{
    _ProvinceTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/3,Screen_Height-KNavigationBarHeight) style:UITableViewStylePlain];
    _ProvinceTableView.backgroundColor=kColorBackGroundColor;
    _ProvinceTableView.delegate=self;
    _ProvinceTableView.dataSource=self;
    _ProvinceTableView.separatorColor=KColorTableSeparator;
    _ProvinceTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _ProvinceTableView.showsVerticalScrollIndicator=NO;
    _ProvinceTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_ProvinceTableView];
    [_ProvinceTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    _CityTableView=[[UITableView alloc]initWithFrame:CGRectMake(Screen_Width/3, 0, Screen_Width/3*2,Screen_Height-KNavigationBarHeight) style:UITableViewStylePlain];
    _CityTableView.backgroundColor=KColorLinkBackViewColor;
    _CityTableView.delegate=self;
    _CityTableView.dataSource=self;
    _CityTableView.separatorColor=KColorTableSeparator;
    _CityTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _CityTableView.showsVerticalScrollIndicator=NO;
    _CityTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_CityTableView];
    //注册集合视图cell
    [_CityTableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    
    
    [self Dataparsing];//解析json数据，获得省的数据
    [self getCitydate:0];//获得默认市的数据
    [_ProvinceTableView reloadData];
    [_CityTableView reloadData];
    //默认选中第一个数据
    [_ProvinceTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    if (self.cityList.count>0) {
        [_CityTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
}


#pragma mark 解析json数据,获取省的数据
- (void)Dataparsing{
    self.provinceList = [[NSMutableArray alloc]init];
    
    NSDictionary *dic=@{@"mergerName": @"全国",
                        @"name": @"全国",
                        @"parentId": @"",
                        @"pinyin": @"",
                        @"regionId": @"0",
                        @"children": @[]};
    [self.provinceList addObject:dic];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.pickerDic = provinceLise;
    //self.provinceList = self.pickerDic[@"region"];
    for (NSDictionary *dic in self.pickerDic[@"region"]) {
        [self.provinceList addObject:dic];
    }
}

#pragma mark 取到市的数据，默认第0行
- (void)getCitydate:(NSInteger)row{
    self.cityList=[[NSMutableArray alloc]init];
    
    if (self.provinceList.count>0) {
        if ([self.provinceList[row][@"children"] count]>0) {
            _recordProvince=self.provinceList[row][@"name"];
            
            NSString *nameStr=self.provinceList[row][@"name"];
            NSString *newNameStr;
            if ([[nameStr substringFromIndex:nameStr.length-1] isEqualToString:@"省"]) {
                newNameStr=[NSString stringWithFormat:@"%@全省",self.provinceList[row][@"name"]];
            }
            else if([[nameStr substringFromIndex:nameStr.length-1] isEqualToString:@"市"]){
                newNameStr=[NSString stringWithFormat:@"%@全市",self.provinceList[row][@"name"]];
            }
            else if([[nameStr substringFromIndex:nameStr.length-1] isEqualToString:@"区"]){
                newNameStr=[NSString stringWithFormat:@"%@全区",self.provinceList[row][@"name"]];
            }
            
            NSString *regionIdStr=self.provinceList[row][@"regionId"];
            
            NSDictionary *dic=@{@"mergerName": [NSString stringWithFormat:@"%@",newNameStr],
                                @"name": [NSString stringWithFormat:@"%@",newNameStr],
                                @"parentId": @"",
                                @"pinyin": @"",
                                @"regionId": regionIdStr,
                                @"children": @[]};
            [self.cityList addObject:dic];
            
            
            for (NSDictionary *dict in self.provinceList[row][@"children"]) {
                [self.cityList addObject:dict];
            }
        }
    }
    
}

#pragma mark tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_ProvinceTableView) {//省
        return self.provinceList.count;
    }
    else{//市
        return self.cityList.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_ProvinceTableView) {//省
        MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=KColorLinkBackViewColor;
        cell.areaLab.highlightedTextColor =kColorBlue;
        cell.areaLab.text = self.provinceList[indexPath.row][@"name"];
        
        return cell;
    }
    else if(tableView==_CityTableView){//市
        MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=kColorWhite;
        cell.areaLab.highlightedTextColor =kColorBlue;
        cell.areaLab.text = self.cityList[indexPath.row][@"name"];
        
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSInteger oneRow = 0;
    static NSInteger tweRow = 0;

    //省的那一栏
    if (tableView == _ProvinceTableView) {
        self.selectOneRow = indexPath.row;


        [self getCitydate:indexPath.row];
        if (self.cityList.count>0) {
            //[self getCitydate:indexPath.row];
            [_CityTableView reloadData];//重新加载 第二列
            [_CityTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];//默认选中第二列中的第一个数据


            oneRow = indexPath.row;
            tweRow = 0;
        }
        else{
            //将选中的地区信息回调出去
            self.regionSelectBlock([NSString stringWithFormat:@"%@",self.provinceList[0][@"name"]], [NSString stringWithFormat:@"%@",self.provinceList[0][@"regionId"]]);
            [self.navigationController popViewControllerAnimated:YES];
            //[_CityTableView reloadData];
        }


    }

    //市的那一栏
    if (tableView == _CityTableView){
        self.selectTwoRow = indexPath.row;


        tweRow = indexPath.row;


        //对最终要回调出去的地区信息进行赋值
        if (tweRow != 0){//此时县区这一列是有选择滚动过
            //将选中的地区信息回调出去
             NSString *nameStr = [NSString stringWithFormat:@"%@",self.cityList[self.selectTwoRow][@"name"]];
            if ([nameStr isEqualToString:@"北京市"]||[nameStr isEqualToString:@"上海市"]||[nameStr isEqualToString:@"天津市"]) {
                nameStr = [nameStr substringToIndex:nameStr.length-1];
            }
            self.regionSelectBlock(nameStr, [NSString stringWithFormat:@"%@",self.cityList[self.selectTwoRow][@"regionId"]]);
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{//此时县区这一列没动过，那么就默认首个，下标0
            //将选中的地区信息回调出去
            NSString *nameStr = self.cityList[0][@"name"];
            NSString *regionId =  [NSString stringWithFormat:@"%@",self.cityList[0][@"regionId"]];
            if ([nameStr containsString:@"全市"]) {
                if(![nameStr isEqualToString:@"重庆市全市"]){
                     regionId  = [NSString stringWithFormat:@"%@100",[regionId substringToIndex:3]];
                }
                nameStr = [nameStr substringToIndex:nameStr.length-3];
            }
            
            self.regionSelectBlock(nameStr, [NSString stringWithFormat:@"%@",regionId]);
            [self.navigationController popViewControllerAnimated:YES];
        }


    }
}



@end
