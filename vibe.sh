#!/bin/bash

clear
echo
echo
echo compiled smart contracts
echo

{
rm -R bin

solc --optimize --abi -o bin --overwrite contracts/HighVibeToken.sol 
solc --optimize --bin -o bin --overwrite contracts/HighVibeToken.sol

solc --optimize --abi -o bin --overwrite contracts/HighVibeCrowdsale.sol
solc --optimize --bin -o bin --overwrite contracts/HighVibeCrowdsale.sol

} &> /dev/null

ls -l bin/HighVibe*

echo
