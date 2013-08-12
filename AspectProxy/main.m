//
//  main.m
//  AspectProxy
//
//  Created by Keith Lee on 1/17/13.
//  Copyright (c) 2013 Keith Lee. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//   1. Redistributions of source code must retain the above copyright notice, this list of
//      conditions and the following disclaimer.
//
//   2. Redistributions in binary form must reproduce the above copyright notice, this list
//      of conditions and the following disclaimer in the documentation and/or other materials
//      provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY Keith Lee ''AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Keith Lee OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of Keith Lee.

#import <Foundation/Foundation.h>
#import "AspectProxy.h"
#import "AuditingInvoker.h"
#import "Calculator.h"

int main(int argc, const char * argv[])
{
  @autoreleasepool
  {
    // Create Calculator object
    id calculator = [[Calculator alloc] init];
    NSNumber *addend1 = [NSNumber numberWithInteger:-25];
    NSNumber *addend2 = [NSNumber numberWithInteger:10];
    NSNumber *addend3 = [NSNumber numberWithInteger:15];

    // Create proxy for object, performs special processing in forwardInvocation:
    // for given selector
    NSValue* selValue1 = [NSValue valueWithPointer:@selector(sumAddend1:addend2:)];
    NSArray *selValues = @[selValue1];
    AuditingInvoker *invoker = [[AuditingInvoker alloc] init];
    id calculatorProxy = [[AspectProxy alloc] initWithObject:calculator
                                                   selectors:selValues
                                                  andInvoker:invoker];
    
    // Send message to proxy with given selector
    [calculatorProxy sumAddend1:addend1 addend2:addend2];

    // Now send message to proxy with different selector, no special processing!
    [calculatorProxy sumAddend1:addend2 :addend3];
    
    // Register another selector for proxy and repeat message
    [calculatorProxy registerSelector:@selector(sumAddend1::)];
    [calculatorProxy sumAddend1:addend1 :addend3];
    
  }
  return 0;
}

