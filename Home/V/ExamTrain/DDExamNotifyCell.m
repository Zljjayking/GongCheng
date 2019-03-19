//
//  DDExamNotifyCell.m
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/2/21.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import "DDExamNotifyCell.h"
#import "DDExamNotifyCollectionCell.h"
@interface DDExamNotifyCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;
@end
@implementation DDExamNotifyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWhite;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.lineL];
        [self.contentView addSubview:self.collectionView];
        kWeakSelf
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(WidthByiPhone6(12));
            make.top.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(WidthByiPhone6(50)-LineHeight);
        }];
        [self.lineL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleL.mas_bottom);
            make.left.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(LineHeight);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.lineL.mas_bottom);
            make.left.bottom.right.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}

-(void)setIndexArr:(NSMutableArray *)indexArr{
    _indexArr = indexArr;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _indexArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDExamNotifyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDExamNotifyCollectionCell" forIndexPath: indexPath];
    NSDictionary *dict = [_indexArr objectAtIndex:indexPath.row];;
    cell.iconImgV.image = DDIMAGE(dict[@"image"]);
    cell.nameLabel.text = dict[@"name"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Screen_Width/3, WidthByiPhone6(100));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf
    if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(hasClickedWithIndex:)]) {
        [weakSelf.delegate hasClickedWithIndex:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat w = Screen_Width/3;
        CGFloat h = WidthByiPhone6(100);
        flowLayout.itemSize = CGSizeMake(w, h);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[DDExamNotifyCollectionCell class] forCellWithReuseIdentifier:@"DDExamNotifyCollectionCell"];
        _collectionView.backgroundColor = kColorWhite;
    }
    return _collectionView;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel labelWithFont:KfontSize34Bold textColor:KColorBlackTitle textAlignment:NSTextAlignmentLeft numberOfLines:1];
    }
    return _titleL;
}

-(UILabel *)lineL{
    if(!_lineL){
        _lineL = [[UILabel alloc]init];
        _lineL.backgroundColor = KColor10AlphaBlack;
    }
    return _lineL;
}

@end
