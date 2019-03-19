//
//  DDProvinceSelectVC.m
//  GongChengDD
//
//  Created by Koncendy on 2017/12/1.
//  Copyright © 2017年 Koncendy. All rights reserved.
//

#import "DDProvinceSelectVC.h"
#import "MyCollectionViewCell.h"
#import "MyCollectionReusableView.h"
#import "DDMyCollectionReusableHeadView.h"

@interface DDProvinceSelectVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    NSDictionary *_dic;
}
@property (nonatomic, strong) NSArray *regionArray;//大区的数组
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation DDProvinceSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self editNavItem];
    [self createCollectionView];
    [self getProvinceData];
}

//编辑导航条
-(void)editNavItem{
    self.view.backgroundColor=kColorBackGroundColor;
    self.title=@"发证省份";
    self.navigationItem.leftBarButtonItem=[DDUtils leftCustomViewWithImage:@"Nav_back_blue" title:@"返回" target:self action:@selector(leftButtonClick)];
}

//返回上一页面
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取Json数据
-(void)getProvinceData{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *pickerdic = provinceLise;//接取到整个json字典
    
    self.regionArray = [[NSArray alloc]init];
    self.regionArray = pickerdic[@"region"];//获取到第一级数组，大区数组
    
    [_collectionView reloadData];
}

//创建collectionView
-(void)createCollectionView{
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    // 1.设置列间距
    //    layout.minimumInteritemSpacing = 1;
    //    // 2.设置行间距
    //    layout.minimumLineSpacing = 1;
    //    // 3.设置每个item的大小
    //    layout.itemSize = CGSizeMake(50, 50);
    //    // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
    //    layout.estimatedItemSize = CGSizeMake(320, 60);
    //    // 5.设置布局方向
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    // 6.设置头视图尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(50, 50);
    //    // 7.设置尾视图尺寸大小
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    //    // 8.设置分区(组)的EdgeInset（四边距）
    //    layout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);
    //    // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    //    layout.sectionFootersPinToVisibleBounds = YES;
    //    layout.sectionHeadersPinToVisibleBounds = YES;
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,Screen_Height-KNavigationBarHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self.view addSubview:_collectionView];

    //注册集合视图cell
    [_collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    //注册补充视图组头
    [_collectionView registerNib:[UINib nibWithNibName:@"MyCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyCollectionReusableView"];
    [_collectionView registerNib:[UINib nibWithNibName:@"DDMyCollectionReusableHeadView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DDMyCollectionReusableHeadView"];
}

#pragma mark collectionView代理方法
//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _regionArray.count;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_regionArray[section][@"children"] count];
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.label.text=_regionArray[indexPath.section][@"children"][indexPath.row][@"name"];
    if ([_regionArray[indexPath.section][@"children"][indexPath.row][@"name"] isEqualToString:_name]) {
        cell.label.backgroundColor=KColorCompanyTransfetBlue;
        cell.label.textColor=kColorBlue;
    }
    else{
        cell.label.backgroundColor=KColorCompanyTransfetGray;
        cell.label.textColor=KColorBlackTitle;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.provinceSelectBlock(_regionArray[indexPath.section][@"children"][indexPath.row][@"regionId"],_regionArray[indexPath.section][@"children"][indexPath.row][@"name"]);
    [self.navigationController popViewControllerAnimated:YES];
}

//对头视图或者尾视图进行设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    /*
     EnterpriseUsersModel * enterpriseUsersModel =  [DDUserManager sharedInstance].selectCompanyModel;
    if(kind==UICollectionElementKindSectionHeader) {
        if (indexPath.section==0) {
            DDMyCollectionReusableHeadView *head=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DDMyCollectionReusableHeadView" forIndexPath:indexPath];
            
            
            
            
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSError *error;
            NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSDictionary *pickerdic = provinceLise;//接取到整个json字典
            
            NSArray *regionArray = [[NSArray alloc]init];
            regionArray = pickerdic[@"region"];//获取到第一级数组，大区数组
            
            NSString *provinceId=[NSString stringWithFormat:@"%@0000", [enterpriseUsersModel.provinceId substringToIndex:2]];
            for (NSDictionary *dic1 in regionArray) {
                for (NSDictionary *dic2 in dic1[@"children"]) {
                    if ([[NSString stringWithFormat:@"%@",dic2[@"regionId"]] isEqualToString:provinceId]) {
                        _dic=dic2;
                        break;
                    }
                }
            }
            
            
            
            
            
            [head.currentCityBtn setTitle:_dic[@"name"] forState:UIControlStateNormal];
            head.cityLabel.text=_regionArray[indexPath.section][@"name"];
            [head.currentCityBtn addTarget:self action:@selector(selectCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
            
            return head;
        }
        else{
            MyCollectionReusableView *head=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionReusableView" forIndexPath:indexPath];
            
            head.label.text=_regionArray[indexPath.section][@"name"];
            return head;
        }
    }
    return nil;
     */
    
    MyCollectionReusableView *head=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionReusableView" forIndexPath:indexPath];
    
    head.label.text=_regionArray[indexPath.section][@"name"];
    return head;
    
    //return nil;
}

//检索点位出来的省份
-(void)selectCurrentLocation{
    self.provinceSelectBlock(_dic[@"regionId"],_dic[@"name"]);
    [self.navigationController popViewControllerAnimated:YES];
    
}

////是否允许移动Item
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){
//    return YES;
//}
//
////移动Item时触发的方法
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0); {
//
//
//
//}

#pragma mark flowLayout协议方法
//定制cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((Screen_Width-50)/4, 35);
}

//定制最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//定制最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//制定补充视图组头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        //return CGSizeMake(Screen_Width, 96);
        return CGSizeMake(Screen_Width, 30);
    }
    else{
        return CGSizeMake(Screen_Width, 30);
    }
}

//调上左下右偏置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



@end
