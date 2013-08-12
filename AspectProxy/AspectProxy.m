//
//  AspectProxy.m
//  AspectProxy
//
//  Created by Keith Lee on 1/24/13.
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

#import "AspectProxy.h"

@implementation AspectProxy

#pragma mark -
#pragma mark Custom Initialization methods

- (id)initWithObject:(id)object selectors:(NSArray *)selectors
          andInvoker:(id<Invoker>)invoker
{
  _proxyTarget = object;
  _invoker = invoker;
  _selectors = [selectors mutableCopy];
  return self;  
}

- (id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker
{
  return [self initWithObject:object selectors:nil andInvoker:invoker];
}

#pragma mark -
#pragma mark Forward Invocation methods

/**
 * Retrieve signatures for methods to be proxied
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [self.proxyTarget methodSignatureForSelector:sel];
}

/**
 * Invoke method on proxy target, along with aspect logic
 */
- (void)forwardInvocation:(NSInvocation *)inv
{
  // Perform functionality before invoking method on target
  if ([self.invoker respondsToSelector:@selector(preInvoke:withTarget:)])
  {  
    if (self.selectors != nil)
    {
      SEL methodSel = [inv selector];
      for (NSValue *selValue in self.selectors)
      {
        if (methodSel == [selValue pointerValue])
        {
          [[self invoker] preInvoke:inv withTarget:self.proxyTarget];
          break;
        }
      }
    }
    else
    {
      [[self invoker] preInvoke:inv withTarget:self.proxyTarget];
    }
  }

  // Invoke method on target
  [inv invokeWithTarget:self.proxyTarget];
  
  // Perform functionality after invoking method on target
  if ([self.invoker respondsToSelector:@selector(postInvoke:withTarget:)])
  {
    if (self.selectors != nil)
    {
      SEL methodSel = [inv selector];
      for (NSValue *selValue in self.selectors)
      {
        if (methodSel == [selValue pointerValue])
        {
          [[self invoker] postInvoke:inv withTarget:self.proxyTarget];
          break;
        }
      }
    }
    else
    {
      [[self invoker] postInvoke:inv withTarget:self.proxyTarget];
    }
  }
}

- (void)registerSelector:(SEL)selector
{
  NSValue* selValue = [NSValue valueWithPointer:selector];
  [self.selectors addObject:selValue];  
}

@end
