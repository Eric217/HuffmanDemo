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

using namespace std;

class OutOfBounds {};
class NoMemory {};


//
//void my_new_handler() {
//    throw NoMem();
//}
//
//new_handler old_handler = set_new_handler(my_new_handler);


#endif /* xcept_hpp */
