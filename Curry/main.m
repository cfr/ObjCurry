//
// main.m
// Curry
//
// Copyright (C) 2012 Lukhnos Liu.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "NSObject+Curry.h"

@interface Foo : NSObject
- (id)addNumber:(id)a withNumber:(id)b;
- (int)add:(int)x with:(int)y;
- (double)multiply:(double)x withDouble:(double)y dividedBy:(double)z;
@end

@implementation Foo
- (id)addNumber:(id)a withNumber:(id)b
{
    double x = [a doubleValue];
    double y = [b doubleValue];
    return [NSNumber numberWithDouble:x + y];
}

- (int)add:(int)x with:(int)y
{
    return x + y;
}

- (double)multiply:(double)x withDouble:(double)y dividedBy:(double)z
{
    return (x * y) / z;
}
@end


// declare the methods generated by currying to suppress compiler error caused by double return type
@interface NSObject ()
- (id)addNumber:(id)a;
- (id)withNumber:(id)b;
@end

@interface NSObject ()
- (id)add:(int)x;
- (int)with:(int)y;
@end

@interface NSObject ()
- (id)multiply:(double)x;
- (id)withDouble:(double)y;
- (double)dividedBy:(double)z;
@end

int main (int argc, const char * argv[])
{
    @autoreleasepool {
        [[Foo class] curry:@selector(addNumber:withNumber:)];
        [[Foo class] curry:@selector(add:with:)];
        [[Foo class] curry:@selector(multiply:withDouble:dividedBy:)];


        Foo *foo = [[[Foo alloc] init] autorelease];
        NSNumber *x = [NSNumber numberWithDouble:10.0];
        NSNumber *y = [NSNumber numberWithDouble:20.0];
        NSNumber *z = [foo addNumber:x withNumber:y];
        NSLog(@"x: %f, y: %f, x + y = z: %f", [x doubleValue], [y doubleValue], [z doubleValue]);

        id fooAddX = [foo addNumber:x];

        y = [NSNumber numberWithDouble:30.0];
        z = [fooAddX withNumber:y];
        NSLog(@"x: %f, y: %f, x + y = z: %f", [x doubleValue], [y doubleValue], [z doubleValue]);

        y = [NSNumber numberWithDouble:40.0];
        z = [fooAddX withNumber:y];
        NSLog(@"x: %f, y: %f, x + y = z: %f", [x doubleValue], [y doubleValue], [z doubleValue]);

        int p = 10;
        int q = 20;
        int r = [foo add:p with:q];
        NSLog(@"p: %d, q: %d, p + q = r: %d", p, q, r);
        id fooAddP = [foo add:p];

        q = 30;
        r = [fooAddP with:q];
        NSLog(@"p: %d, q: %d, p + q = r: %d", p, q, r);

        q = 40;
        r = [fooAddP with:q];
        NSLog(@"p: %d, q: %d, p + q = r: %d", p, q, r);

        double i = 10;
        double j = 20;
        double k = 5;
        double l = [foo multiply:i withDouble:j dividedBy:k];
        NSLog(@"i: %f, j: %f, k: %f, l = i * j / k = %f", i, j, k, l);

        id multiplyByI = [foo multiply:i];
        j = 30;
        k = 6;
        l =  [[multiplyByI withDouble:j] dividedBy:k];
        NSLog(@"i: %f, j: %f, k: %f, l = i * j / k = %f", i, j, k, l);

        id multiplyByIWithJ = [multiplyByI withDouble:j];
        k = 10;
        l = [multiplyByIWithJ dividedBy:k];
        NSLog(@"i: %f, j: %f, k: %f, l = i * j / k = %f", i, j, k, l);
    }

    return 0;
}
