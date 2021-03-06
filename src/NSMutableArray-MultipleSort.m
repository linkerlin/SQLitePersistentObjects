//
//  NSMutableArray-MultipleSort.m
//  iContractor
//
//  Created by Jeff LaMarche on 1/16/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//
// This source may be used, free of charge, for any purposes. commercial or non-
// commercial. There is no attribution requirement, nor any need to distribute
// your source code. If you do redistribute the unmodified source code, you must
// leave the original header comments, but you may add additional ones.

#import "NSMutableArray-MultipleSort.h"

@implementation NSMutableArray(MultipleSort)
- (void)sortArrayUsingSelector:(SEL)comparator withPairedMutableArrays:(NSMutableArray *)array1, ...
{
  unsigned  int   stride = 1;
        BOOL  found = NO;
  unsigned  long   count = [self count];
  unsigned  int   d;
  
  while (stride <= count)
    stride = stride * STRIDE_FACTOR + 1;
  
  while (stride > (STRIDE_FACTOR - 1))
  {
    stride = stride / STRIDE_FACTOR;
    for (unsigned int c = stride; c < count; c++)
    {
      found = NO;
      if (stride > c)
        break;
      
      d = c - stride;
      while (!found)
      {
        id      a = self[d + stride];
        id      b = self[d];
        
        NSComparisonResult  result = (*compare)(a, b, (void *)comparator);
        
        if (result < 0)
        {
          self[d + stride] = b;
          self[d] = a;
          
          id eachObject;
          va_list argumentList;
          if (array1)                     
          {   
            id a1 = array1[d+stride];
            id b1 = array1[d];
            array1[d + stride] = b1;
            array1[d] = a1;
            va_start(argumentList, array1);         
            while ((eachObject = va_arg(argumentList, id)))
            {
              id ax = eachObject[d+stride];
              id bx = eachObject[d];
              eachObject[d + stride] = bx;
              eachObject[d] = ax;
            }
            va_end(argumentList);
          }
          
          
          if (stride > d)
            break;
          
          d -= stride;  
        }
        else
          found = YES;
      }
    }
  }
}
@end
