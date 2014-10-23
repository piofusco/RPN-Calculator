//
//  CalculatorModel.h
//  Calculator
//
//  Created by Michael on 5/20/14.
//  Copyright (c) 2014 Gideon LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorModel : NSObject

@property (readonly) id program;

- (void)pushOperator:(NSString *)operator;
- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable withValue:(NSNumber *)value;

- (double)performOperation:(NSString *)operation;
- (NSString *)createDescription;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;

- (void)updateVariableKeys:(int)test;
- (void)clear;
+ (double)radiansToDegrees:(double)radians;
@end
