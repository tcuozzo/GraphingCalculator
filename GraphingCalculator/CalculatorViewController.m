//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Tim on 25/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@implementation CalculatorViewController

-(CalculatorBrain *)brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

-(IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber) 
    {
        display.text = [display.text stringByAppendingString:digit];
    }
    else
    {
        display.text = digit;
         userIsInTheMiddleOfTypingANumber = YES;
    }
}

-(IBAction)decimalPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber)
    {
        if([display.text rangeOfString:digit].location == NSNotFound)
        {
            display.text = [display.text stringByAppendingString:digit];
    
        }
    }
    else
    {
        display.text = @"0.";
        userIsInTheMiddleOfTypingANumber = YES;
    }
}


-(IBAction)operationPressed:(UIButton *)sender
{
    if(userIsInTheMiddleOfTypingANumber)
    {
        [self brain].operand = [display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    NSString *operation = sender.titleLabel.text;
    [[self brain] performOperation:operation];
    [self updateDisplayExpression];
}


- (IBAction)variablePressed:(UIButton *)sender
{
    NSString *variable = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber == NO)
    {
        [[self brain] setVariableAsOperand:variable];
        
        [self updateDisplayExpression];
        
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    
}

- (IBAction)clearPressed:(UIButton *)sender
{
    [[self brain] clearAll];
    userIsInTheMiddleOfTypingANumber = NO;
    [self updateDisplayExpression];
}

- (IBAction)solvePressed:(UIButton *)sender
{
    NSMutableDictionary *testVariables = [[NSMutableDictionary alloc] init ];
    
    [testVariables autorelease];
    
    if (!userIsInTheMiddleOfTypingANumber)
    {
    
        [testVariables setObject:[NSNumber numberWithInt:5] forKey:@"$x"];
        [testVariables setObject:[NSNumber numberWithInt:3] forKey:@"$y"];
        [testVariables setObject:[NSNumber numberWithInt:1] forKey:@"$z"];
    
        // add an equals command to the end, to ensure final solution is calculated
        [[self brain] performOperation:@"="];
    
        display.text = [NSString stringWithFormat:@"%@ %g", 
                        [CalculatorBrain descriptionOfExpression:[self brain].expression],
                        [CalculatorBrain evaluateExpression:[self brain].expression usingVariableValues:testVariables]];
    }
    
}

- (void)updateDisplayExpression
{
    if ( [CalculatorBrain variablesInExpression:[self brain].expression] != nil )
    {
        display.text = [CalculatorBrain descriptionOfExpression:[self brain].expression];
        
    }
    else
    {
        display.text = [NSString stringWithFormat:@"%g", [self brain].result];
    }
    
}


-(void)dealloc
{
    [display release];
    [brain release];
    [super dealloc];
}

@end
