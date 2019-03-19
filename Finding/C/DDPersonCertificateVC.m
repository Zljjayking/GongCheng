//
//  DDPersonCertificateVC.m
//  GongChengDD
//
//  Created by csq on 2018/11/6.
//  Copyright © 2018 Koncendy. All rights reserved.
//

#import "DDPersonCertificateVC.h"
#import "DDPersonCertificateCell.h"

#import "DDMajorSelectPickerView.h"



@interface DDPersonCertificateVC ()<UITableViewDelegate,UITableViewDataSource,DDMajorSelectPickerViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger tempRow;//存放临时选中的row,只用于有专业的
@property (nonatomic,strong)NSMutableArray *majorArray;
@property (nonatomic,strong)NSArray * titles;
@end

@implementation DDPersonCertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBackGroundColor;
    self.navigationItem.title = @"注册人员类别及等级";
      self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    
    _majorArray = [[NSMutableArray alloc] init];
    
     [self setupTableView];
}
- (void)setupTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor= [UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, KTableViewFooterViewHeight)];
    //    _tableView.separatorColor=KColorTableSeparator;
    [self.view addSubview:_tableView];
    
    //    __weak __typeof(self) weakSelf=self;
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf requestData];
    //    }];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"DDPersonCertificateCell";
    DDPersonCertificateCell * cell = (DDPersonCertificateCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _titles = @[@"全部",@"一级建造师",@"二级建造师",@"一级建筑师",@"二级建筑师",@"一级结构师",@"二级结构师",@"土木工程师",@"公用设备师",@"造价工程师",@"电气工程师",@"化工工程师",@"监理工程师",@"消防工程师"];
    NSString * title = _titles[indexPath.row];

    [cell loadWithTltle:title myRow:indexPath.row pointRow:_pointRow];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DDPersonCertificateCell height];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // _pointRow = indexPath.row;
    //有专业的,才去请求
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 12) {
        _tempRow = indexPath.row;
        [self requestMajor];
    }
    else{

        NSString * cerName = _titles[indexPath.row];
        if (indexPath.row == 0) {
            if (_personCertificatSelectSuccessBlock) {
                _personCertificatSelectSuccessBlock(cerName,nil,@"",indexPath.row);
            }
        }else{
            if (_personCertificatSelectSuccessBlock) {
                _personCertificatSelectSuccessBlock(cerName,nil,[NSString stringWithFormat:@"%ld",(long)indexPath.row],indexPath.row);
            }
        }
        [self leftButtonClick];
        _pointRow = indexPath.row;
        [_tableView reloadData];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, Screen_Width, 15);
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark 请求专业
- (void)requestMajor{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  
    
    if (_tempRow == 7) {
        //土木工程师
        [params setValue:@"320000" forKey:@"certLevl"];
    }
    else if (_tempRow == 8) {
        //公用设备师
        [params setValue:@"330000" forKey:@"certLevl"];
    }
    else if (_tempRow == 10) {
        //电气工程师
        [params setValue:@"340000" forKey:@"certLevl"];
    }
    else if (_tempRow== 12) {
        //监理工程师
        [params setValue:@"350000" forKey:@"certLevl"];
    }
    else if (_tempRow== 9) {
        //造价工程师
        [params setValue:@"360000" forKey:@"certLevl"];
    }
    
   else if (_tempRow == 1) {
        //一级建造师
        [params setValue:@"110000" forKey:@"certLevl"];
    }
    else if(_tempRow == 2) {
        //二级建造师
        [params setValue:@"120000" forKey:@"certLevl"];
    }
    
    MBProgressHUD * hud = [DDUtils showHUDCustom:@""];
    [[DDHttpManager sharedInstance]sendGetRequest:KHttpRequest_builderMajorList params:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"***********专业筛选请求数据***************%@",responseObject);
        
        DDHttpResponse * response = [DDHttpResponse initWithResponseDic:responseObject];
        if (response.isSuccess) {
            [hud hide:YES];
             [_majorArray removeAllObjects];
            
            NSArray *listArr= responseObject[KData];
            for (NSDictionary *dic in listArr) {
                DDMajorSelectModel *model=[[DDMajorSelectModel alloc]initWithDictionary:dic error:nil];
                [_majorArray addObject:model];
            }
            //手动增加"全部"模块
            DDMajorSelectModel * allItem = [[DDMajorSelectModel alloc] init];
            allItem.name = @"全部专业";
            allItem.cert_type_id = @"";
            [_majorArray insertObject:allItem atIndex:0];
            
            [self showMajorSelectView];
        }else{
            hud.labelText = response.message;
            [hud hide:YES afterDelay:KHudShowTimeSecound];
        }
        
//        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, id responseObject) {
        hud.labelText = kRequestFailed;
        [hud hide:YES afterDelay:KHudShowTimeSecound];
    }];
}
//显示专业选择view
- (void)showMajorSelectView{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (DDMajorSelectModel * model in _majorArray) {
        [tempArray addObject:model.name];
    }
    
    DDMajorSelectPickerView * majorSelectPickerView = [[DDMajorSelectPickerView alloc] init];
    [majorSelectPickerView loadWithTitle:@"请选择专业" dataArray:tempArray];
    majorSelectPickerView.delegate = self;
    [majorSelectPickerView show];
}
#pragma mark DDMajorSelectPickerViewDelegate打代理方法
//选中了某一行
- (void)majorSelectPickerViewClickFinsh:(DDMajorSelectPickerView*)majorSelectPickerView row:(NSInteger)row{
    DDMajorSelectModel * majorModel = _majorArray[row];
    NSLog(@"选择的专业 %@",majorModel.name);
    
    NSString * cerName = _titles[_tempRow];
    
    if (_personCertificatSelectSuccessBlock) {
          _personCertificatSelectSuccessBlock(cerName,majorModel,[NSString stringWithFormat:@"%ld",(long)_tempRow],_tempRow);
    }
    
    [self leftButtonClick];
}

#pragma mark 返回上一级
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
