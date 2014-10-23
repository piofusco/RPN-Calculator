//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael on 5/20/14.
//  Copyright (c) 2014 Gideon LTD. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorModel.h"


@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL numberHasBeenGivenADecimal;
@property (nonatomic) BOOL firstTimeUser;
@property (nonatomic,  strong) CalculatorModel *model;
@end

@implementation CalculatorViewController

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)viewDidLoad {
    self.firstTimeUser = YES;
}

- (id)init {
    if (self = [super init]) {
        self.firstTimeUser = YES;
    }
    return self;
}

- (CalculatorModel *)model {
    if (!_model) _model = [[CalculatorModel alloc] init];
    return _model;
}

- (IBAction)operandPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    NSLog(@"Digit pressed: %@", digit);
    if ([digit isEqual:@"."] && !self.numberHasBeenGivenADecimal) {
        self.numberHasBeenGivenADecimal = YES;
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.stack.text = [self.stack.text stringByAppendingString:digit];
    }
    else if ([digit isEqual:@"."] && self.numberHasBeenGivenADecimal) return;
    else if ([digit isEqualToString:@"a"] || [digit isEqualToString:@"b"] || [digit isEqualToString:@"c"]) {
        if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
        self.display.text = digit;
    }
    else {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.display.text = [self.display.text stringByAppendingString:digit];
            self.stack.text = [self.stack.text stringByAppendingString:digit];
        }
        else if (self.firstTimeUser) { // First number has been entered
            self.display.text = digit;
            self.stack.text = [self.stack.text stringByAppendingString:digit];
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        else { // Starting a new number when numbers/cluster have already been entered
            self.display.text = digit;
            self.stack.text = [self.stack.text stringByAppendingString:[@" " stringByAppendingString:digit]];
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *resultString = @"";
    double result = 0;
    if ([[sender currentTitle] isEqualToString:@"π"] || [[sender currentTitle] isEqualToString:@"e"]) {
        if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
        result = [self.model performOperation:sender.currentTitle];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        resultString = [formatter stringFromNumber:[NSNumber numberWithDouble:result]];
        self.display.text = resultString;
    }
    else {
        if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
        result = [self.model performOperation:sender.currentTitle];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        resultString = [formatter stringFromNumber:[NSNumber numberWithDouble:result]];
    }
    self.display.text = resultString;
    self.stack.text = [self.model createDescription];
}

- (IBAction)enterPressed {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if ([self.display.text isEqualToString:@"a"]) {
        [self.model pushVariable:self.display.text withValue:[formatter numberFromString:self.aValue.text]];
    }
    else if ([self.display.text isEqualToString:@"b"]) {
        [self.model pushVariable:self.display.text withValue:[formatter numberFromString:self.bValue.text]];
    }
    else if ([self.display.text isEqualToString:@"c"]) {
        [self.model pushVariable:self.display.text withValue:[formatter numberFromString:self.cValue.text]];
    }
    else {
        [self.model pushOperand:[self.display.text doubleValue]];
    }
    self.numberHasBeenGivenADecimal = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.firstTimeUser = NO;
//    self.stack.text = [self.model createDescription]; // Consider removing this
}

- (IBAction)clearPressed {
    self.stack.text = @"";
    self.display.text = @"0";
    [self.model clear];
    self.numberHasBeenGivenADecimal = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.firstTimeUser = YES;
}

/*
 * Rewrite this.
 */
- (IBAction)testPressed:(UIButton *)sender {
    if ([[sender currentTitle] isEqualToString:@"Test 1"]) {
        self.aValue.text = @"0";
        self.bValue.text = @"-2";
        self.cValue.text = @"1.5";
        [self.model updateVariableKeys:1];
    } else if ([[sender currentTitle] isEqualToString:@"Test 2"]) {
        self.aValue.text = @"0";
        self.bValue.text = @"-0.5";
        self.cValue.text = @"0.14";
        [self.model updateVariableKeys:2];
    } else if ([[sender currentTitle] isEqualToString:@"Test 3"]) {
        self.aValue.text = @"0";
        self.bValue.text = @"-9";
        self.cValue.text = @"1.11";
        [self.model updateVariableKeys:3];
    }
}

- (IBAction)buttonPressedWithSound:(id)sender {
    SystemSoundID soundID;
    NSString *soundFile = [[NSBundle mainBundle]
                           pathForResource:@"tap-crisp" ofType:@"aif"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
    AudioServicesPlaySystemSound(soundID);
}
@end