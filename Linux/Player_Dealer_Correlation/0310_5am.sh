#!/bin/bash
grep "5:00:00 AM" 0310_Dealer_schedule > list.txt

 awk -F" " '{print $1, $2, $5, $6}' list.txt >> Dealers_working_during_losses 
