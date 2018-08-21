//
//  NewUserGift.h
//  WeTrade
//
//  Created by tangyin on 2017/11/10.
//  Copyright © 2017年 zhushi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserGift : UIView

+ (void)showNewUserWithIdentifier:(NSString * __nullable)identifier completion:(void (^ __nullable)(BOOL finished))completion;

@end
