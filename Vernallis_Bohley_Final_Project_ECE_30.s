////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: (Jesse Vernallis), (A16835106)
// Partner2: (Declan Bohley), (A16754281)

////////////////////////
//                    //
//       main         //
//                    //
////////////////////////

    // Print Input Array
    lda x0, arr1        // x0 = &list1
    lda x1, arr1_length // x1 = &list1_length
    ldur x1, [x1, #0]   // x1 = list1_length
    bl printList

    // Test Swap Function
    bl printSwapNumbers // print the original values
    lda x0, swap_test   // x0 = &swap_test[0]
    addi x1, x0, #8     // x1 = &swap_test[1]
    bl Swap             // Swap(&swap_test[0], &swap_test[1])
    bl printSwapNumbers // print the swapped values

    // Test GetNextGap Function
    addi x0, xzr, #1    // x0 = 1
    bl GetNextGap       // x0 = GetNextGap(1) = 0
    putint x0           // print x0
    addi x1, xzr, #32   // x1 = ' '
    putchar x1          // print x1

    addi x0, xzr, #6    // x0 = 6
    bl GetNextGap       // x0 = GetNextGap(6) = 3
    putint x0           // print x0
    addi x1, xzr, #32   // x1 = ' '
    putchar x1          // print x1

    addi x0, xzr, #7    // x0 = 7
    bl GetNextGap       // x0 = GetNextGap(7) = 4
    putint x0           // print x0
    addi x1, xzr, #10   // x1 = '\n'
    putchar x1          // print x1


    // Test inPlaceMerge Function
    lda x0, merge_arr_length // x1 = &merge_arr1_length
    ldur x0, [x0, #0]        // x0 = merge_arr1_length
    bl GetNextGap            // x0 = GetNextGap(merge_arr1_length)
    addi x2, x0, #0          // x2 = x0 = gap
    lda x0, merge_arr        // x0 = &merge_arr1
    lda x3, merge_arr_length // x3 = &merge_arr1_length
    ldur x3, [x3, #0]        // x3 = merge_arr1_length
    subi x3, x3, #1          // x3 = x3 - 1     to get the last element
    lsl x3, x3, #3           // x3 = x3 * 8 <- convert length to bytes
    add x1, x3, x0           // x1 = x3 + x0 <- x1 = &merge_arr1[0] + length in bytes
    bl inPlaceMerge          // inPlaceMerge(&merge_arr1[0], &merge_arr1[0] + length in bytes, gap)
    lda x0, merge_arr
    lda x1, merge_arr_length // x1 = &merge_arr1_length
    ldur x1, [x1, #0]        // x1 = list1_length
    bl printList             // print the merged list


    // Test MergeSort Function
    lda x0, arr1            // x0 = &merge_arr1
    lda x2, arr1_length     // x2 = &merge_arr1_length
    ldur x2, [x2, #0]       // x2 = merge_arr1_length
    subi x2, x2, #1         // x2 = x2 - 1     to get the last element
    lsl x2, x2, #3          // x2 = x2 * 8 <-- convert length to bytes
    add x1, x2, x0          // x1 = x2 + x0 <-- x1 = &merge_arr1[0] + length in bytes
    bl MergeSort            // inPlaceMerge(&merge_arr1[0], &merge_arr1[0] + length in bytes, gap)
    lda x1, arr1_length     // x1 = &list1_length
    ldur x1, [x1, #0]       // x1 = list1_length
    bl printList            // print the merged list


    // [BONUS QUESTION] Binary Search Extension
    // load the sorted array''s start and end indices
     // print the merged list
    // Write your code here to check if each values of binary_search_queries are in the sorted array
    // You must loop through the binary_search_queries array and print 1 if the index is found else 0
    // Hint: use binary_search_query_length and binary_search_queries pointers to loop through the queries
    //       and preserve x0 and x1 values, ie. the starting and ending address which you need to pass
    //       in every function call)
    lda x0, arr1            // x0 = &merge_arr1
    lda x2, arr1_length     // x2 = &merge_arr1_length
    ldur x2, [x2, #0]       // x2 = merge_arr1_length
    subi x2, x2, #1         // x2 = x2 - 1     to get the last element
    lsl x2, x2, #3          // x2 = x2 * 8 <-- convert length to bytes
    add x1, x2, x0 

    lda x5, binary_search_query_length //load length
    lda x6 ,binary_search_queries      //
    ldur x5, [x5, #0] // load value of query length
    SUBI SP, SP, #32  //allocate stck to save x5 and x6
ltloop:
    CMPI x5, #0       //if legnth = 0
    B.EQ ltloopdone   // finnish loop


    STUR X5, [SP, #0]   //save x5
	STUR X6, [SP, #8]  //save x6
    STUR X1, [SP, #16] //store x1
    STUR X0, [SP,#24] //stor x0
    LDUR X2,[X6,#0]   //load query at x6 into x2(arg2/target)

    bl bsearch            // inPlaceMerge(&merge_arr1[0], &merge_arr1[0] + length in bytes, gap)
    putint x3        // print retunr value
    addi x5, xzr, #32   // x3 = ' '
    putchar x5  // print ' '

    LDUR X5, [SP, #0]   //load x5
	LDUR X6, [SP, #8]  //load x6
    LDUR X1, [SP, #16] //load x1
    LDUR X0, [SP,#24] //load x0
    SUBI X5, X5, #1 //size = size -1
    ADDI X6, X6, #8 //go to next element in query list
    B ltloop

   
ltloopdone:
    // [BONUS QUESTION] INSERT YOUR CODE HERE
    ADDI SP,SP,#32 // deolocate stack
    stop

////////////////////////
//                    //
//        Swap        //
//                    //
////////////////////////
Swap:
    // input:
    //     x0: the address of the first value
    //     x1: the address of the second value

    swap:
		LDUR X9 [X0,#0] // stores a into X9
		LDUR X10[X1,#0] // stores b into X10
		STUR X9[X1,#0] // swaps a address
    STUR X10[X0,#0] // swaps b address
    BR LR 	

////////////////////////
//                    //
//     GetNextGap     //
//                    //
////////////////////////
GetNextGap:
    // input:
    //     x0: The previous value for gap

    // output:
    //     x0: the updated gap value

getnextgap:
		CMPI X0, #1            //if gap <= 1
		B.LE endgap           // jump to end_gap

		LSR X9, X0, #1        //X9 = gap/2
		ANDI X10, X0, #1    //X10 = gap & 1
		ADD X0, X9, X10    //X0 = ceil(gap/2)
		B donegap		        // jump to donegap
endgap:
		ADDI X0, XZR, #0   //X0 = 0
donegap:
		BR LR                      //jump back to caller


////////////////////////
//                    //
//    inPlaceMerge    //
//                    //
////////////////////////
inPlaceMerge:
    // input:
    //    x0: The address of the starting element of the first sub-array.
    //    x1: The address of the last element of the second sub-array.
    //    x2: The gap used in comparisons for shell sorting

inplacemerge:
		SUBI SP, SP, #32    //allocate new stack frame
		STUR FP, [SP, #0]   //Save the old FP in 1st element of new stack frame
		ADDI FP, SP, #24     //make new frame pointer
		STUR LR, [FP, #0]   //Store LR to previous Procedure

        CMPI X2, #1            //If gap is < 1
        B.LT donemg                //jmp to donemg

        ADD X11, XZR, X0  //X11 = start = *left
Startloop:
		LSL X10, X2, #3      //X10 = gap * 8 bits
		
        ADD X12, X11, X10 // X12 = *left + gap * 8 bits = *right
        CMP X12, X1	         //If *left + gap * 8 bits <= *end		
        B.GT endloop	         //run loop, else jmp to endloop
        LDUR X13, [X12, #0]//X13 = arr[right]
        LDUR X14, [X11, #0] //X12 = arr[left]

        CMP X14, X13          //if arr[left] > arr[right]
        B.LE elsemg	          //run if statement body, else jmp to else



        //swap function call
        STUR X0, [FP, #-8]   //store X0(start) on stack
        STUR X1, [FP, #-16]   //store X1(end) on stack
        ADD X0, XZR, X11   //arg 1 is *left
        ADD X1, XZR, X12   //arg 2 is *right
        BL swap                     //call swap(left(X0),right(X1))
        ADD X11, XZR, X0    //X11 = *left
        LDUR X0, [FP, #-8]   //loads X0(start) from stack
        LDUR X1, [FP, #-16]   //loads X1(end) from stack
elsemg:
        ADDI X11, X11, #8    //left++
        B startloop	       //jmp back to loop’s start
endloop:
		//nextGap function call
		STUR X0, [FP, #-8]   //store X0(start) on stack
        STUR X1, [FP, #-16]   //store X1(end) on stack
        ADD X0, XZR, X2      //arg 1 is gap
        BL getnextgap            //nextGap(gap:X0)
        ADD X2, XZR, X0   //X2 = new gap
        LDUR X0, [FP, #-8]   //loads X0(start) from stack
        LDUR X1, [FP, #-16]   //loads X1(end) from stack	

        //inPlaceMerge function call
        BL inplacemerge      //inPLaceMerge(arr,start:X0,end:X1,gap:X2)
	
donemg:
		LDUR LR, [FP, #0]   //Loads in previous procedure’s LR, 
		LDUR FP, [FP, #-24]  //restore old frame pointer
		ADDI SP, SP, #32    //deallocate stack frame for this procedure
		BR LR                      //jump back to caller




////////////////////////
//                    //
//      MergeSort     //
//                    //
////////////////////////
MergeSort:
    // input:
    //     x0: The starting address of the array.
    //     x1: The ending address of the array

mergesort:

		SUBI SP, SP, #64    //allocate new stack frame
		STUR FP, [SP, #0]   //Save the old FP in 1st element of new stack frame
		ADDI FP, SP, #56     //make new frame pointer
		STUR LR, [FP, #0]   //Store LR to previous Procedure

		CMP X0, X1 // if start == end return
		B.EQ donems


        ADD X9, X1, X0  //X9 = end+begin
        LSR X9, X9, #3  //x9 = X9/8 = len of array
        //divide len of array/2
        LSR X9, X9, #1        //X9 = gap/2
		LSL X9, X9, #3  //x9 = X9*8 = len of middle of array in bytes
		
		// function  call mergesort(start,mid)
		STUR X1,[FP,#-16] // stores end
		STUR X9,[FP,#-24] // stores mid

		ADD X1, X9, XZR // changes argument for recursion
		BL mergesort
		
		LDUR X1,[FP,#-16] // loads end
		LDUR X9,[FP,#-24] // loads mid
		
		// function call mergesort(mid +1, end)

		STUR X0,[FP,#-8] // store start
	
		ADDI X0,X9,#8 // make mid +1 into  arg 1
		BL mergesort

		LDUR X0,[FP,#-8] // reload start

		SUB X10, X1,X0 // end - start in X10
		LSR X10, X10, #3       // divide by 8




		//function call getnextgap
		STUR X0,[FP,#-8] // stores start
		ADDI X0, X10,#1  // add 1
		
		BL getnextgap
		
		ADD X2, X0, XZR // gap var into X11
		LDUR X0, [FP,#-8] // restores start into here
	
		// call function inplace merge

		BL inplacemerge
		LDUR X0,[FP,#-8] // load start


donems:
	LDUR LR, [FP, #0]   //Loads in previous procedure’s LR, 
	LDUR FP, [FP, #-56]  //restore old frame pointer
	ADDI SP, SP, #64    //deallocate stack frame for this procedure
	BR LR                      //jump back to caller


////////////////////////
//                    //
//      [BONUS]       //
//   Binary Search    //
//                    //
////////////////////////
    // input:
    //     x0: The starting address of the sorted array.
    //     x1: The ending address of the sorted array
    //     x2: The value to search for in the sorted array
    // output:
    //     x3: 1 if value is found, 0 if not found

    // INSERT YOUR CODE HERE

bsearch:  
	SUBI SP, SP, #16  //allocate the new stack frame
	STUR FP, [SP, #0] //Save the old FP in 1st element of new stack frame
	ADDI FP, SP, #8  //make new frame pointer
	STUR LR, [FP, #0] //Store LR to previous Procedure

    CMP X1, X0   //if right >= left
    B.LT ltfalse  // body underneath

    //int mid = left + (right - left) /2
    SUB X11, X1, X0  // X11 = *right - *left
    LSR X11, X11, #3 // X11 == right - left
    LSR X11, X11, #1  // X11 = (right - left) /2
    LSL X11, X11, #3  // X11 = *(right - left) /2
    ADD X11, X0, X11  // *mid = *left + *(right - left) /2

    //Calculate arr[mid]
    LDUR X13, [X11,#0] // X13 = arr[mid]

    CMP X13,X2 //if arr[mid] == target
    B.NE nottarget      // return true

    //return true
    ADDI X3, XZR, #1 
    B donelt

nottarget:
    CMP X13,X2 //if arr[mid] > target
    B.LE notgtarget      // return binarySearch(arr,left, mid-1,target)

    // return binarySearch(arr,left, mid-1,target) 
    //no arguments to store due to return call
    //set arugments for function call
    //X0 is already left, X3 is already target
    SUBI X1, X11, #8 // arg1 adress of mid -1
    BL bsearch // call bsearch function

    B donelt // return the value, since return value is already in X3, no operation needed

notgtarget:
    //retun binarySearch(arr,mid+1,right,target);
    ////no arguments to store due to return call
    //set arguments for function call
    ADDI X0, X11, #8
    //X1 is already right adressm X2 is alreday target
    BL bsearch // call bsearch function

    B donelt // return the value, since return value is already in X3, no operation needed

ltfalse:
    ADDI X3, XZR, #0 //return false
	
 donelt: 
	LDUR LR, [FP, #0]   //Loads in previous procedure’s LR, 
	LDUR FP, [FP, #-8] //restore old frame pointer
	ADDI SP, SP, #16     //deallocate stack frame for this procedure
    BR LR

////////////////////////
//                    //
//     printList      //
//                    //
////////////////////////

printList:
    // x0: start address
    // x1: length of array
    addi x3, xzr, #32       // x3 = ' '
    addi x4, xzr, #10       // x4 = '\n'
printList_loop:
    subis xzr, x1, #0       // if (x1 == 0) break
    b.eq printList_loopEnd  // break
    subi x1, x1, #1         // x1 = x1 - 1
    ldur x2, [x0, #0]       // x2 = x0->val
    putint x2               // print x2
    addi x0, x0, #8         // x0 = x0 + 8
    putchar x3              // print x3 ' '
    b printList_loop        // continue
printList_loopEnd:
    putchar x4              // print x4 '\n'
    br lr                   // return


////////////////////////
//                    //
//  helper functions  //
//                    //
////////////////////////
printSwapNumbers:
    lda x2, swap_test   // x0 = &swap_test
    ldur x0, [x2, #0]   // x1 = swap_test[0]
    ldur x1, [x2, #8]   // x2 = swap_test[1]
    addi x3, xzr, #32   // x3 = ' '
    addi x4, xzr, #10   // x4 = '\n'
    putint x0           // print x1
    putchar x3          // print ' '
    putint x1           // print x2
    putchar x4          // print '\n'
    br lr               // return
