//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Tim on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject {
    
    double operand;
    double result;
    double waitingOperand;
    
    NSString *waitingOperation;
    NSMutableArray *internalExpression;
    
    double memoryOperand;
    
    id expression;
    
}

@property (nonatomic) double operand;
@property (readonly) double result;
@property double waitingOperand;
@property double memoryOperand;
@property (readonly ) id expression;

-(void)clearAll;

-(void)setVariableAsOperand:(NSString *)variableName;
-(void)performOperation:(NSString *)operation;

+(double)evaluateExpression:(id)anExpression
        usingVariableValues:(NSDictionary *)variables;

+(NSSet *)variablesInExpression:(id)anExpression;
+(NSString *)descriptionOfExpression:(id)anExpression;

+(id)propertyListForExpression:(id)anExpression;
+(id)expressionForPropertyList:(id)propertyList;


@end
