//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Michael on 5/20/14.
//  Copyright (c) 2014 Gideon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *stack;
@property (weak, nonatomic) IBOutlet UILabel *aValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;
@property (weak, nonatomic) IBOutlet UILabel *cValue;


@property (weak, nonatomic) IBOutlet UIButton *button_mul;
@property (weak, nonatomic) IBOutlet UIButton *button_div;
@property (weak, nonatomic) IBOutlet UIButton *button_add;
@property (weak, nonatomic) IBOutlet UIButton *button_sub;
@property (weak, nonatomic) IBOutlet UIButton *button_enter;
@property (weak, nonatomic) IBOutlet UIButton *button_clear;
@property (weak, nonatomic) IBOutlet UIButton *button_pi;
@property (weak, nonatomic) IBOutlet UIButton *button_sin;
@property (weak, nonatomic) IBOutlet UIButton *button_cos;
@property (weak, nonatomic) IBOutlet UIButton *button_sqrt;
@property (weak, nonatomic) IBOutlet UIButton *button_seven;
@property (weak, nonatomic) IBOutlet UIButton *button_eight;
@property (weak, nonatomic) IBOutlet UIButton *button_nine;
@property (weak, nonatomic) IBOutlet UIButton *button_four;
@property (weak, nonatomic) IBOutlet UIButton *button_five;
@property (weak, nonatomic) IBOutlet UIButton *button_six;
@property (weak, nonatomic) IBOutlet UIButton *button_one;
@property (weak, nonatomic) IBOutlet UIButton *button_two;
@property (weak, nonatomic) IBOutlet UIButton *button_three;
@property (weak, nonatomic) IBOutlet UIButton *button_decimal;
@property (weak, nonatomic) IBOutlet UIButton *button_zero;
@property (weak, nonatomic) IBOutlet UIButton *button_log;
@property (weak, nonatomic) IBOutlet UIButton *button_e;

@property (weak, nonatomic) IBOutlet UIButton *button_a;
@property (weak, nonatomic) IBOutlet UIButton *button_b;
@property (weak, nonatomic) IBOutlet UIButton *button_c;

@property (weak, nonatomic) IBOutlet UIButton *button_test1;
@property (weak, nonatomic) IBOutlet UIButton *button_test2;
@property (weak, nonatomic) IBOutlet UIButton *button_test3;
@end
