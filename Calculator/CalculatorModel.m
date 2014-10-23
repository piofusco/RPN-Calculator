//
//  CalculatorModel.m
//  Calculator
//
//  Created by Michael on 5/20/14.
//  Copyright (c) 2014 Gideon LTD. All rights reserved.
//

#import "CalculatorModel.h"
#import "math.h"

@interface CalculatorModel()
@property (nonatomic) BOOL pivot;
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *variableDictionary;
@end

@implementation CalculatorModel

- (NSMutableArray *)programStack {
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
- (NSMutableDictionary *)variableDictionary {
    if (!_variableDictionary) _variableDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    return _variableDictionary;
}

- (id)program { return [self.programStack copy]; }

- (void)pushOperator:(NSString *)operator { [self.programStack addObject:operator]; }

- (void)pushOperand:(double)operand { [self.programStack addObject:[NSNumber numberWithDouble:operand]];}

- (void)pushVariable:(NSString *)variable withValue:(NSNumber *)value{
    [self.programStack addObject:variable];
    [self.variableDictionary setObject:value forKey:variable];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorModel runProgram:self.program usingVariableValues:self.variableDictionary];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if(program && [variableValues count] == 0) {
        stack = [program mutableCopy];
        return [self popOperandOffStack:stack];
    } else {
        stack = [program mutableCopy];
        for (int x = 0; x < [stack count]; x++) {
            if ([[stack objectAtIndex:x] isKindOfClass:[NSString class]]) {
                for (id key in variableValues) {
                    if ([[stack objectAtIndex:x] isEqualToString:key]) {
                        [stack replaceObjectAtIndex:x withObject:[variableValues objectForKey:key]];
                        break;
                    }
                }
            }
        }
        return [self popOperandOffStack:stack];
    }
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    if([topOfStack isKindOfClass:[NSNumber class]]) result = [topOfStack doubleValue];
    else if([topOfStack isKindOfClass:[NSString class]] ) {
        NSString * operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"÷"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self radiansToDegrees:[self popOperandOffStack:stack]]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self radiansToDegrees:[self popOperandOffStack:stack]]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self radiansToDegrees:[self popOperandOffStack:stack]]);
        } else if ([operation isEqualToString:@"log"]) result = log([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"π"]) { result = M_PI; }
        else if ([operation isEqualToString:@"e"]) { result = M_E; }
    }
    return result;
}

- (NSString *)createDescription {
    return [CalculatorModel descriptionOfProgram:self.program];
}

/*
 * Need to figure out parathesis.
 */
+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    NSString *operand;
    id left;
    id right;
    id temp;
    if (program) stack = [program mutableCopy];
    for (int y = 0; y < [stack count]; y++) {
        id x = [stack objectAtIndex:y];
        if ([x isKindOfClass:[NSString class]]) {
            if ([self isVariable:x] || [self isConstant:x]) continue;
            else if ([self isBinaryOperation:x]) {
                right = [[stack objectAtIndex:y-1] description];
                left = [[stack objectAtIndex:y-2] description];
                temp = [self combineBinary:x withLeft:left withRight:right];
                [stack replaceObjectAtIndex:y withObject:temp];
                [stack removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, y)]];
                y--; y--;
                continue;
            } else if ([self isUniaryOperation:x]) {
                operand = [[stack objectAtIndex:y-1] description];
                temp = [self combineUniary:x withOperand:operand];
                [stack replaceObjectAtIndex:y withObject:temp];
                [stack removeObjectAtIndex:y-1];
                // Need to set y to something else
                continue;
            }
        }
    }
    return [self buildDescription:stack];
}

+ (BOOL)isConstant:(NSString *)constant {
    return [[NSSet setWithObjects:@"π", @"e", nil] containsObject:constant];
}
+ (BOOL)isVariable:(NSString *)variable {
    return [[NSSet setWithObjects:@"a", @"b", @"c", nil] containsObject:variable];
}
+ (BOOL)isBinaryOperation:(NSString *)operation {
    return [[NSSet setWithObjects:@"+", @"-", @"*", @"÷", nil] containsObject:operation];
}
+ (BOOL)isUniaryOperation:(NSString *)operation {
    return [[NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", nil] containsObject:operation];
}


+ (NSString *)combineBinary:(NSString *)operation withLeft:(NSString *)left withRight:(NSString *)right {
    return [left stringByAppendingString:[operation stringByAppendingString:right]]; // Need to fix when switching between +/- and */÷
}
+ (NSString *)combineUniary:(NSString *)operation withOperand:(NSString *)operand { // spaces or no spaces?
    return [operation stringByAppendingString:[@"(" stringByAppendingString:[operand stringByAppendingString:@")"]]];
}
+ (NSString *)buildDescription:(id)program {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *returnString =@"";
    for (id x in program)
        if ([x isKindOfClass:[NSString class]]) {//Cluster
            returnString = [returnString stringByAppendingString:[x stringByAppendingString:@" "]];
        } else if ([x isKindOfClass:[NSNumber class]]) { //Number
            returnString = [returnString stringByAppendingString:[formatter stringFromNumber:x]];
            returnString = [returnString stringByAppendingString:@" "];
        }
    return returnString;
}

/*
 * Test this later.
 */
+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet * result = [[NSMutableSet alloc] init];
    NSMutableArray *stack;
    if(program) stack = [program mutableCopy];
    int count = 0;
    for (NSString *variable in stack) {
        if ([variable isEqualToString:@"a"]) {
            [result addObject:variable];
            count++;
        } else if ([variable isEqualToString:@"b"]) {
            [result addObject:variable];
            count++;
        } else if ([variable isEqualToString:@"c"]) {
            [result addObject:variable];
            count++;
        }
    }
    if (count > 0) return [result mutableCopy];
    else return nil;
}

/*
 * Rewrite this garbage.
 */
- (void)updateVariableKeys:(int)test {
    switch (test) {
        case 1: //1, -2, 1.5
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0] forKey:@"a"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:-2] forKey:@"b"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:1.5] forKey:@"c"];
            break;
        case 2: //1, -0.5, 0.14
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0] forKey:@"a"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:-0.5] forKey:@"b"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0.14] forKey:@"c"];
            break;
        case 3: //1, -9, 1.11
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0] forKey:@"a"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:-9] forKey:@"b"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:1.11] forKey:@"c"];
            break;
        default:
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0] forKey:@"a"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0] forKey:@"b"];
            [self.variableDictionary setObject:[NSNumber numberWithDouble:0] forKey:@"c"];
            break;
    }
}

- (void)clear { self.programStack = nil; }
+ (double)radiansToDegrees:(double)radians { return (radians * M_PI/ 180); }
@end