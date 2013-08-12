//
//  Calculator.m
//  Calculator
//
//  Created by Keith Lee on 1/4/13.
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

#import <objc/runtime.h>
#import "Calculator.h"

@implementation Calculator

- (NSNumber *) sumAddend1:(NSNumber *)adder1 addend2:(NSNumber *)adder2
{
  NSLog(@"Invoking method on %@ object with selector %@", [self className],
        NSStringFromSelector(_cmd));
  return [NSNumber numberWithInteger:([adder1 integerValue] +
                                      [adder2 integerValue])];
}

- (NSNumber *) sumAddend1:(NSNumber *)adder1 :(NSNumber *)adder2
{
  NSLog(@"Invoking method on %@ object with selector %@", [self className],
        NSStringFromSelector(_cmd));
  return [NSNumber numberWithInteger:([adder1 integerValue] +
                                      [adder2 integerValue])];
}

id absoluteValue(id self, SEL _cmd, id value)
{
  NSInteger intVal = [value integerValue];
  if (intVal < 0)
  {
    return [NSNumber numberWithInteger:(intVal * -1)];
  }
  return value;
}

+ (BOOL) resolveInstanceMethod:(SEL)aSEL
{
  NSString *method = NSStringFromSelector(aSEL);

  if ([method hasPrefix:@"absoluteValue"])
  {
    class_addMethod([self class], aSEL, (IMP)absoluteValue, "@@:@");
    NSLog(@"Dynamically added instance method %@ to class %@", method,
          [self className]);
    return YES;
  }
  return [super resolveInstanceMethod:aSEL];
}

@end
