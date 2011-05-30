//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Tim on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"$"

@implementation CalculatorBrain

@synthesize operand;
@synthesize memoryOperand;
@synthesize waitingOperand;
@synthesize result;

-(id)init
{
    // initialize the internal expression array
    internalExpression = [[NSMutableArray alloc] init];
    
    return self;    
}


-(void)setOperand:(double)newOperand
{
    operand = newOperand;
    
    //add the new operand to the internal expression as a double
    [internalExpression addObject:[NSNumber numberWithDouble:operand]];
}

-(id)expression
{
    NSMutableArray *exp = [internalExpression copy];
    
    [exp autorelease];
    
    return exp;
    
}


-(void)performWaitingOperation
{
    if([@"+" isEqual:waitingOperation])
    {
        operand = waitingOperand + operand;
    }
    else if([@"*" isEqual:waitingOperation])
    {
        operand = waitingOperand * operand;
    }
    else if([@"-" isEqual:waitingOperation])
    {
        operand = waitingOperand - operand;
    }
    else if([@"/" isEqual:waitingOperation])
    {
        if (operand) 
        {
            operand = waitingOperand / operand;
        }
    }
}


-(void)performOperation:(NSString *)operation
{
    if([operation isEqual:@"sqrt"])
    {
        operand = sqrt(operand);
    }
    else if ([@"+/-" isEqual:operation])
    {
        operand = - operand;
    }
    else if ([@"sin" isEqual:operation])
    {
        operand = sin(operand);
    }
    else if ([@"cos" isEqual:operation])
    {
        operand = cos(operand);
    }
    else if ([@"1/x" isEqual:operation])
    {
        if(operand)
        {
            operand = 1 / operand;
        }
    }
    else if ([@"Store" isEqual:operation])
    {
        memoryOperand = operand;
    }
    else if ([@"Mem +" isEqual:operation])
    {
        memoryOperand = memoryOperand + operand;
    }
    else if ([@"Recall" isEqual:operation])
    {
        operand = memoryOperand;
    }
    else
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    
    // add the new operation to the internal expression array
    [internalExpression addObject:operation];
    
    
    result = operand; 
}

-(void)clearAll
{
    [internalExpression removeAllObjects];
    
    result = 0;
    operand = 0;
    memoryOperand = 0;
    waitingOperand = 0;
    waitingOperation = nil;

}


-(void)setVariableAsOperand:(NSString *)variableName
{
    [internalExpression addObject:[VARIABLE_PREFIX stringByAppendingString:variableName]];
    
}

+(double)evaluateExpression:(id)anExpression
        usingVariableValues:(NSDictionary *)variables
{
    CalculatorBrain *localBrain = [[CalculatorBrain alloc] init];
    
    for (id object in anExpression)
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            localBrain.operand = [object doubleValue];
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            if([object rangeOfString:VARIABLE_PREFIX].location != NSNotFound)
            {
                // if the key is found, assign it the correct value
                if([variables objectForKey:object] != nil)
                {
                    localBrain.operand = [[variables objectForKey:object] doubleValue];
                }
                // if not found, return 0.  Behavior is undefined in this case and cannot be evaluated
                else
                {
                    localBrain.operand = 0;
                    break;
                }
            }
            else
            {
                [localBrain performOperation:object];
            }
            
        }
    }
    
    double returnValue = localBrain.operand;
    
    [localBrain release];
    
    return returnValue;
    
}

+(NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *localSet = [[NSMutableSet alloc] init];
    
    [localSet autorelease];
    
    for (id object in anExpression)
    {
        if ([object isKindOfClass:[NSString class]])
        {
            if(([object rangeOfString:VARIABLE_PREFIX].location != NSNotFound ) && ([object length] > 1))
            {
                NSString *variable = [NSString stringWithFormat:@"%g", [object characterAtIndex:1]];
                if([localSet member:variable] == nil)
                {
                    [localSet addObject:variable];
                }
            }
        }
    }
    
    if ([localSet count] == 0)
    {
        return nil;
    }
    else
    {
        return localSet;
    }
}

+(NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *expressionDescription = [[NSMutableString alloc] init ];
    
    [expressionDescription autorelease];
    
    for (id object in anExpression)
    {
        if([object isKindOfClass:[NSString class]])
        {
            if([object rangeOfString:VARIABLE_PREFIX].location != NSNotFound)
            {
                if([object length] > 1)
                {
                    [expressionDescription appendString:[NSString stringWithFormat:@"%c",[object characterAtIndex:1]]];
                }
            }
            else
            {
                [expressionDescription appendString:[object description]];
            }
        }
        else
        {
            [expressionDescription appendString:[object description]];
        }
        
        [expressionDescription appendString:@" "];
    }
    
    // trim trailing white space
    if ([expressionDescription length] > 0)
    {
        [expressionDescription substringToIndex:[expressionDescription length]-1];
    }
    
    return expressionDescription;
    
}

+(id)propertyListForExpression:(id)anExpression
{
    NSMutableArray *propertyList = [anExpression copy];
    
    [propertyList autorelease];
    
    return propertyList;    
}

+(id)expressionForPropertyList:(id)propertyList
{
    NSMutableArray *exp = [propertyList copy];
    
    [exp autorelease];
    
    return exp;    
}



-(void)dealloc
{
    [waitingOperation release];
    [internalExpression release];
    [expression release];
    
    [super dealloc];
    
}


@end
