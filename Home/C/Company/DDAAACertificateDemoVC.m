//
//  DDAAACertificateDemoVC.m
//  GongChengDD
//
//  Created by csq on 2019/2/26.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDAAACertificateDemoVC.h"
#import "ShowFullImageView.h"
#import "DDNewCreditCell.h"
#import <UIView+MJExtension.h>
@interface DDAAACertificateDemoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headImageV;
@property (nonatomic, assign) CGFloat currentScale;
@end

@implementation DDAAACertificateDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"信用等级证书";
    if (self.type == 2) {
        self.title=@"";
    }
    //监听UIWindow显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
    self.dataArr = @[@{@"name":@"1、AAA信用等级证书正、副本",@"image":@[@"aaaz",@"aaaf"]},@{@"name":@"2、AAA信用证书铜牌",@"image":@"aaat"},@{@"name":@"3、信用报告",@"image":@"xinyognbaogao"}];
    if (self.type == 2) {
//        self.dataArr = @[@{@"name":@"",@"image":@"beianzhengshu"}];
        [self setupheadImageView];
    }else {
        [self.view addSubview:self.tableView];
    }
}

- (void)setupheadImageView {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-KNavigationHeight*2)];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 1.5;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.76)];
    headImage.image = [UIImage imageNamed:@"beianzhengshu"];
    headImage.backgroundColor = kColorWhite;
    headImage.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y);
    
    self.headImageV = headImage;
    [self.scrollView addSubview:headImage];
    headImage.clipsToBounds = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(double)scale{
    _currentScale = scale;
    NSLog(@"current scale:%f",scale);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.headImageV;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

- (void)beginFullScreen {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)endFullScreen {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)callAction{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", DDServicePhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
#pragma mark -- UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.type == 2) {
            return 1;
        }
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        return Screen_Width*0.76;
    }else {
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                return Screen_Width*0.74+15;
            }
            return Screen_Width*1.35+35;
        }else if (indexPath.section == 1) {
            return Screen_Width*0.67+35;
        }else{
            return Screen_Width*1.42+35;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return WidthByiPhone6(20);
    }
    return WidthByiPhone6(14);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 2) {
//        return WidthByiPhone6(110);
//    }
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        DDNewCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewCreditCell" forIndexPath:indexPath];
        NSDictionary *dict = [_dataArr objectAtIndex:indexPath.section];
        cell.nameL.text = dict[@"name"];
        cell.nameL.font = [UIFont boldSystemFontOfSize:CustomFontSize(17)];
        cell.imgV.image = DDIMAGE(dict[@"image"]);
        [cell.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.left.right.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView).offset(-10);
        }];
        return cell;
    }else {
        if (indexPath.section == 0) {
            DDNewCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewCreditCell" forIndexPath:indexPath];
            NSDictionary *dict = [_dataArr objectAtIndex:indexPath.section];
            cell.nameL.text = dict[@"name"];
            cell.nameL.font = [UIFont boldSystemFontOfSize:CustomFontSize(17)];
            if (indexPath.row == 1) {
                cell.nameL.hidden = YES;
            }else {
                cell.nameL.hidden = NO;
            }
            
            NSString *imageStr = dict[@"image"][indexPath.row];
            
            cell.imgV.image = DDIMAGE(imageStr);
            if (indexPath.row == 1) {
                [cell.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView.mas_top).offset(5);
                    make.left.right.equalTo(cell.contentView);
                    make.bottom.equalTo(cell.contentView).offset(-10);
                }];
            }else {
                [cell.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.nameL.mas_bottom);
                    make.left.right.bottom.equalTo(cell.contentView);
                }];
            }
            
            return cell;
        }
        DDNewCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDNewCreditCell" forIndexPath:indexPath];
        NSDictionary *dict = [_dataArr objectAtIndex:indexPath.section];
        cell.nameL.text = dict[@"name"];
        cell.nameL.font = [UIFont boldSystemFontOfSize:CustomFontSize(17)];
        cell.imgV.image = DDIMAGE(dict[@"image"]);
        if (indexPath.section == 2) {
            [cell.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.nameL.mas_bottom).offset(12);
                make.right.bottom.equalTo(cell.contentView).offset(-14);
                make.left.equalTo(cell.contentView).offset(14);
            }];
        }else {
            [cell.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.nameL.mas_bottom);
                make.left.right.bottom.equalTo(cell.contentView);
            }];
        }
//        [cell.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cell.nameL.mas_bottom);
//            make.left.right.bottom.equalTo(cell.contentView);
//        }];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        NSDictionary *dict = [_dataArr objectAtIndex:indexPath.section];
        NSMutableArray *mutArray = [NSMutableArray array];
        UIImage *image = DDIMAGE(dict[@"image"]);
        [mutArray addObject:image];
        ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithLocalImageArray:mutArray];
        [showFullImage show];
    }else {
        if (indexPath.section == 0) {
            NSDictionary *dict = [_dataArr objectAtIndex:indexPath.section];
            NSMutableArray *mutArray = [NSMutableArray array];
            UIImage *image = DDIMAGE(dict[@"image"][indexPath.row]);
            [mutArray addObject:image];
            ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithLocalImageArray:mutArray];
            [showFullImage show];
        }else {
            NSDictionary *dict = [_dataArr objectAtIndex:indexPath.section];
            NSMutableArray *mutArray = [NSMutableArray array];
            UIImage *image = DDIMAGE(dict[@"image"]);
            [mutArray addObject:image];
            ShowFullImageView *showFullImage=[[ShowFullImageView alloc]initWithLocalImageArray:mutArray];
            [showFullImage show];
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if(section == 2){
//        UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, WidthByiPhone6(110))];
//        footV.backgroundColor = kColorWhite;
//        UILabel *tipLabel = [UILabel labelWithFont:kFontSize30 textString:@"申领事宜请联系客服" textColor:[UIColor hexStringToColor:@"888888"] textAlignment:NSTextAlignmentCenter numberOfLines:1];
//        tipLabel.frame = CGRectMake(0, WidthByiPhone6(10),Screen_Width , WidthByiPhone6(35));
//        [footV addSubview:tipLabel];
//
//        UIView *grayV = [[UIView alloc]initWithFrame:CGRectMake(0, WidthByiPhone6(45), Screen_Width, WidthByiPhone6(65))];
//        grayV.backgroundColor = kColorBackGroundColor;
//
//        UIButton *contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, Screen_Width-200, WidthByiPhone6(65))];
//        [contactBtn setTitle:@"联系客服" forState:UIControlStateNormal];
//        [contactBtn setTitleColor:[UIColor hexStringToColor:@"3196FC"] forState:UIControlStateNormal];
//        [contactBtn setImage:[UIImage imageNamed:@"myinfo_kefu"] forState:UIControlStateNormal];
//        [contactBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
//        contactBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
//        [contactBtn.titleLabel setFont:kFontSize28];
//        [grayV addSubview:contactBtn];
//        [footV addSubview:grayV];
//        return footV;
//    }
    return nil;
}

-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView *)tableView{
    if(!_tableView){
//        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) tstyle:UITableViewStyleGrouped tdelegate:self tdatasource:self backgroundColor:kColorBackGroundColor sepratorStyle:UITableViewCellSeparatorStyleNone];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-KNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorBackGroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DDNewCreditCell class] forCellReuseIdentifier:@"DDNewCreditCell"];
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
