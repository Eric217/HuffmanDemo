//
//  xcept.hpp
//  3.1
//
//  Created by Eric on 07/11/2017.
//  Copyright © 2017 INGStudio. All rights reserved.
//

#ifndef xcept_hpp
#define xcept_hpp
#include <iostream>
 
#define ZERO_SIGN '0'
#define LEFT_HIGH 1
#define SPLIT "，"
#define HFMLEFTPATH '0'
#define HFMRIGHTPATH '1'
 
NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
unsigned long Encoding = 4;

using namespace std;

class OutOfBounds {};
class NoMemory {};

#endif /* xcept_hpp */
