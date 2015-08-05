//
//  RecommendLocationCell.m
//  Tutu
//
//  Created by gexing on 5/21/15.
//  Copyright (c) 2015 zxy. All rights reserved.
//

#import "RecommendLocationCell.h"

#import "UIImage+ImageWithColor.h"
@implementation RecommendLocationCell


- (void)awakeFromNib {
    // Initialization code
    _nameLabel.textColor = HEXCOLOR(TextBlackColor);
    _descLabel.textColor = HEXCOLOR(TextGrayColor);
    _avatarView.userInteractionEnabled = YES;
    _nameLabel.userInteractionEnabled = YES;
    
    _statusBtn.layer.masksToBounds = YES;
    _statusBtn.layer.cornerRadius = _statusBtn.mj_height / 2.f;
    _statusBtn.layer.borderWidth = 0.7f;
    _statusBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_nameLabel addGestureRecognizer:nameTap];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_avatarView addGestureRecognizer:avatarTap];
    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(locationClick:index:)]) {
        [_delegate locationClick:_locationModel index:_cellIndex];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)loadCellWithModel:(RecommendLocationModel *)model{
    _locationModel = model;
    if (_locationModel.isfollow == 1) {
        [_statusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _statusBtn.layer.borderColor = HEXCOLOR(TextCCCCCCColor).CGColor;
        _statusBtn.userInteractionEnabled = NO;
        [_statusBtn setTitle:TTLocalString(@"TT_haved_follow") forState:UIControlStateNormal];
        [_statusBtn setTitleColor:HEXCOLOR(TextCCCCCCColor) forState:UIControlStateNormal];
    }else{
        _statusBtn.layer.borderColor = HEXCOLOR(SystemColor).CGColor;
        [_statusBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(SystemColor)] forState:UIControlStateNormal];
        [_statusBtn setTitle:TTLocalString(@"TT_follow") forState:UIControlStateNormal];
        [_statusBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        _statusBtn.userInteractionEnabled = YES;
    }
    [_avatarView sd_setImageWithURL:StrToUrl(_locationModel.content) placeholderImage:[UIImage imageNamed:@""]];
    
    _nameLabel.text = _locationModel.idstext;
    
    _descLabel.text = FormatString(@"%d%@", _locationModel.joinusercount,TTLocalString(@"TT_join_discussion"));
 
    CGSize nameSize = [_locationModel.idstext sizeWithFont:_nameLabel.font];
    if (nameSize.width > ScreenWidth - 170) {
        nameSize.width = ScreenWidth - 170;
    }
    _nameLabel.frame = CGRectMake(_nameLabel.mj_x, _nameLabel.mj_y, nameSize.width, _nameLabel.mj_height);
}

//添加关注
- (IBAction)statusButtonClick:(id)sender {
    [[RequestTools getInstance]get:API_ADD_POI_FOCUS(_locationModel.ids) isCache:NO completion:^(NSDictionary *dict) {
        if ([dict[@"code"]intValue] == 10000) {
            [SVProgressHUD showSuccessWithStatus:TTLocalString(@"TT_follow_success")];
            [_statusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            _statusBtn.layer.borderColor = HEXCOLOR(TextCCCCCCColor).CGColor;
            _statusBtn.userInteractionEnabled = NO;
            [_statusBtn setTitle:TTLocalString(@"TT_haved_follow") forState:UIControlStateNormal];
            [_statusBtn setTitleColor:HEXCOLOR(TextCCCCCCColor) forState:UIControlStateNormal];
            _locationModel.isfollow = 1;
        }
    } failure:^(ASIHTTPRequest *request, NSString *message) {
        
    } finished:^(ASIHTTPRequest *request) {
        
    }];
}
@end