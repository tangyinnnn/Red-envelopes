//
//  NewUserGift.m
//  WeTrade
//
//  Created by tangyin on 2017/11/10.
//  Copyright © 2017年 zhushi. All rights reserved.
//

#import "NewUserGift.h"
#import "MBProgressHUD.h"
#import <Masonry.h>

//#import "UIView+Ext.h"

#define kAppEnterForeground  @"app_did_enter_forground"

#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define Screen_Adaptor_Scale    Main_Screen_Width/375.0f

#define Adaptor_Value(v)        (v)*Screen_Adaptor_Scale

#define HexRGB(rgbValue)        HexRGBA(rgbValue, 1.0)

#define HexRGBA(rgbValue, a)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:(a)]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


typedef void(^CompletionViewBlock)(BOOL);

@interface NewUserGift ()

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) UIView *transparentBGView;

@property (nonatomic, strong) UIImageView *redPacketsBGView;

@property (nonatomic, strong) UIButton *openButton;

@property (nonatomic, copy) CompletionViewBlock completion;

@property (nonatomic, strong) UILabel *redPacketNum;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UILabel *tipsMsgLabel;

@property (nonatomic, strong) UIImageView *rotateImageView;

@property (nonatomic) BOOL isShowView;

@end

@implementation NewUserGift

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame =  [[UIScreen mainScreen] bounds];

        [self addPageSubviews];
        [self layoutPageSubviews];
        //登录过后，从后台回来，执行动画；
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppDidEnterForeground) name:kAppEnterForeground object:nil];

    }
    return self;
}
- (void)addPageSubviews {
    [self addSubview:self.backGroundView];
    [self addSubview:self.transparentBGView];
    [self.transparentBGView addSubview:self.rotateImageView];
    [self.transparentBGView addSubview:self.redPacketsBGView];
    [self.transparentBGView addSubview:self.openButton];
    [self.transparentBGView addSubview:self.redPacketNum];
    [self.transparentBGView addSubview:self.submitButton];
    [self.transparentBGView addSubview:self.tipsMsgLabel];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 7.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.rotateImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)layoutPageSubviews {
   
    [self.redPacketsBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Adaptor_Value(375)));
        make.height.equalTo(@(Adaptor_Value(470)));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-Adaptor_Value(25));
    }];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redPacketsBGView.mas_bottom).with.offset(-Adaptor_Value(104));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(Adaptor_Value(100)));
        make.width.equalTo(@(Adaptor_Value(100)));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redPacketsBGView.mas_bottom).with.offset(-Adaptor_Value(32));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(Adaptor_Value(44)));
        make.width.equalTo(@(Adaptor_Value(200)));
    }];
    [self.tipsMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.submitButton.mas_top).with.offset(-Adaptor_Value(30));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.redPacketNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.submitButton.mas_top).with.offset(-Adaptor_Value(70));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.rotateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Adaptor_Value(375)));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(Adaptor_Value(400)));
        make.top.equalTo(self.redPacketsBGView.mas_top).with.offset(-Adaptor_Value(15));
    }];
}

+ (void)showNewUserWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL finished))completion {
    //判断是否有网络，identifier为唯一标示，判断用户是否已经抽取过红包，
//    if (!NETWORK_IS_REACHABLE || [[NSUserDefaults standardUserDefaults] boolForKey:identifier]) {
//        return;
//    }
    NewUserGift *newUserGift = [[NewUserGift alloc]init];
    newUserGift.isShowView = YES;
    newUserGift.completion = completion;
    newUserGift.identifier = identifier;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    newUserGift.frame = window.bounds;
    [window.rootViewController.view addSubview:newUserGift];
    
    newUserGift.transparentBGView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    [UIView animateWithDuration:0.15 animations:^{
        // 以动画的形式将view慢慢放大至原始大小
        newUserGift.transparentBGView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

//获取数据成功后更新当前UI
- (void)updateCurrentUI {
    self.openButton.hidden = YES;
    self.tipsMsgLabel.hidden = NO;
    self.redPacketsBGView.image = [UIImage imageNamed:@"RedGift_openRedRacket"];
    self.redPacketNum.hidden = NO;
    self.submitButton.hidden = NO;
}

/*  网络请求回调成功
#pragma mark -GAPIBaseManagerRequestCallBackDelegate

- (void)managerApiCallBackDidSuccess:(GApiBaseManager *)manager{
    if (manager == self.getNewRedApi) {
        [self performSelector:@selector(openRedPacket) withObject:nil afterDelay:0.5];
        
        NSDictionary *result = [manager fetchDataWithTransformer:nil];
        self.tipsMsgLabel.text = SAFE_STRING(result[@"Tip"]);
        
        NSString *money = [NSString stringWithFormat:@"%@",result[@"Money"]];
        
        NSMutableAttributedString *attr = [Global_Helper attributeText:money textColor:HexRGB(0xD64304) font:[UIFont systemAdaptorFontOfSize:71]].mutableCopy;
        [attr appendAttributedString:[Global_Helper attributeText:@"元" textColor:HexRGB(0xD64304) font:[UIFont systemAdaptorFontOfSize:36]]];
        self.redPacketNum.attributedText = attr;
        // 保存是否获取过红包！！！！
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.identifier];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",[money floatValue]] forKey:kRedPacketMoney];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",[money floatValue]] forKey:KDisplayRedPacketMoney];
    }else {
        
    }
}
 网络请求回调失败
- (void)managerApiCallBackDidFailed:(GApiBaseManager *)manager{
    
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.mode = MBProgressHUDModeText;
    _hud.label.numberOfLines = 0;
    _hud.label.text = manager.errorMessage;
    [_hud hideAnimated:YES afterDelay:2.0f];
    
    id result = [manager fetchDataWithTransformer:nil];
    if ([result isKindOfClass:[NSData class]] && result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        if ([dict[@"StatusCode"] integerValue] == 406) {
            // do somthing
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.identifier];
        }
    }
 
    [self performSelector:@selector(noNetopenRedPacket) withObject:nil afterDelay:2.0f];
}
 */
#pragma mark - response event

- (void)openRedPacket {
    [self.openButton.layer removeAllAnimations];
    //通知更新红包余额
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUserBalance object:nil];
    self.tipsMsgLabel.text = @"提示文本";

    NSMutableAttributedString *attr = [self attributeText:@"100" textColor:HexRGB(0xD64304) font:[UIFont systemFontOfSize:71]].mutableCopy;
    [attr appendAttributedString:[self attributeText:@"元" textColor:HexRGB(0xD64304) font:[UIFont systemFontOfSize:36]]];
    self.redPacketNum.attributedText = attr;
    [self updateCurrentUI];
}

//获取数据失败后未能打开红包
- (void)noNetopenRedPacket{
    [self.openButton setBackgroundImage:[UIImage imageNamed:@"RedGift_openBtn"] forState:UIControlStateNormal];
    [self.openButton.layer removeAllAnimations];
    NewUserGift *newUserGift = self;
    [UIView animateWithDuration:0.35 animations:^{
        // 以动画的形式将view慢慢放大至原始大小
        newUserGift.transparentBGView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        newUserGift.alpha = 0;
    } completion:^(BOOL finished) {
        [newUserGift removeFromSuperview];
    }];
}

//打开红包按钮
- (void)openButtonAction:(UIButton *)action {
    //判断是否登录
//    if (![self signIn]) {
//        return;
//    }
    //请求红包

    //翻转动画
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnima.toValue = [NSNumber numberWithFloat:M_PI];
    transformAnima.duration = 0.4;
    transformAnima.cumulative = NO;
    //    动画结束时是否执行逆动画
    transformAnima.autoreverses = YES;
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    action.layer.zPosition = 5;
    action.layer.zPosition = action.layer.frame.size.width / 2.f;
    transformAnima.repeatCount = MAXFLOAT;
    [action.layer addAnimation:transformAnima forKey:@"rotationAnimationY"];
    [action setBackgroundImage:[UIImage imageNamed:@"RedGift_golden"] forState:UIControlStateNormal];
    //这里应该是请求红包金额，在请求成功中执行 openRedPacket， 这里用延时代理网络请求
    [self performSelector:@selector(openRedPacket) withObject:nil afterDelay:2.0];


}
//APP后台返回来，继续执行动画，不然动画会停止
- (void)AppDidEnterForeground {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 7.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.rotateImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
//立即使用按钮点击方法
- (void)submitButtonAction:(UIButton *)action {
    NewUserGift *newUserGift = self;
    [UIView animateWithDuration:0.35 animations:^{
        // 以动画的形式将view慢慢放大至原始大小
        newUserGift.transparentBGView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        newUserGift.alpha = 0;
    } completion:^(BOOL finished) {
        if (newUserGift.completion) {
            newUserGift.completion(YES);
        }
        [newUserGift removeFromSuperview];
    }];
}

#pragma mark - getter

- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = HexRGB(0x000000);
        _backGroundView.alpha = 0.5;
    }
    return _backGroundView;
}

- (UIView *)transparentBGView {
    if (!_transparentBGView) {
        _transparentBGView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _transparentBGView.backgroundColor = [UIColor clearColor];
    }
    return _transparentBGView;
}

- (UIImageView *)redPacketsBGView {
    if (!_redPacketsBGView) {
        _redPacketsBGView = [UIImageView new];
        _redPacketsBGView.image = [UIImage imageNamed:@"RedGift_redPacket"];
    }
    return _redPacketsBGView;
}

- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton new];
        [_openButton setBackgroundImage:[UIImage imageNamed:@"RedGift_openBtn"] forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

- (UILabel *)redPacketNum {
    if (!_redPacketNum) {
        _redPacketNum = [UILabel new];
        _redPacketNum.hidden = YES;
    }
    return _redPacketNum;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton new];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"RedGit_submitBtn"] forState:UIControlStateNormal];
        _submitButton.hidden = YES;
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_submitButton, Adaptor_Value(22));
    }
    return _submitButton;
}

- (UILabel *)tipsMsgLabel {
    if (!_tipsMsgLabel) {
        _tipsMsgLabel = [UILabel new];
        _tipsMsgLabel.font = [UIFont systemFontOfSize:14];
        _tipsMsgLabel.textColor = HexRGB(0xFFFFFF);
        _tipsMsgLabel.hidden = YES;
    }
    return _tipsMsgLabel;
}

- (UIImageView *)rotateImageView {
    if (!_rotateImageView) {
        _rotateImageView = [[UIImageView alloc]init];
        _rotateImageView.image = [UIImage imageNamed:@"RedGift_rotateImage"];
    }
    return _rotateImageView;
}

//富文本处理

- (NSAttributedString *)attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font {
    return [self attributeText:text textColor:color font:font lineSpacing:0];
}

- (NSAttributedString *)attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing {
    return [self attributeText:text textColor:color font:font lineSpacing:lineSpacing alignment:NSTextAlignmentCenter];
}

- (NSAttributedString *)attributeText:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment {
    if (!text) {
        return nil;
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    
    if (lineSpacing != 0) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
        pStyle.lineSpacing = lineSpacing;
        pStyle.alignment = alignment;
        [attString addAttributes:@{NSParagraphStyleAttributeName:pStyle} range:NSMakeRange(0, text.length)];
    }
    return attString;
}

@end
