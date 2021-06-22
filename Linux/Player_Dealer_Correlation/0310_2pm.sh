#!/bin/bash
grep "02:00:00 PM" 0310_Dealer_schedule > list.txt

 awk -F" " '{print $1, $2, $5, $6}' list.txt >> Dealers_working_during_losses 
