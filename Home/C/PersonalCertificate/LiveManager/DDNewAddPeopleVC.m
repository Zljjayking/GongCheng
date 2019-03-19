//
//  DDNewAddPeopleVC.m
//  GongChengDD
//
//  Created by feizhiniumini2 on 2017/12/1.
//  Copyright © 2017年 FeiZhiNiu. All rights reserved.
//

#import "DDNewAddPeopleVC.h"
#import "DDDefines.h"
#import "DDUtils.h"
#import "DDSelectNomalCell.h"//cell
#import "DDInputNomalCell.h"//cell

@interface DDNewAddPeopleVC ()<UITableViewDelegate,UITableViewDataSource,DDSelectNomalCellDelegate,DDInputNomalCellDelegate>

{
    NSString *_name;
    NSString *_idNum;
    NSString *_province;
    
    DDInputNomalCell *_nameCell;//姓名cell
    DDInputNomalCell *_idNumCell;//省份证号cell
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DDNewAddPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
}

//编辑导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"添加人员";
    //self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem=[DDUtils leftButtonItemWithTitle:@"取消" target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem=[DDUtils rightbuttonItemWithTitle:@"保存" target:self action:@selector(rightButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存
- (void)rightButtonClick{
    [DDUtils showToastWithMessage:@"保存"];
}

//创建tableView
-(void)createTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, Screen_Width, Screen_Height-KNavigationBarHeight-45) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    __weak __typeof(self) weakSelf=self;
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        //[weakSelf requestData];
    //    }];
}

#pragma mark tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        _nameCell = (DDInputNomalCell *)[tableView dequeueReusableCellWithIdentifier:@"DDInputNomalCell"];
        if (_nameCell == nil) {
            _nameCell = [[[NSBundle mainBundle] loadNibNamed:@"DDInputNomalCell" owner:self options:nil] firstObject];
        }
        
        [_nameCell loadWithTitle:@"姓名" inputText:@"" placeholder:@"请输入真是姓名" remark:@""];
        
        _nameCell.delegate=self;
        _nameCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return _nameCell;
    }
    else if(indexPath.row==1){
        _idNumCell = (DDInputNomalCell *)[tableView dequeueReusableCellWithIdentifier:@"DDInputNomalCell"];
        if (_idNumCell == nil) {
            _idNumCell = [[[NSBundle mainBundle] loadNibNamed:@"DDInputNomalCell" owner:self options:nil] firstObject];
        }
        
        [_idNumCell loadWithTitle:@"身份证号" inputText:@"" placeholder:@"请输入18位或15位身份证号" remark:@""];
        
        _idNumCell.delegate=self;
        _idNumCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return _idNumCell;
    }
    else{
        DDSelectNomalCell *selectNormalCell=[tableView dequeueReusableCellWithIdentifier:@"DDSelectNomalCell"];
        if (selectNormalCell == nil) {
            selectNormalCell = [[[NSBundle mainBundle] loadNibNamed:@"DDSelectNomalCell" owner:self options:nil] firstObject];
        }
        
        [selectNormalCell loadWithTitle:@"发证省份" content:@"江苏省" placeholder:@""];
        
        selectNormalCell.delegate=self;
        selectNormalCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return selectNormalCell;
    }
}

-(void)inputNomalCell:(DDInputNomalCell *)cell inputText:(NSString *)inputText{
    if (cell==_nameCell) {
        _name=inputText;
    }
    else if(cell==_idNumCell){
        _idNum=inputText;
    }
}

-(void)selectNomalCellClick:(DDSelectNomalCell *)cell{
    
}



@end
