#######################################################################
#             Advanced Processors: MIPS II Assignment
# Code Authors: Ellisa Booker, Memuna Sillah, Sai Bhargavi Bandaru, Juleen Adams 

#######################################################################
# Initialize variables
#######################################################################
.data       
text: .asciiz "\n******************** MIPS II ********************"    #Display
text1: .asciiz "\nEnter an expression to evaluate: "       
inputString: .space 64    # set aside 64 bytes to store the input string
prompt: .asciiz "\n >>> " #prompt the user to enter something
allowedCharacters:.asciiz "()0123456789+-*/=" # List of allowed characters
allowedOperands: .asciiz "123456789"
allowedOperands2:.asciiz "0123456789"
invalid: .asciiz "Invalid input\n"
valid: .asciiz   "Valid input\n"
resultString: .space 64

#######################################################################
# Main Functions
#######################################################################
.text

main:
j  cleanAllRegisters1
main1:
    # Display text    
    la $a0, text  #
    li $v0, 4    # system call code to print a string to console
    syscall  #execute the above command
     
    again:                   
    # Display text1    
    la $a0, text1  #
    li $v0, 4    # system call code to print a string to console
    syscall  #execute the above command    
     
    # Display prompt    
    la $a0, prompt  # display the prompt to begin
    li $v0, 4    # system call code to print a string to console
    syscall  #execute the above command

    # get the string from console
    la $a0, inputString    # load $a0 with the address of inputString; procedure: $a0 = buffer,    $a1 = length of buffer
    la $a1, inputString    # maximum number of character/ size
    li $v0, 8    # The system call code to read a string input
    syscall  #execute the above command
          
    move $t0, $a0 # lets move the address of the user input to a temporary location
    
    la $t1,allowedCharacters #moving the address of the allowed characters to register
    #la $t0,inputString #moving the address of the user input to a register
    la $t7,allowedCharacters # will be used to reset my allowed character register back to the beginning
    la $t8,inputString #This will be used to reset the inputString
    la $t9,allowedOperands #Stores the allowed operand values
    j nextstep
################################The start of MIPS 2 CODE #####################################
######################################################################################################
   main2:
    jal cleanAllRegisters
     Nextloop:     
    li $t8, 0    #This is a counter variable. It will reset everytime we get a new input
    # take string input
    la    $a0, inputString    # load $a0 with the address of inputString; procedure: $a0 = buffer, $a1 = length of buffer
    la    $a1, inputString    # maximum number of character
   # li    $v0, 8    # The system call code to read a string input
   # syscall

 #  jal parenthesesDeteced        
  #  beq $t2, $zero,NOParenthesesfound             
   # NOParenthesesfound:
 
                             
str2num:
    la    $a0, inputString
    li    $t1, 0    # $t1 = 0
    li    $t2, 0    # t2 = 0
    li     $t0,0
    
getFirstNum:
    lb    $t1, ($a0)     # load byte
####    Operator checks
    li $t6, 42 # Checking for "*"
    beq $t1, $t6, operatorReached

    li $t6, 43   # Checking for "+"
    beq $t1, $t6, operatorReached

    li $t6, 45 # Checking for "-"
    beq $t1, $t6, operatorReached

    li $t6, 47 # Checking for "/"
    beq $t1, $t6, operatorReached     
###
    mul    $t2, $t2, 10    
    sub    $t1, $t1, 0x30    # if not end of string, get the digit
    addu    $t2, $t2, $t1    # move digit to $t2
    addu    $a0, $a0, 1
    j    getFirstNum

getSecondNum:
    lb    $t1, ($a0)     # load byte
    beq    $t1, 10, storeSecondNum    # if byte = new line, i.e., end of string
####    Operator checks
    li $t6, 42 # Checking for "*"
    beq $t1, $t6, operatorReached

    li $t6, 43   # Checking for "+"
    beq $t1, $t6, operatorReached

    li $t6, 45 # Checking for "-"
    beq $t1, $t6, operatorReached

    li $t6, 47 # Checking for "/"
    beq $t1, $t6, operatorReached     
###
    mul    $t3, $t3, 10    
    sub    $t1, $t1, 0x30    # if not end of string, get the digit
    addu    $t3, $t3, $t1    # move digit to $t2
    addu    $a0, $a0, 1
    j    getSecondNum

getThirdNum:
    lb    $t1, ($a0)     # load byte
    beq    $t1, 10, storeThirdNum    # if byte = new line, i.e., end of string
####    Operator checks
    li $t6, 42 # Checking for "*"
    beq $t1, $t6, operatorReached

    li $t6, 43   # Checking for "+"
    beq $t1, $t6, operatorReached

    li $t6, 45 # Checking for "-"
    beq $t1, $t6, operatorReached

    li $t6, 47 # Checking for "/"
    beq $t1, $t6, operatorReached     
###
    mul    $t4, $t4, 10    
    sub    $t1, $t1, 0x30    # if not end of string, get the digit
    addu    $t4, $t4, $t1    # move digit to $t2
    addu    $a0, $a0, 1
    j    getThirdNum

getFourthNum:
    lb    $t1, ($a0)     # load byte
    beq    $t1, 10, storeFourthNum    # if byte = new line, i.e., end of string
    mul    $t5, $t5, 10    
    sub    $t1, $t1, 0x30    # if not end of string, get the digit
    addu    $t5, $t5, $t1    # move digit to $t2
    addu    $a0, $a0, 1
    j    getFourthNum
    
operatorReached:
# If we reach an operator in the string, we first need to store the current number in tempString
# Then, we need to reset the current tempString so it can store the next number
# Finally, we can evaluate if we have at least 2 numbers stored
    beq $t8, 0, storeFirstNum #If our counter variable is 0, we have not yet stored a number.
    beq $t8, 1, storeSecondNum #If our counter variable is 1, we have only stored the first number.
    beq $t8, 2, storeThirdNum #If our counter variable is 2, we have stored 2 numbers.            
    
storeFirstNum:
    move $s4, $t1 #s4 = first operator
    move    $s0, $t2  #s0 = value of the 1st number
    addu $t8, $t8, 1 #Increment counter variable to show number of integers stored so far
    addu    $a0, $a0, 1 #Increment position in string
    j getSecondNum

storeSecondNum:    
    move $s5, $t1 #s5 = second operator
    move $s1, $t3  #s1 = value of the 2nd number
    addu $t8, $t8, 1 #Increment counter variable to show number of integers stored so far
    addu    $a0, $a0, 1 #Increment position in string
    beq    $t1, 10, evaluate
    j getThirdNum
    
storeThirdNum:        
    move $s6, $t1 #s6 = third operator
    move $s2, $t4  #s2 = location of the 3rd number
    addu $t8, $t8, 1 #Increment counter variable to show number of integers stored so far
    addu    $a0, $a0, 1 #Increment position in string
    beq    $t1, 10, evaluate
    j getFourthNum

storeFourthNum:
    move $s3, $t5  #s3 = location of the 4th number
    addu $t8, $t8, 1 #Increment counter variable to show number of integers stored so far
    addu    $a0, $a0, 1 #Increment position in string
    j evaluate

evaluate:
    beq $t8,$t0, next
    beq $t0,2, evaluate3rdOperand
    beq $t0,3, evaluate4thOperand
    
    li $t5, 42 # Checking for "*"
    beq $s4, $t5, multiplyNums

    li $t5, 43   # Checking for "+"
    beq $s4, $t5, addNums

    li $t5, 45 # Checking for "-"
    beq $s4, $t5, subNums

    li $t5, 47 # Checking for "/"
    beq $s4, $t5, divideNums
        
    j evaluate

evaluate3rdOperand:
    move $s0, $s7
    move $s1, $s2
    
    li $t5, 42 # Checking for "*"
    beq $s5, $t5, multiplyNums

    li $t5, 43   # Checking for "+"
    beq $s5, $t5, addNums

    li $t5, 45 # Checking for "-"
    beq $s5, $t5, subNums

    li $t5, 47 # Checking for "/"
    beq $s5, $t5, divideNums
    
evaluate4thOperand:
    move $s0, $s7
    move $s1, $s3
    
    li $t5, 42 # Checking for "*"
    beq $s6, $t5, multiplyNums

    li $t5, 43   # Checking for "+"
    beq $s6, $t5, addNums

    li $t5, 45 # Checking for "-"
    beq $s6, $t5, subNums

    li $t5, 47 # Checking for "/"
    beq $s6, $t5, divideNums

    
subNums:    
    sub $s7, $s0, $s1   #Add the first and second number
    addi $t0, $t0, 1
    j evaluate

addNums:    
    add $s7, $s0, $s1  
    addi $t0, $t0, 1
    j evaluate

multiplyNums:
    mul $s7,$s0, $s1
    addi $t0, $t0, 1
    j evaluate
    
divideNums:
    div $s7, $s0, $s1    
    addi $t0, $t0, 1
    j evaluate
                
next:  
add $a0,$zero, $zero
li $v0, 1
move $a0, $s7
syscall
 
  j main
    
                          
 cleanAllRegisters:  ######### lets reset all of our register
 li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    li $t9, 0
    li $s0, 0
    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0
    j  Nextloop
    
    
cleanAllRegisters1:  ######### lets reset all of our register
 li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    li $t9, 0
    li $s0, 0
    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0
    j main1
 #parenthesesDeteced:                                                                                           
  #  lb $t1, ($t0)
#    beq $t1, 40, foundAparenthesis
#    beq $t1, 41, stoplooking
#    beq $t1, 0xa, stoplooking
#    addi $t0, $t0, 1
#    j  parenthesesDeteced                                              
# foundAparenthesis:
#     li $t2, 1
#    la $s0, ($t0)
#    addi $t0, $t0, 1                                                   
#    j parenthesesDeteced                                                      
                                                              
 #  stoplooking:
#    la $s1, ($t0)
#    jr $ra                                                               
                                                                                                                                                         
                                                                                                                                                                                                                                                              
##################################################################### This is MIPS 1 PART 3 CODE ########################################                                                                                                                                                                                                                                                                          
 ######################################- now we check the character byte by bye for errors
 nextstep:
  lb $t2,($t0) # loading a character from the inputString
  lb $t4, ($t1) #loading a character from the allowed characters list
  beq $t6, -1, invalidInput # Checking for inbalance of parenthesis.
  beq $t2, 10, validInput    # IF at end of input string, chars are all valid
  beq $t2, 40, leftperentesis #  checks for "("
  beq $t2, 41, rightperentesis # checks for ")"
  beq $t2, 42, Tracker # Checking for "*"
  beq $t2, 43, Tracker # Checking for "+"
  beq $t2, 45, Tracker # Checking for "-"
  beq $t2, 47, Tracker # Checking for "/"    
  beq $t2, 32, space # Checking for "space"  
 
  #addi $sp, $sp, -12 # adjust stack to make room for 3 items
  #sw $t1, 8($sp) # save register $t1 for use afterwards
  #sw $t0, 4($sp) # save register $t0 for use afterwards
  #sw $s0, 0($sp) # save register $s0 for use afterwards
 
  bne $t2, $t4,nextchar #if the char from the string is not equal to the allowed character
      
 
  j keeps
  nextchar: # testing all the allowed character
  addi $t1, $t1, 1 # Look at the next allowed character (shift)
  beq $t1, $zero, invalidInput # your at the end of  the allowed character list
    j nextstep  # keep jumping until it equals  to the allowed character  
      
 keeps:
  addi $t0, $t0, 1 #shift right, go to the next character in the string
  move $t1,$t7  # reset the the allowed character  - start from the beginning of the list
  j nextstep  
 
  validInput:   
   sge $t2, $t6, 1
   beq $t2, 1, invalidInput
    
      # Print "Valid input" to console
    la $a0, valid   
    li $v0, 4
    syscall
    add $t6, $zero, $zero # Resetting parenthesis counter
    j  main2
invalidInput:
    # Print "Invalid input" to console
    la $a0, invalid   
    li $v0, 4
    syscall
    add $t6, $zero, $zero # Resetting parenthesis counter
    j again
    
   ######################
     Tracker:
    addi $t0, $t0, 1 # Looking at character ahead
    j  checkotherOperator

    checkotherOperator:     
    lb $t2,($t0) # loading the next character
    li $t5, 40 # Checking for "("
    beq $t2, $t5, leftperentesis

    li $t5, 41 # Checking for ")"
    beq $t2, $t5, invalidInput

    li $t5, 42 # Checking for "*"
    beq $t2, $t5, invalidInput

    li $t5, 43   # Checking for "+"
    beq $t2, $t5, invalidInput

    li $t5, 45 # Checking for "-"
    beq $t2, $t5, invalidInput

    li $t5, 47 # Checking for "/"
    beq $t2, $t5, invalidInput
    
    li $t5, 32 # Checking for space
    beq $t2, $t5, space
    
 j  nextstep
   #################################################################Creating the left perentesis #####################

   leftperentesis:
     addi $t6, $t6, 1 # $t6 is the register that will track the proper amount of parenthesis. If left, +1
     addi $t0, $t0, 1 #  find the character after the left perentesis
     lb $t2, ($t0) # loading that next character
     la $s0, allowedOperands2# loading the address of allowedOperands2 to $s0
     la $s2,allowedOperands # loading the address of allowedOperands2 to $s2
     
     loop1: ###-- we want to check what is after the left perentesis --- checking for (H (a
    lb $s1, ($s0) # Loading the character from allowedOperands2 to $s1
    beq $s1, $zero, preOperatorleft #check the insides for operands like *-+/
    beq $t2, $s1,  nextpep # If the next character is equal to the allowedOperands2
    bne $t2, $s1, nextOp # Move to next character in allowedOperands2 list to compare
    
    nextpep:
    addi $t0, $t0, -2 #-2  means find the character before the left parenthesis
    j loop2 #If this is the end of the allowedOperands2 list
 
      loop2: ### checking what is before the left parenthesis --- checking for  2( a(
    lb $s1, ($s2) # Loading the character from allowedOperands2 to $s1
    lb $t2, ($t0) #  load the character  in $t2
    beq $s1, $zero,  goback1
    beq $t2, $s1, invalidInput # If the character is equal to the allowedOperands then its invalid
    bne $t2, $s1, nextOp2 # Move to next character in allowedOperands list to compare
       
nextOp:
    addi $s0, $s0, 1 # Shifting to the next character in the allowedOperands2 list
    
    j loop1
nextOp2:
    addi $s2, $s2, 1 # Shifting to the next character in the allowedOperands list
    j loop2
 goback1:
 addi $t0, $t0, +2 #+2 go back to the location after the left parenthesis
    j  nextstep         
 
     preOperatorleft:     
    lb $t2,($t0) # loading the next character
    li $t5, 42 # Checking for "*"
    beq $t2, $t5, invalidInput

    li $t5, 43   # Checking for "+"
    beq $t2, $t5, invalidInput

    li $t5, 45 # Checking for "-"
    beq $t2, $t5, invalidInput

    li $t5, 47 # Checking for "/"
    beq $t2, $t5, invalidInput
    j nextpep
##############################################################Creating the right perentesis########################

  rightperentesis:  # checking the conditions of the right perentesis
       
       addi $t0, $t0, 1 #  find the character after the right perentesis  
       lb $t2, ($t0) # loading that next character
       la $s0, allowedOperands # loading the address of allowedOperands to $s0
       la $s2,allowedOperands2 # loading the address of allowedOperands2 to $s2
 
 
       loop3: ###-- we want to check what is after the  right parenthesis --- checking for )2 )a
    lb $s1, ($s0) # Loading the character from allowedOperands to $s1
    beq $t2, $s1, invalidInput # If the next character is equal to the allowedOperands
    beq $s1, $zero, loop4 # If this is end of the allowedOperands list jump to loo4 - (check for the character before the right perentesis)
    bne $t2, $s1, nextOperands # Move to next character in allowedOperands list to compare
    
    
    loop4: ### checking what is before the right parenthesis  --- checking for  a) H)
    addi $t6, $t6, -1 # -1 for a right parenthesis in the parenthesis tracking register, $t4
    addi $t0, $t0, -2 #-2  means find the character before the right perentesis
    loop5:
    lb $s1, ($s2) # Loading the character from allowedOperands2 to $s1
    lb $t2, ($t0) #  load the character that character in $t2
    beq $s1, $zero,preOperatorright # check the inside of the right perentesis for *-/
    beq $t2, $s1, goback # If the character is equal to the allowedOperands then its invalid
    bne $t2, $s1, nextOperands2 # Move to next character in allowedOperands2 list to compare
    
        
nextOperands:
    addi $s0, $s0, 1 # Shifting to the next character in the allowedOperands list
    j loop3
nextOperands2:
    addi $s2, $s2, 1 # Shifting to the next character in the allowedOperands2 list
    j loop5
        
 goback:
 addi $t0, $t0, +2 #+2 go back to the location after the right perentesis
 lb $t2, ($t0) #  load the character that character in $t2
    j  nextstep
    
    preOperatorright:     
    lb $t2,($t0) # loading the next character
    li $t5, 42 # Checking for "*"
    beq $t2, $t5, invalidInput

    li $t5, 43   # Checking for "+"
    beq $t2, $t5, invalidInput

    li $t5, 45 # Checking for "-"
    beq $t2, $t5, invalidInput

    li $t5, 47 # Checking for "/"
    beq $t2, $t5, invalidInput
     j goback

######################################################checking space ############################################
     
 space:
 
 ####  check if the operator is afer the space
  addi $t0, $t0, 1 # go to the next character after the space
  lb $t2,($t0) # loading a character from the inputString   
    li $t5, 42 # Checking for "*"
    beq $t2, $t5, continue

    li $t5, 43   # Checking for "+"
    beq $t2, $t5, continue

    li $t5, 45 # Checking for "-"
    beq $t2, $t5, continue

    li $t5, 47 # Checking for "/"
    beq $t2, $t5,continue
    bne $t2, $t5, beforespace  # nust be a number
 ##### now check if an operator is before the space
 beforespace:
 addi $t0, $t0, -2 # go to thecharacter before the space
  lb $t2,($t0) # loading a character from the inputString   
    li $t5, 42 # Checking for "*"
    beq $t2, $t5, goback  # let go back to the last position

    li $t5, 43   # Checking for "+"
    beq $t2, $t5, goback

    li $t5, 45 # Checking for "-"
    beq $t2, $t5, goback

    li $t5, 47 # Checking for "/"
    beq $t2, $t5,goback
    bne $t2, $t5, invalidInput
                                                                                                                                                                                                                                                   
 continue:
 addi $t0, $t0, 1 # Load the next character in the string
  j nextstep


